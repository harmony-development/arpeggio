# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Auth.Socket do
  require HRPC.Codegen
  use HRPC.Socket, is: Protocol.Auth.V1.AuthServiceService.endpoints()

  def stream_steps_init(_req, state) do
    {:ok, state}
  end
  def stream_steps_req(_req, state) do
    {:ok, state}
  end
  def stream_steps_info(_req, state) do
    {:ok, state}
  end
end

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

  def next_step(request) do
    case auth_state(request.auth_id) do
      %State{status: :pre_initial_screen} = s ->
        ok initial_choice_step()

        set_auth_state(request.auth_id, %{s | status: :initial_screen})

      %State{status: :initial_screen} = s ->
        case request.step do
          {:choice, %{choice: it}} ->
            case it do
              "login" ->
                set_auth_state(request.auth_id, %{s | status: :login})
                ok login_step()
              "register" ->
                set_auth_state(request.auth_id, %{s | status: :register})
                ok register_step()
            end
          _ -> error "bad choice"
        end

      %State{status: :login} ->
        error "unimplemented"

      %State{status: :register} ->
        error "unimplemented"

      nil -> error "invalid auth request"
      _ -> error "unhandled"
    end
  end
end
