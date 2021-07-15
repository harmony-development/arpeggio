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

end
