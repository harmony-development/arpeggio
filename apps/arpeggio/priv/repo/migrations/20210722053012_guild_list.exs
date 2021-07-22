# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.GuildList do
  use Ecto.Migration

  def change do
    create table(:guild_list_entries, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :guild_id, :id, null: false
      add :position, :string, null: false
    end
  end
end
