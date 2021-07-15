# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.Sessions do
  use Ecto.Migration

  def change do
    create table("sessions", primary_key: false) do
      add :id, :string, primary_key: true
    end

    alter table("sessions") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
