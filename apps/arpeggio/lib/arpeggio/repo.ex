# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Repo do
  use Ecto.Repo,
    otp_app: :arpeggio,
    adapter: Ecto.Adapters.Postgres
end
