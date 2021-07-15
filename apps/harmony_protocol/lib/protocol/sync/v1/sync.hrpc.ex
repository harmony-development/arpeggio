# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Sync.V1.PostboxServiceService do
	def endpoints do
		[
			{"Pull", "/protocol.sync.v1.PostboxService/Pull", false, false, Google.Protobuf.Empty, Protocol.Sync.V1.EventQueue},
			{"Push", "/protocol.sync.v1.PostboxService/Push", false, false, Protocol.Sync.V1.Event, Google.Protobuf.Empty},
		]
	end
end
