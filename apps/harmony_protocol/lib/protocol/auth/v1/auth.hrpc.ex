# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Auth.V1.AuthServiceService do
	def endpoints do
		[
			{"Federate", "/protocol.auth.v1.AuthService/Federate", false, false, Protocol.Auth.V1.FederateRequest, Protocol.Auth.V1.FederateReply},
			{"LoginFederated", "/protocol.auth.v1.AuthService/LoginFederated", false, false, Protocol.Auth.V1.LoginFederatedRequest, Protocol.Auth.V1.Session},
			{"Key", "/protocol.auth.v1.AuthService/Key", false, false, Google.Protobuf.Empty, Protocol.Auth.V1.KeyReply},
			{"BeginAuth", "/protocol.auth.v1.AuthService/BeginAuth", false, false, Google.Protobuf.Empty, Protocol.Auth.V1.BeginAuthResponse},
			{"NextStep", "/protocol.auth.v1.AuthService/NextStep", false, false, Protocol.Auth.V1.NextStepRequest, Protocol.Auth.V1.AuthStep},
			{"StepBack", "/protocol.auth.v1.AuthService/StepBack", false, false, Protocol.Auth.V1.StepBackRequest, Protocol.Auth.V1.AuthStep},
			{"StreamSteps", "/protocol.auth.v1.AuthService/StreamSteps", false, true, Protocol.Auth.V1.StreamStepsRequest, Protocol.Auth.V1.AuthStep},
			{"CheckLoggedIn", "/protocol.auth.v1.AuthService/CheckLoggedIn", false, false, Google.Protobuf.Empty, Google.Protobuf.Empty},
		]
	end
end
