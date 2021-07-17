# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_one :local_user, Arpeggio.LocalUser
    has_one :remote_user, Arpeggio.RemoteUser
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:id])
    |> unique_constraint(:id, name: :users_pkey)
  end
end
