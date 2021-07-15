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

  def get_user(req) do
    {:ok, user, {_, _}} = Arpeggio.DB.get_user(req.user_id)

    {:ok, %Protocol.Chat.V1.GetUserResponse{
      user_name: user.user_name,
      user_avatar: user.user_avatar,
      user_status: user.user_status,
      is_bot: user.is_bot,
    }}
  end
end
