# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Voice.Socket do
  require HRPC.Codegen
  use HRPC.Socket, is: Protocol.Voice.V1.VoiceServiceService.endpoints()
end

defmodule ArpeggioWeb.Voice do

end
