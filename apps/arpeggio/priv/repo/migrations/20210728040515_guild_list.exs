# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.GuildList do
  use Ecto.Migration

  def change do
    create table("guild_list_entries") do
      add :host, :string, null: false
      add :guild_id, :bigint, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :rank, :integer
    end

    create unique_index("guild_list_entries", [:host, :guild_id], name: :guild_list_entries_unique_host_and_id)
  end
end
