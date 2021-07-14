# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.GetChannelMessagesRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          before_message: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :before_message]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :before_message, 3, type: :uint64
end

defmodule Protocol.Chat.V1.GetChannelMessagesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          reached_top: boolean,
          messages: [Protocol.Harmonytypes.V1.Message.t()]
        }

  defstruct [:reached_top, :messages]

  field :reached_top, 1, type: :bool
  field :messages, 2, repeated: true, type: Protocol.Harmonytypes.V1.Message
end

defmodule Protocol.Chat.V1.GetMessageRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          message_id: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :message_id]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :message_id, 3, type: :uint64
end

defmodule Protocol.Chat.V1.GetMessageResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: Protocol.Harmonytypes.V1.Message.t() | nil
        }

  defstruct [:message]

  field :message, 1, type: Protocol.Harmonytypes.V1.Message
end

defmodule Protocol.Chat.V1.DeleteMessageRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          message_id: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :message_id]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :message_id, 3, type: :uint64
end

defmodule Protocol.Chat.V1.TriggerActionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          message_id: non_neg_integer,
          action_id: String.t(),
          action_data: String.t()
        }

  defstruct [:guild_id, :channel_id, :message_id, :action_id, :action_data]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :message_id, 3, type: :uint64
  field :action_id, 4, type: :string
  field :action_data, 5, type: :string
end

defmodule Protocol.Chat.V1.SendMessageRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          content: Protocol.Harmonytypes.V1.Content.t() | nil,
          echo_id: non_neg_integer,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          overrides: Protocol.Harmonytypes.V1.Override.t() | nil,
          in_reply_to: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :content, :echo_id, :metadata, :overrides, :in_reply_to]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :content, 3, type: Protocol.Harmonytypes.V1.Content
  field :echo_id, 4, type: :uint64
  field :metadata, 5, type: Protocol.Harmonytypes.V1.Metadata
  field :overrides, 6, type: Protocol.Harmonytypes.V1.Override
  field :in_reply_to, 7, type: :uint64
end

defmodule Protocol.Chat.V1.SendMessageResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message_id: non_neg_integer
        }

  defstruct [:message_id]

  field :message_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.UpdateMessageTextRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          message_id: non_neg_integer,
          new_content: String.t()
        }

  defstruct [:guild_id, :channel_id, :message_id, :new_content]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :message_id, 3, type: :uint64
  field :new_content, 4, type: :string
end
