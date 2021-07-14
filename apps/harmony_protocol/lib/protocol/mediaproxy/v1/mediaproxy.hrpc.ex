# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Mediaproxy.V1.MediaProxyServiceService do
	def endpoints do
		[
			{"FetchLinkMetadata", "/protocol.mediaproxy.v1.MediaProxyService/FetchLinkMetadata", false, false, Protocol.Mediaproxy.V1.FetchLinkMetadataRequest, Protocol.Mediaproxy.V1.FetchLinkMetadataResponse},
			{"InstantView", "/protocol.mediaproxy.v1.MediaProxyService/InstantView", false, false, Protocol.Mediaproxy.V1.InstantViewRequest, Protocol.Mediaproxy.V1.InstantViewResponse},
			{"CanInstantView", "/protocol.mediaproxy.v1.MediaProxyService/CanInstantView", false, false, Protocol.Mediaproxy.V1.InstantViewRequest, Protocol.Mediaproxy.V1.CanInstantViewResponse},
		]
	end
end
