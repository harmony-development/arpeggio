# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "sessions" do
    belongs_to :user, Arpeggio.User
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:id, :user_id])
    |> validate_required([:id, :user_id])
    |> unique_constraint(:id)
    |> assoc_constraint(:user)
  end
end
