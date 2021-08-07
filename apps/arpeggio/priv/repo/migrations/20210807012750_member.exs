defmodule Arpeggio.Repo.Migrations.Member do
  use Ecto.Migration

  def change do
    create table("members") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :guild_id, references(:guilds, on_delete: :delete_all), null: false
    end

    create unique_index("members", [:user_id, :guild_id], name: :members_unique)
  end
end
