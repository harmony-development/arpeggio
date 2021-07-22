# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Mix.Tasks.GenKey do
  use Mix.Task

  @shortdoc "Generates public and private keys"
  def run(_) do
    pem = Ed25519.generate_keys() |> Ed25519.encode_pem()

    file = Application.fetch_env!(:arpeggio, :federation_private_key)

    File.write!(file, pem)
  end
end
