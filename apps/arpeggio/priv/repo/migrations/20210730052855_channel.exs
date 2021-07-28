# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.Channel do
  use Ecto.Migration

  def change do
    create table("channels") do
      add :name, :string, null: false
      add :guild_id, references(:guilds, on_delete: :delete_all), null: false

      add :rank, :integer
    end
  end
end
