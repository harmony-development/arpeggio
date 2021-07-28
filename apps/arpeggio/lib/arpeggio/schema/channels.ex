# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Channel do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoRanked

  schema "channels" do
    field :name, :string
    belongs_to :guild, Arpeggio.Guild

    field :rank, :integer
    field :position, :any, virtual: true
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :position, :guild_id])
    |> validate_required(:name)
    |> validate_required(:guild_id)
    |> validate_required(:position)
    |> assoc_constraint(:guild_id)
    |> set_rank()
  end
end
