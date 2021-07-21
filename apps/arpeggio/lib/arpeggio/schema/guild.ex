# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Guild do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guilds" do
    field :name, :string
    field :avatar, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :avatar])
    |> unique_constraint(:id)
  end
end
