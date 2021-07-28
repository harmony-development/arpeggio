# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.DB.GuildListEntries do
  import Ecto.Query
  alias Arpeggio.Repo

  def new(for_user, guild_id, host) do
    %Arpeggio.GuildListEntry{
      user_id: for_user,
      guild_id: guild_id,
      host: host,
      position: :last
    }
    |> Arpeggio.GuildListEntry.changeset
    |> Repo.insert
  end
  def entries(for_user) do
    query = from e in Arpeggio.GuildListEntry, where: e.user_id == ^for_user

    Repo.all(query |> order_by(:rank))
  end
  def remove(for_user, guild_id, host) do
    query = from e in Arpeggio.GuildListEntry, where: e.guild_id == ^guild_id and e.host == ^host and e.user_id == ^for_user

    case Repo.delete_all(query) do
      {1, _} -> {:ok, 1}
      {0, _} -> {:error, 0}
      _ -> raise "database in inconsistent state"
    end
  end
end
