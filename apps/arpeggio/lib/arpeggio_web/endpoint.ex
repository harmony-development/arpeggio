# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :arpeggio


  def init(_atom, config) do
    disp = [
      _: HRPC.Codegen.generate_socket_config(Protocol.Chat.V1.ChatServiceService.endpoints(), ArpeggioWeb.Chat.Socket) ++
      HRPC.Codegen.generate_socket_config(Protocol.Auth.V1.AuthServiceService.endpoints(), ArpeggioWeb.Auth.Socket) ++
      HRPC.Codegen.generate_socket_config(Protocol.Voice.V1.VoiceServiceService.endpoints(), ArpeggioWeb.Voice.Socket) ++
      [{:_, Phoenix.Endpoint.Cowboy2Handler, {ArpeggioWeb.Endpoint, []}}]
    ]
    disps = [
      http: [dispatch: disp]
    ]

    merged = Config.Reader.merge(config, disps)

    {:ok, merged}
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_arpeggio_key",
    signing_salt: "CyuIKiBy"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :arpeggio,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :arpeggio
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ArpeggioWeb.Router
end
