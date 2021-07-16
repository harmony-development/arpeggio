# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Chat do
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
