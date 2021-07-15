# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Voice.Socket do
  require HRPC.Codegen

  use HRPC.Socket, is: Protocol.Voice.V1.VoiceServiceService.endpoints(), using_module: ArpeggioWeb.Voice
end

defmodule ArpeggioWeb.Chat.Socket do
  require HRPC.Codegen

  use HRPC.Socket, is: Protocol.Chat.V1.ChatServiceService.endpoints(), using_module: ArpeggioWeb.Chat
end

defmodule ArpeggioWeb.Auth.Socket do
  require HRPC.Codegen

  use HRPC.Socket, is: Protocol.Auth.V1.AuthServiceService.endpoints(), using_module: ArpeggioWeb.Auth
end
