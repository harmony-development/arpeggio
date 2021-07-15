defmodule Arpeggio.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    create table("local_user") do
      add :username, :string
      add :email, :string
      add :password, :string
    end
    create unique_index(:local_user, [:username])
    create unique_index(:local_user, [:email])
  end
end
