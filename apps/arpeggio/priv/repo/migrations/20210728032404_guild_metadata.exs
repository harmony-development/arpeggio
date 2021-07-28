# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.GuildMetadata do
  use Ecto.Migration

  def change do
    alter table("guilds") do
      add :metadata, :binary, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
