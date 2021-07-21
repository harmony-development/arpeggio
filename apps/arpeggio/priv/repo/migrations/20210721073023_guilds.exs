defmodule Arpeggio.Repo.Migrations.Guilds do
  use Ecto.Migration

  def change do
    create table(:guilds) do
      add :name, :string, default: "New Guild", null: false
      add :avatar, :string, null: true
    end
  end
end
