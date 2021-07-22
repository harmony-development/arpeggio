# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Ed25519CryptTest do
  use ExUnit.Case
  doctest Ed25519Crypt

  test "greets the world" do
    assert Ed25519Crypt.hello() == :world
  end
end
