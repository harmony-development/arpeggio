# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Database.GuildTest do
  use ArpeggioWeb.ConnCase

  test "entry addition" do
    {tok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: 1234,
    })

    assert tok == :ok

    {tok, _} = Arpeggio.DB.GuildListEntries.new(1234, 1234, "bar")
    assert tok == :ok

    {tok, _} = Arpeggio.DB.GuildListEntries.new(1234, 1234, "foo")
    assert tok == :ok

    {tok, _} = Arpeggio.DB.GuildListEntries.new(1234, 1234, "bar")
    assert tok == :error

    assert match?([%{guild_id: 1234, host: "bar"}, %{guild_id: 1234, host: "foo"}], Arpeggio.DB.GuildListEntries.entries(1234))
  end

  test "entry removal" do
    {tok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: 1234,
    })

    assert tok == :ok

    {tok, _} = Arpeggio.DB.GuildListEntries.new(1234, 1234, "bar")
    assert tok == :ok

    {tok, _} = Arpeggio.DB.GuildListEntries.new(1234, 1234, "foo")
    assert tok == :ok

    {tok, _} = Arpeggio.DB.GuildListEntries.remove(1234, 1234, "foo")
    assert tok == :ok

    refute match?([%{guild_id: 1234, host: "bar"}, %{guild_id: 1234, host: "foo"}], Arpeggio.DB.GuildListEntries.entries(1234))
    assert match?([%{guild_id: 1234, host: "bar"}], Arpeggio.DB.GuildListEntries.entries(1234))

    {tok, _} = Arpeggio.DB.GuildListEntries.remove(1234, 1234, "error")
    assert tok == :error
  end
end
