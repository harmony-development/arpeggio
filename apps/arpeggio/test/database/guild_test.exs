# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Database.GuildTest do
  use ArpeggioWeb.ConnCase

  test "new guild" do
    res =
      Arpeggio.DB.new_guild(%Arpeggio.Guild{
        id: 1,
        name: "test"
      })

    assert match?({:ok, _}, res)

    res =
      Arpeggio.DB.new_guild(%Arpeggio.Guild{
        id: 1,
        name: "test"
      })

    assert match?({:error, _}, res)
  end

  test "default values are set" do
    res =
      Arpeggio.DB.new_guild(%Arpeggio.Guild{
        id: 1,
      })

    assert match?({:ok, _}, res)
    {:ok, _} = res

    res = Arpeggio.DB.get_guild_by_id(1)
    assert match?({:ok, _}, res)
    {:ok, guild} = res
    guild.name =~ "New Guild"
  end
end
