# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Voice do
  def stream_state_init(_req, state) do
    {:ok, state}
  end
  def stream_state_req(_req, state) do
    {:ok, state}
  end
  def stream_state_info(_req, state) do
    {:ok, state}
  end
end
