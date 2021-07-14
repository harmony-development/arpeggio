# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Voice.V1.VoiceServiceService do
	def endpoints do
		[
			{"Connect", "/protocol.voice.v1.VoiceService/Connect", false, false, Protocol.Voice.V1.ConnectRequest, Protocol.Voice.V1.ConnectResponse},
			{"StreamState", "/protocol.voice.v1.VoiceService/StreamState", false, true, Protocol.Voice.V1.StreamStateRequest, Protocol.Voice.V1.Signal},
		]
	end
end
