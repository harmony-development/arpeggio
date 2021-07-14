# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Glue do
  use ArpeggioWeb, :controller

  import HRPC.Codegen

  generate_endpoints Protocol.Mediaproxy.V1.MediaProxyServiceService.endpoints(), ArpeggioWeb.Mediaproxy
  generate_endpoints Protocol.Auth.V1.AuthServiceService.endpoints(), ArpeggioWeb.Mediaproxy
  generate_endpoints Protocol.Chat.V1.ChatServiceService.endpoints(), ArpeggioWeb.Mediaproxy
  generate_endpoints Protocol.Sync.V1.PostboxServiceService.endpoints(), ArpeggioWeb.Mediaproxy
  generate_endpoints Protocol.Voice.V1.VoiceServiceService.endpoints(), ArpeggioWeb.Mediaproxy
end
