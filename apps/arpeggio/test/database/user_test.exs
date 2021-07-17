# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Database.UserTest do
  use ArpeggioWeb.ConnCase

  test "insert users", %{conn: _conn} do
    {tok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: 1234,
    })

    assert tok == :ok

    {tok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: 1234,
    })

    assert tok == :error

    {tok, _val} = Arpeggio.DB.new_remote_user(%Arpeggio.RemoteUser{
      from_host: "idk",
    }, %Arpeggio.User{
      id: 1235,
    })

    assert tok == :ok

    {tok, _val} = Arpeggio.DB.new_remote_user(%Arpeggio.RemoteUser{
      from_host: "idk",
    }, %Arpeggio.User{
      id: 1235,
    })

    assert tok == :error
  end

  test "get user", %{conn: _conn} do
    {tok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: 1,
    })
    {tok, _val} = Arpeggio.DB.new_remote_user(%Arpeggio.RemoteUser{
      from_host: "idk",
    }, %Arpeggio.User{
      id: 2,
    })

    assert match?({:ok, _, {:local, _}}, Arpeggio.DB.get_user(1))
    assert match?({:ok, _, {:remote, _}}, Arpeggio.DB.get_user(2))
  end

  test "password checking", it do
    {tok, _val} = Arpeggio.DB.new_local_user(%Arpeggio.LocalUser{
      email: "uhhadd@gmail.com",
      username: "upperia",
      password: "asdf", # in the real world we hash before inserting
    }, %Arpeggio.User{
      id: 1234,
    })

    assert tok == :ok

    {tok, lu, u} = Arpeggio.DB.login("uhhadd@gmail.com", "asdf")

    assert tok == :ok
    assert lu.password != "asdf"
    assert u.id == 1234

    {tok, lu, u} = Arpeggio.DB.login("uhhadd@gmail.com", "wawa")

    assert tok == :error
  end
end
