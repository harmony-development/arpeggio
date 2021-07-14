# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.CreateChannelRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_name: String.t(),
          is_category: boolean,
          previous_id: non_neg_integer,
          next_id: non_neg_integer,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil
        }

  defstruct [:guild_id, :channel_name, :is_category, :previous_id, :next_id, :metadata]

  field :guild_id, 1, type: :uint64
  field :channel_name, 2, type: :string
  field :is_category, 3, type: :bool
  field :previous_id, 5, type: :uint64
  field :next_id, 4, type: :uint64
  field :metadata, 6, type: Protocol.Harmonytypes.V1.Metadata
end

defmodule Protocol.Chat.V1.CreateChannelResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          channel_id: non_neg_integer
        }

  defstruct [:channel_id]

  field :channel_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetGuildChannelsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetGuildChannelsResponse.Channel do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          channel_id: non_neg_integer,
          channel_name: String.t(),
          is_category: boolean
        }

  defstruct [:metadata, :channel_id, :channel_name, :is_category]

  field :metadata, 4, type: Protocol.Harmonytypes.V1.Metadata
  field :channel_id, 1, type: :uint64
  field :channel_name, 2, type: :string
  field :is_category, 3, type: :bool
end

defmodule Protocol.Chat.V1.GetGuildChannelsResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          channels: [Protocol.Chat.V1.GetGuildChannelsResponse.Channel.t()]
        }

  defstruct [:channels]

  field :channels, 1, repeated: true, type: Protocol.Chat.V1.GetGuildChannelsResponse.Channel
end

defmodule Protocol.Chat.V1.UpdateChannelInformationRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          name: String.t(),
          update_name: boolean,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          update_metadata: boolean
        }

  defstruct [:guild_id, :channel_id, :name, :update_name, :metadata, :update_metadata]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :name, 3, type: :string
  field :update_name, 4, type: :bool
  field :metadata, 5, type: Protocol.Harmonytypes.V1.Metadata
  field :update_metadata, 6, type: :bool
end

defmodule Protocol.Chat.V1.UpdateChannelOrderRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          previous_id: non_neg_integer,
          next_id: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :previous_id, :next_id]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :previous_id, 3, type: :uint64
  field :next_id, 4, type: :uint64
end

defmodule Protocol.Chat.V1.DeleteChannelRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer
        }

  defstruct [:guild_id, :channel_id]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
end

defmodule Protocol.Chat.V1.TypingRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer
        }

  defstruct [:guild_id, :channel_id]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
end
