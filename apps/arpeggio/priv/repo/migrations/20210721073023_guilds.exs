# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.Guilds do
  use Ecto.Migration

  def change do
    create table(:guilds) do
      add :name, :string, default: "New Guild", null: false
      add :avatar, :string, null: true
    end
  end
end
