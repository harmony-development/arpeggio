# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.DB.Channel do
  import Ecto.Query
  alias Arpeggio.Repo

  def new(guild_id, name) do
    %Arpeggio.Channel {
      name: name,
      guild_id: guild_id
    } |> Repo.insert
  end

  def for_guild(guild_id) when is_integer(guild_id) do
    query = from e in Arpeggio.Channel, where: e.guild_id == ^guild_id

    Repo.all(query)
  end
  def for_guild(%Arpeggio.Guild{} = guild) do
    for_guild guild.id
  end
end
