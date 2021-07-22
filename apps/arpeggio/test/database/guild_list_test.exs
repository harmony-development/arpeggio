# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Database.GuildListTest do
  use ArpeggioWeb.ConnCase

  test "can't add to guild list for nonexistent user" do
    res =
      Arpeggio.DB.add_guild_to_list(
        %Arpeggio.GuildListEntry{
          guild_id: 1,
          position: "a",
          user_id: 1,
        }
      )
    assert match?({:error, _}, res)
  end

  test "can add to guild list" do
    Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      username: "hello",
      email: "aaa@bbbb.su",
      password: "12345"
    }, %Arpeggio.User{
      user_name: "hello",
      user_avatar: "uhhh",
      id: 32,
    }) # this is implied to work because we have a unit test for it
       # oh also why is username duplicated, that should be looked into

    res = Arpeggio.DB.add_guild_to_list(
      %Arpeggio.GuildListEntry{
        guild_id: 1,
        user_id: 32,
        position: "a",
      }
    )

    assert match?({:ok, _}, res)
  end
end
