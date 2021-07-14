# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Router do
  import HRPC.Codegen

  use ArpeggioWeb, :router

  pipeline :api do
    plug :accepts, ["application/hrpc", "application/hrpc-json"]
  end

  scope "/", ArpeggioWeb do
    pipe_through :api

    generate_phoenix_routing Protocol.Mediaproxy.V1.MediaProxyServiceService.endpoints(), Glue
    generate_phoenix_routing Protocol.Auth.V1.AuthServiceService.endpoints(), Glue
    generate_phoenix_routing Protocol.Chat.V1.ChatServiceService.endpoints(), Glue
    generate_phoenix_routing Protocol.Sync.V1.PostboxServiceService.endpoints(), Glue
    generate_phoenix_routing Protocol.Voice.V1.VoiceServiceService.endpoints(), Glue
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ArpeggioWeb.Telemetry, ecto_repos: [Arpeggio.Repo]
    end
  end
end
