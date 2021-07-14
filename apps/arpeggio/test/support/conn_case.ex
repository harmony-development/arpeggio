# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      alias ArpeggioWeb.Router.Helpers, as: Routes

      @endpoint ArpeggioWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Arpeggio.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Arpeggio.Repo, {:shared, self()})
    end

    %{conn: Phoenix.ConnTest.build_conn()}
  end
end
