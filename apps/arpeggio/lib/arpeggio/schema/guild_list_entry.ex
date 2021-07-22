# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.GuildListEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guild_list_entry" do
    belongs_to :user, Arpeggio.User

    field :position, :string
    field :guild_id, :id
  end

  def changeset(guild_entry, params \\ %{}) do
    guild_entry
    |> cast(params, [:position, :guild_id, :user_id])
    |> unique_constraint(:id)
    |> validate_required([:user_id, :guild_id, :position])
    |> assoc_constraint(:user)
  end
end
