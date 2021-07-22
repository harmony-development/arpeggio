# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Auth do
  defp random(len) do
    for _ <- 1..len, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  @type auth_state :: :pre_initial_screen | :initial_screen | :login | :register

  defmodule State do
    defstruct status: :pre_initial_screen
  end

  defp set_auth_state(id, state) do
    :ets.insert(:auth_sessions, {id, state})
  end
  defp auth_state(id) do
    case :ets.lookup(:auth_sessions, id) do
      [{_, %State{} = a}] -> a
      _ -> nil
    end
  end
  defp ok(val) do
    {:ok, val}
  end
  defp ok_send(val, authID) do
    Phoenix.PubSub.broadcast :arpeggio, "auth:#{authID}", val

    ok val
  end
  defp error(val) do
    {:error, val}
  end

  # begin impls

  def check_logged_in(conn, _request) do
    Arpeggio.DB.check_session conn

    {:ok, %Google.Protobuf.Empty{}}
  end

  def begin_auth(_conn, _request) do
    id = random(32)

    set_auth_state(id, %State{})

    ok %Protocol.Auth.V1.BeginAuthResponse{auth_id: id}
  end

  defp initial_choice_step do
    alias Protocol.Auth.V1.AuthStep

    %AuthStep{
      step: {:choice, %AuthStep.Choice{
        title: "initial-choice",
        options: ["login", "register"]
      }}
    }
  end
  defp login_step do
    alias Protocol.Auth.V1.AuthStep

    %AuthStep{
      step: {:form, %AuthStep.Form{
      title: "login",
      fields: [
        %AuthStep.Form.FormField{
          name: "email",
          type: "email"
        },
        %AuthStep.Form.FormField{
          name: "password",
          type: "password"
        }
      ]
    }}}
  end
  defp register_step do
    alias Protocol.Auth.V1.AuthStep

    %AuthStep{
      step: {:form, %AuthStep.Form{
      title: "register",
      fields: [
        %AuthStep.Form.FormField{
          name: "email",
          type: "email"
        },
        %AuthStep.Form.FormField{
          name: "username",
          type: "username"
        },
        %AuthStep.Form.FormField{
          name: "password",
          type: "new-password"
        }
      ]
    }}}
  end
  defp do_session(user_id, token) do
    alias Protocol.Auth.V1.Session
    alias Protocol.Auth.V1.AuthStep

    %AuthStep{
      step: {:session, %Session{
        user_id: user_id,
        session_token: token,
    }}}
  end

  defp new_id() do
    case Snowflake.next_id() do
      {:ok, val} -> val
      {:error, err} -> raise err
    end
  end

  #
  # send the initial screen
  #
  defp handle_next_step(request, %State{status: :pre_initial_screen} = s, _) do
    set_auth_state(request.auth_id, %{s | status: :initial_screen})

    ok_send initial_choice_step(), request.auth_id
  end
  #
  # handle the initial screen button click
  #
  defp handle_next_step(request, %State{status: :initial_screen} = s, {:choice, %{choice: it}}) do
    case it do
      "login" ->
        set_auth_state(request.auth_id, %{s | status: :login})
        ok_send login_step(), request.auth_id
      "register" ->
        set_auth_state(request.auth_id, %{s | status: :register})
        ok_send register_step(), request.auth_id
      _ ->
        error "bad choice"
    end
  end
  #
  # handle the login form submission
  #
  defp handle_next_step(
    request,
    %State{status: :login},
    {:form, %{fields: [%{field: {:string, email}}, %{field: {:bytes, password}}]}}
  ) do
    case Arpeggio.DB.login(email, password) do
      {:ok, _, session} ->
        ok_send do_session(session.user_id, session.id), request.auth_id
      _ ->
        error "bad credentials"
    end
  end
  #
  # handle the register form submission
  #
  defp handle_next_step(
    request,
    %State{status: :register},
    {:form, %{fields: [%{field: {:string, email}}, %{field: {:string, username}}, %{field: {:bytes, password}}]}}
  ) do
    Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: email,
      username: username,
      password: password,
    }, %Arpeggio.User{
      id: new_id()
    })
    {:ok, _, session} = Arpeggio.DB.login(email, password)

    ok_send do_session(session.user_id, session.id), request.auth_id
  end
  defp handle_next_step(
    _, _, _
  ) do
    error "bad next step"
  end

  def next_step(_conn, request) do
    handle_next_step(request, auth_state(request.auth_id), request.step)
  end

  def key(_conn, _request) do
    {:ok, %Protocol.Auth.V1.KeyReply{ key: Arpeggio.key |> Ed25519.public_key }}
  end

  def federate(conn, request) do
    session = Arpeggio.DB.get_session conn

    {:ok, user, {_, _}} = Arpeggio.DB.get_user(session.user_id)

    target = request.target

    dat = %Protocol.Auth.V1.TokenData {
      user_id: session.user_id,
      target: target,
      username: user.user_name,
      avatar: user.user_avatar
    }

    raw = dat |> Protocol.Auth.V1.TokenData.encode

    {:ok,
      %Protocol.Auth.V1.FederateReply{
        token: %Protocol.Harmonytypes.V1.Token{
          sig: raw |> Ed25519.sign(Arpeggio.key),
          data: dat
        }
      }}
  end

  def stream_steps_init(_req, state) do
    {:ok, state}
  end
  def stream_steps_req(req, state) do
    Phoenix.PubSub.subscribe :arpeggio, "auth:#{req.auth_id}"

    {:ok, state}
  end
  def stream_steps_info(info, state) do
    {:reply, info, state}
  end
end
