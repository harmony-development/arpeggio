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

  def begin_auth(_request) do
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

  def next_step(request) do
    aid = request.auth_id

    case auth_state(request.auth_id) do
      %State{status: :pre_initial_screen} = s ->
        set_auth_state(request.auth_id, %{s | status: :initial_screen})

        ok_send initial_choice_step(), aid

      %State{status: :initial_screen} = s ->
        case request.step do
          {:choice, %{choice: it}} ->
            case it do
              "login" ->
                set_auth_state(request.auth_id, %{s | status: :login})
                ok_send login_step(), aid
              "register" ->
                set_auth_state(request.auth_id, %{s | status: :register})
                ok_send register_step(), aid
            end
          _ -> error "bad choice"
        end

      %State{status: :login} ->
        {:form, form} = request.step
        [%{field: {:string, email}}, %{field: {:bytes, password}}] = form.fields

        case Arpeggio.DB.login(email, password) do
          {:ok, _, session} ->
            ok_send do_session(session.user_id, session.id), aid
          _ ->
            error "bad credentials"
        end

      %State{status: :register} ->
        {:form, form} = request.step
        [%{field: {:string, email}}, %{field: {:string, username}}, %{field: {:bytes, password}}] = form.fields

        Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
          email: email,
          username: username,
          password: password,
        }, %Arpeggio.User{
          id: new_id()
        })
        {:ok, _, session} = Arpeggio.DB.login(email, password)

        ok_send do_session(session.user_id, session.id), aid

      nil -> error "invalid auth request"
      _ -> error "unhandled"
    end
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
