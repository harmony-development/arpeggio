# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Ed25519 do
  use Rustler, otp_app: :ed25519_crypt, crate: "ed25519"

  def generate_keys(), do: :erlang.nif_error(:nif_not_loaded)
  def encode_pem(_), do: :erlang.nif_error(:nif_not_loaded)
  def decode_pem(_), do: :erlang.nif_error(:nif_not_loaded)
  def public_key(_), do: :erlang.nif_error(:nif_not_loaded)
  def sign(_, _), do: :erlang.nif_error(:nif_not_loaded)
end
