# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.Profiles do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :user_name, :string, default: "", null: false
      add :user_avatar, :string, default: "", null: false
      add :user_status, :integer, default: 0, null: false
      add :is_bot, :boolean, default: false, null: false
    end

    create unique_index(:users, [:user_name])
  end
end
