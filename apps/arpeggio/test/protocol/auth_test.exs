# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.AuthTest do
  use ArpeggioWeb.ConnCase

  defp make_account() do
    alias ArpeggioWeb.Auth
    alias Protocol.Auth.V1, as: AuthP
    alias Google.Protobuf.Empty

    it = Auth.begin_auth(%Empty{})
    assert match? {:ok, _}, it
    {:ok, resp} = it

    assert match? {:ok, _}, Auth.stream_steps_req(%AuthP.StreamStepsRequest{ auth_id: resp.auth_id }, %{})
    assert match? {:ok, _}, Auth.next_step(%AuthP.NextStepRequest{ auth_id: resp.auth_id })
    assert_receive %AuthP.AuthStep{step: {:choice, _}}

    assert match? {:ok, _}, Auth.next_step(%AuthP.NextStepRequest{
      auth_id: resp.auth_id,
      step: {:choice, %{choice: "register"}}
    })
    assert match? {:error, _}, Auth.next_step(%AuthP.NextStepRequest{
      auth_id: resp.auth_id,
      step: {:choice, %{choice: "register"}}
    })

    assert_receive %AuthP.AuthStep{step: {:form, _}}
    assert match? {:ok, _}, Auth.next_step(%AuthP.NextStepRequest{
      auth_id: resp.auth_id,
      step: {:form, %{fields: [%{field: {:string, "keke"}}, %{field: {:string, "keke"}}, %{field: {:bytes, "keke"}}]}}
    })

    assert_receive %AuthP.AuthStep{step: {:session, _}}
  end

  test "register", %{conn: conn} do
    make_account()
  end

  test "login", %{conn: conn} do
    make_account()

    alias ArpeggioWeb.Auth
    alias Protocol.Auth.V1, as: AuthP
    alias Google.Protobuf.Empty

    it = Auth.begin_auth(%Empty{})
    assert match? {:ok, _}, it
    {:ok, resp} = it

    assert match? {:ok, _}, Auth.stream_steps_req(%AuthP.StreamStepsRequest{ auth_id: resp.auth_id }, %{})
    assert match? {:ok, _}, Auth.next_step(%AuthP.NextStepRequest{ auth_id: resp.auth_id })
    assert_receive %AuthP.AuthStep{step: {:choice, _}}

    assert match? {:ok, _}, Auth.next_step(%AuthP.NextStepRequest{
      auth_id: resp.auth_id,
      step: {:choice, %{choice: "login"}}
    })
    assert match? {:error, _}, Auth.next_step(%AuthP.NextStepRequest{
      auth_id: resp.auth_id,
      step: {:choice, %{choice: "login"}}
    })

    assert_receive %AuthP.AuthStep{step: {:form, _}}
    assert match? {:ok, _}, Auth.next_step(%AuthP.NextStepRequest{
      auth_id: resp.auth_id,
      step: {:form, %{fields: [%{field: {:string, "keke"}}, %{field: {:bytes, "keke"}}]}}
    })

    assert_receive %AuthP.AuthStep{step: {:session, _}}
  end
end
