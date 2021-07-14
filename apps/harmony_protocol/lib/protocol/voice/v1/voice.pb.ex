# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Voice.V1.Signal do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          event: {atom, any}
        }

  defstruct [:event]

  oneof :event, 0
  field :ice_candidate, 1, type: :string, oneof: 0
  field :renegotiation_needed, 2, type: Google.Protobuf.Empty, oneof: 0
end

defmodule Protocol.Voice.V1.ConnectRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          channel_id: non_neg_integer,
          offer: String.t()
        }

  defstruct [:channel_id, :offer]

  field :channel_id, 1, type: :uint64
  field :offer, 2, type: :string
end

defmodule Protocol.Voice.V1.ConnectResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          answer: String.t()
        }

  defstruct [:answer]

  field :answer, 1, type: :string
end

defmodule Protocol.Voice.V1.StreamStateRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          channel_id: non_neg_integer
        }

  defstruct [:channel_id]

  field :channel_id, 1, type: :uint64
end
