# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_one :local_user, Arpeggio.LocalUser
    has_one :remote_user, Arpeggio.RemoteUser

    has_many :guilds, Arpeggio.Guild

    field :user_name, :string
    field :user_avatar, :string
    field :user_status, UserStatus
    field :is_bot, :boolean
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:id, :user_name, :user_avatar, :user_status, :is_bot])
    |> unique_constraint(:id)
    |> unique_constraint(:user_name)
  end
end
