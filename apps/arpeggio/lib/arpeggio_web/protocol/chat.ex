# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Chat.Socket do
  require HRPC.Codegen
  use HRPC.Socket, is: Protocol.Chat.V1.ChatServiceService.endpoints()

  def stream_events_init(_req, state) do
    {:ok, state}
  end

  def stream_events_handle(_req, state) do
    {:ok, state}
  end

  def stream_events_info(_req, state) do
    {:ok, state}
  end
end

defmodule ArpeggioWeb.Chat do

end
