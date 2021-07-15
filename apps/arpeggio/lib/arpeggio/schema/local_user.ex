# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.LocalUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "local_users" do
    field :username, :string
    field :email, :string
    field :password, :string
    belongs_to :user, Arpeggio.User
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :email, :password, :user_id])
    |> validate_required([:username, :email, :password, :user_id])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> unique_constraint(:user_id)
    |> assoc_constraint(:user)
  end
end
