# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.GuildListEntry do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoRanked

  schema "guild_list_entries" do
    field :host, :string
    field :guild_id, :integer
    belongs_to :user, Arpeggio.User

    field :rank, :integer
    field :position, :any, virtual: true
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:host, :position, :guild_id, :user_id])
    |> validate_required(:host)
    |> validate_required(:guild_id)
    |> validate_required(:user_id)
    |> unique_constraint(:unique_guild_id_and_host, name: :guild_list_entries_unique_host_and_id)
    |> assoc_constraint(:user)
    |> set_rank()
  end
end
