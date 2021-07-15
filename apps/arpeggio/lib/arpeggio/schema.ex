# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.LocalUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "local_user" do
    field :username, :string
    field :email, :string
    field :password, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end

defmodule Arpeggio.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    user_id :username, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end

defmodule Arpeggio.Sessions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "session" do
    field :user_id,
  end
end
