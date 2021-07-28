# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Database.GuildTest do
  use ArpeggioWeb.ConnCase

  def new_user(id) do
    {:ok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: id,
    })

    {:ok, user, _} = Arpeggio.DB.get_user id
    user
  end

  test "guild duplication" do
    user = new_user 1234

    res =
      Arpeggio.DB.new_guild(%Arpeggio.Guild{
        id: 1,
        name: "test",
        owner_id: user.id
      })

    assert match?({:ok, _}, res)

    res =
      Arpeggio.DB.new_guild(%Arpeggio.Guild{
        id: 1,
        name: "test",
        owner_id: user.id
      })

    assert match?({:error, _}, res)
  end

  test "default channel" do
    user = new_user 1234

    {:ok, guild} =
      Arpeggio.DB.new_guild(%Arpeggio.Guild{
        id: 1,
        name: "test",
        owner_id: user.id
      })

    assert match?([%Arpeggio.Channel{name: "general"}], Arpeggio.DB.Channel.for_guild guild)
  end
end
