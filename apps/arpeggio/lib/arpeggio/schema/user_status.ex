# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule UserStatus do
  use Ecto.Type
  def type, do: :integer

  def cast(it) when is_integer(it) do
    Protocol.Harmonytypes.V1.UserStatus.value(it)
  end
  def cast(it) when is_atom(it) do
    it
    |> Protocol.Harmonytypes.V1.UserStatus.value
    |> Protocol.Harmonytypes.V1.UserStatus.value
  end
  def cast(_), do: :error

  def load(data) when is_integer(data) do
    {:ok, data |> Protocol.Harmonytypes.V1.UserStatus.value}
  end

  def dump(data) when is_atom(data), do: {:ok, data |> Protocol.Harmonytypes.V1.UserStatus.value}
  def dump(_), do: :error
end
