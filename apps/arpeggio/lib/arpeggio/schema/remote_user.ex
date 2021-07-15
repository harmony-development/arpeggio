# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.RemoteUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "remote_users" do
    field :from_host, :string
    belongs_to :user, Arpeggio.User
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:from_host, :user_id])
    |> validate_required([:from_host])
    |> validate_required([:user_id])
    |> assoc_constraint(:user)
  end
end
