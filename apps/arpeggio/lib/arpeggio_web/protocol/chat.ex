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

  def get_user(_conn, req) do
    {:ok, user, {_, _}} = Arpeggio.DB.get_user(req.user_id)

    {:ok, %Protocol.Chat.V1.GetUserResponse{
      user_name: user.user_name,
      user_avatar: user.user_avatar,
      user_status: user.user_status,
      is_bot: user.is_bot,
    }}
  end

  # TODO: handle federated vs local users
  def create_guild(conn, req) do
    user = Arpeggio.DB.get_user_from conn, load_local_remote: true

    g = case Arpeggio.DB.new_guild %Arpeggio.Guild {
      name: req.guild_name,
      avatar: req.picture_url,
      metadata: req.metadata
    } do
      {:ok, g} -> g
      {:error, _} -> throw "failed to make guild"
    end

    if user.remote_user != nil do
      # TODO(SYNC): broadcast using sync service
    else
      Arpeggio.DB.GuildListEntries.new user.id, g.id, ""
      Phoenix.PubSub.broadcast :arpeggio, "homeserver-events:#{user.id}", %Protocol.Chat.V1.Event {
        event: {:guild_added_to_list, %Protocol.Chat.V1.Event.GuildAddedToList{
          guild_id: g.id,
          homeserver: ""
        }}
      }
    end

    {:ok, %Protocol.Chat.V1.CreateGuildResponse{ guild_id: g.id }}
  end
end
