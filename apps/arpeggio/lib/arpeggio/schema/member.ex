# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    belongs_to :user, Arpeggio.User
    belongs_to :guild, Arpeggio.Guild
  end

  def changeset(member, params \\ %{}) do
    member
    |> cast(params, [])
    |> unique_constraint(:unique_member, name: :members_unique)
    |> assoc_constraint(:user)
    |> assoc_constraint(:guild)
  end
end
