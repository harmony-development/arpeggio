# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Guild do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guilds" do
    field :name, :string
    field :avatar, :string
    field :metadata, Metadata
    belongs_to :owner, Arpeggio.User
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :avatar, :metadata, :owner_id])
    |> validate_required(:name)
    |> validate_required(:owner_id)
    |> assoc_constraint(:owner)
    |> unique_constraint(:id)
  end
end
