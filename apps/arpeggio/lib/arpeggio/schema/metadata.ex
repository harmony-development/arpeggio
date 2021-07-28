# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Metadata do
  use Ecto.Type
  def type, do: :binary

  def cast(%Protocol.Harmonytypes.V1.Metadata{} = it), do: {:ok, it}
  def cast(_), do: :error

  def dump(%Protocol.Harmonytypes.V1.Metadata{} = it), do: Protocol.Harmonytypes.V1.Metadata.encode it
  def dump(_), do: :error

  def load(data) when is_binary(data) do
    case Protocol.Harmonytypes.V1.Metadata.decode data do
      {:ok, data} -> {:ok, data}
      _ -> :error
    end
  end
  def load(_), do: :error
end
