# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Chat do
  alias Arpeggio.DB

  def stream_events_init(req, state) do
    user = DB.get_user_from req

    {:ok, state |> Map.put(:user, user)}
  end

  def stream_events_handle(req, %{user: user} = state) do
    case req.request do
      {:subscribe_to_guild, it} ->
        Phoenix.PubSub.subscribe :arpeggio, "guild-events:#{it.guild_id}"
      {:subscribe_to_actions, _it} ->
        Phoenix.PubSub.subscribe :arpeggio, "action-events:#{user.id}"
      {:subscribe_to_homeserver_events, _it} ->
        Phoenix.PubSub.subscribe :arpeggio, "homeserver-events:#{user.id}"
    end
    {:ok, state}
  end

  def stream_events_info(info, state) do
    {:reply, info, state}
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

  defp new_id() do
    case Snowflake.next_id() do
      {:ok, val} -> val
      {:error, err} -> raise err
    end
  end

  # TODO: handle federated vs local users
  def create_guild(conn, req) do
    user = Arpeggio.DB.get_user_from conn, load_local_remote: true

    g = case Arpeggio.DB.new_guild %Arpeggio.Guild {
      name: req.guild_name,
      avatar: req.picture_url,
      metadata: req.metadata,
      owner_id: user.id,
      id: new_id(),
    } do
      {:ok, g} -> g
      {:error, err} -> throw {"failed to make guild", err}
    end

    if user.remote_user != nil do
      # TODO(SYNC): broadcast using sync service
    else
      case Arpeggio.DB.GuildListEntries.new user.id, g.id, "" do
        {:ok, g} -> g
        {:error, err} -> throw {"failed to insert list entry", err}
      end
      Phoenix.PubSub.broadcast :arpeggio, "homeserver-events:#{user.id}", %Protocol.Chat.V1.Event {
        event: {:guild_added_to_list, %Protocol.Chat.V1.Event.GuildAddedToList{
          guild_id: g.id,
          homeserver: ""
        }}
      }
    end

    {:ok, %Protocol.Chat.V1.CreateGuildResponse{ guild_id: g.id }}
  end

  def get_guild_list(conn, _req) do
    user = DB.get_user_from conn

    entries = DB.GuildListEntries.entries user.id

    guilds = entries
    |> Enum.map(fn x ->
      %Protocol.Chat.V1.GetGuildListResponse.GuildListEntry{
        host: x.host,
        guild_id: x.guild_id,
      }
    end)

    {:ok, %Protocol.Chat.V1.GetGuildListResponse{ guilds: guilds }}
  end

  def profile_update(conn, req) do
    DB.get_user_from(conn)
    |> DB.change_if(%{user_name: req.new_username}, req.update_username)
    |> DB.change_if(%{user_avatar: req.new_avatar}, req.update_avatar)
    |> DB.change_if(%{user_status: req.new_status}, req.update_status)
    |> DB.change_if(%{is_bot: req.is_bot}, req.update_is_bot)
    |> Arpeggio.Repo.update!

    {:ok, %Google.Protobuf.Empty{}}
  end

  def get_guild(_conn, req) do
    case DB.get_guild_by_id(req.guild_id) do
      {:ok, g} -> {:ok, %Protocol.Chat.V1.GetGuildResponse{
        metadata: g.metadata,
        guild_name: g.name,
        guild_owner: g.owner_id,
        guild_picture: g.avatar,
      }}
      {:error} -> {:error, "failed to get guild"}
    end
  end
end
