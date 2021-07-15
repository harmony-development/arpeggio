# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo.Migrations.SetupUsers do
  use Ecto.Migration

  def change do
    create table("local_users") do
      add :username, :string
      add :email, :string
      add :password, :string
    end

    create unique_index(:local_users, [:username])
    create unique_index(:local_users, [:email])

    create table("remote_users") do
      add :from_host, :string
    end

    create table("users") do
    end

    alter table("local_users") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
    alter table("remote_users") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
