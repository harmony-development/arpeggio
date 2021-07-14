#!/usr/bin/env elixir

# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

# options to pass protoc
File.mkdir("./lib/protocol")
res = Path.wildcard("protocol/**/*.proto")

opts = [
  "--proto_path=protocol",
  "--elixir_out=./lib/protocol",
  "--hrpc_out=./lib/protocol",
  "--hrpc_opt=elixir_server"
]

{uSecs, :ok} = :timer.tc(fn ->
  res |> Parallel.pmap(&System.cmd(
    "protoc",
    opts ++ [&1]
  ))
  :ok
end)
IO.puts "Generated protobufs in #{uSecs / 1_000_000}s"
