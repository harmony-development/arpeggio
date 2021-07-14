# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Sync.V1.PostboxServiceService do
	def endpoints do
		[
			{"Pull", "/protocol.sync.v1.PostboxService/Pull", true, true, Protocol.Sync.V1.Ack, Protocol.Sync.V1.Syn},
			{"Push", "/protocol.sync.v1.PostboxService/Push", false, false, Protocol.Sync.V1.Event, Google.Protobuf.Empty},
		]
	end
end
