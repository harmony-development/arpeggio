# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Harmonytypes.V1.UserStatus do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :USER_STATUS_ONLINE_UNSPECIFIED
          | :USER_STATUS_STREAMING
          | :USER_STATUS_DO_NOT_DISTURB
          | :USER_STATUS_IDLE
          | :USER_STATUS_OFFLINE

  field :USER_STATUS_ONLINE_UNSPECIFIED, 0

  field :USER_STATUS_STREAMING, 1

  field :USER_STATUS_DO_NOT_DISTURB, 2

  field :USER_STATUS_IDLE, 3

  field :USER_STATUS_OFFLINE, 4
end

defmodule Protocol.Harmonytypes.V1.Action.Type do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3
  @type t :: integer | :Normal | :Primary | :Destructive

  field :Normal, 0

  field :Primary, 1

  field :Destructive, 2
end

defmodule Protocol.Harmonytypes.V1.EmbedField.Presentation do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3
  @type t :: integer | :Data | :CaptionedImage | :Row

  field :Data, 0

  field :CaptionedImage, 1

  field :Row, 2
end

defmodule Protocol.Harmonytypes.V1.HarmonyMethodMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          requires_authentication: boolean,
          requires_local: boolean,
          requires_permission_node: String.t()
        }

  defstruct [:requires_authentication, :requires_local, :requires_permission_node]

  field :requires_authentication, 1, type: :bool
  field :requires_local, 2, type: :bool
  field :requires_permission_node, 3, type: :string
end

defmodule Protocol.Harmonytypes.V1.Override do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          reason: {atom, any},
          name: String.t(),
          avatar: String.t()
        }

  defstruct [:reason, :name, :avatar]

  oneof :reason, 0
  field :name, 1, type: :string
  field :avatar, 2, type: :string
  field :user_defined, 3, type: :string, oneof: 0
  field :webhook, 4, type: Google.Protobuf.Empty, oneof: 0
  field :system_plurality, 5, type: Google.Protobuf.Empty, oneof: 0
  field :system_message, 6, type: Google.Protobuf.Empty, oneof: 0
  field :bridge, 7, type: Google.Protobuf.Empty, oneof: 0
end

defmodule Protocol.Harmonytypes.V1.Action.Button do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          text: String.t(),
          url: String.t()
        }

  defstruct [:text, :url]

  field :text, 1, type: :string
  field :url, 2, type: :string
end

defmodule Protocol.Harmonytypes.V1.Action.Dropdown do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          text: String.t(),
          options: [String.t()]
        }

  defstruct [:text, :options]

  field :text, 1, type: :string
  field :options, 2, repeated: true, type: :string
end

defmodule Protocol.Harmonytypes.V1.Action.Input do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t(),
          wide: boolean
        }

  defstruct [:label, :wide]

  field :label, 1, type: :string
  field :wide, 2, type: :bool
end

defmodule Protocol.Harmonytypes.V1.Action do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: {atom, any},
          action_type: Protocol.Harmonytypes.V1.Action.Type.t(),
          id: String.t()
        }

  defstruct [:kind, :action_type, :id]

  oneof :kind, 0
  field :action_type, 1, type: Protocol.Harmonytypes.V1.Action.Type, enum: true
  field :id, 2, type: :string
  field :button, 3, type: Protocol.Harmonytypes.V1.Action.Button, oneof: 0
  field :dropdown, 4, type: Protocol.Harmonytypes.V1.Action.Dropdown, oneof: 0
  field :input, 5, type: Protocol.Harmonytypes.V1.Action.Input, oneof: 0
end

defmodule Protocol.Harmonytypes.V1.EmbedHeading do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          text: String.t(),
          subtext: String.t(),
          url: String.t(),
          icon: String.t()
        }

  defstruct [:text, :subtext, :url, :icon]

  field :text, 1, type: :string
  field :subtext, 2, type: :string
  field :url, 3, type: :string
  field :icon, 4, type: :string
end

defmodule Protocol.Harmonytypes.V1.EmbedField do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          title: String.t(),
          subtitle: String.t(),
          body: String.t(),
          image_url: String.t(),
          presentation: Protocol.Harmonytypes.V1.EmbedField.Presentation.t(),
          actions: [Protocol.Harmonytypes.V1.Action.t()]
        }

  defstruct [:title, :subtitle, :body, :image_url, :presentation, :actions]

  field :title, 1, type: :string
  field :subtitle, 2, type: :string
  field :body, 3, type: :string
  field :image_url, 4, type: :string
  field :presentation, 5, type: Protocol.Harmonytypes.V1.EmbedField.Presentation, enum: true
  field :actions, 6, repeated: true, type: Protocol.Harmonytypes.V1.Action
end

defmodule Protocol.Harmonytypes.V1.Embed do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          title: String.t(),
          body: String.t(),
          color: integer,
          header: Protocol.Harmonytypes.V1.EmbedHeading.t() | nil,
          footer: Protocol.Harmonytypes.V1.EmbedHeading.t() | nil,
          fields: [Protocol.Harmonytypes.V1.EmbedField.t()]
        }

  defstruct [:title, :body, :color, :header, :footer, :fields]

  field :title, 1, type: :string
  field :body, 2, type: :string
  field :color, 3, type: :int64
  field :header, 4, type: Protocol.Harmonytypes.V1.EmbedHeading
  field :footer, 5, type: Protocol.Harmonytypes.V1.EmbedHeading
  field :fields, 6, repeated: true, type: Protocol.Harmonytypes.V1.EmbedField
end

defmodule Protocol.Harmonytypes.V1.Attachment do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          type: String.t(),
          size: integer,
          caption: String.t()
        }

  defstruct [:id, :name, :type, :size, :caption]

  field :id, 1, type: :string
  field :name, 2, type: :string
  field :type, 3, type: :string
  field :size, 4, type: :int32
  field :caption, 5, type: :string
end

defmodule Protocol.Harmonytypes.V1.Metadata.ExtensionEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Google.Protobuf.Any.t() | nil
        }

  defstruct [:key, :value]

  field :key, 1, type: :string
  field :value, 2, type: Google.Protobuf.Any
end

defmodule Protocol.Harmonytypes.V1.Metadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: String.t(),
          extension: %{String.t() => Google.Protobuf.Any.t() | nil}
        }

  defstruct [:kind, :extension]

  field :kind, 1, type: :string

  field :extension, 2,
    repeated: true,
    type: Protocol.Harmonytypes.V1.Metadata.ExtensionEntry,
    map: true
end

defmodule Protocol.Harmonytypes.V1.ContentText do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          content: String.t()
        }

  defstruct [:content]

  field :content, 1, type: :string
end

defmodule Protocol.Harmonytypes.V1.ContentEmbed do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          embeds: Protocol.Harmonytypes.V1.Embed.t() | nil
        }

  defstruct [:embeds]

  field :embeds, 1, type: Protocol.Harmonytypes.V1.Embed
end

defmodule Protocol.Harmonytypes.V1.ContentFiles do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attachments: [Protocol.Harmonytypes.V1.Attachment.t()]
        }

  defstruct [:attachments]

  field :attachments, 1, repeated: true, type: Protocol.Harmonytypes.V1.Attachment
end

defmodule Protocol.Harmonytypes.V1.Content do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          content: {atom, any}
        }

  defstruct [:content]

  oneof :content, 0
  field :text_message, 2, type: Protocol.Harmonytypes.V1.ContentText, oneof: 0
  field :embed_message, 4, type: Protocol.Harmonytypes.V1.ContentEmbed, oneof: 0
  field :files_message, 5, type: Protocol.Harmonytypes.V1.ContentFiles, oneof: 0
end

defmodule Protocol.Harmonytypes.V1.Message do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          overrides: Protocol.Harmonytypes.V1.Override.t() | nil,
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          message_id: non_neg_integer,
          author_id: non_neg_integer,
          created_at: Google.Protobuf.Timestamp.t() | nil,
          edited_at: Google.Protobuf.Timestamp.t() | nil,
          in_reply_to: non_neg_integer,
          content: Protocol.Harmonytypes.V1.Content.t() | nil
        }

  defstruct [
    :metadata,
    :overrides,
    :guild_id,
    :channel_id,
    :message_id,
    :author_id,
    :created_at,
    :edited_at,
    :in_reply_to,
    :content
  ]

  field :metadata, 1, type: Protocol.Harmonytypes.V1.Metadata
  field :overrides, 2, type: Protocol.Harmonytypes.V1.Override
  field :guild_id, 3, type: :uint64
  field :channel_id, 4, type: :uint64
  field :message_id, 5, type: :uint64
  field :author_id, 6, type: :uint64
  field :created_at, 7, type: Google.Protobuf.Timestamp
  field :edited_at, 8, type: Google.Protobuf.Timestamp
  field :in_reply_to, 9, type: :uint64
  field :content, 10, type: Protocol.Harmonytypes.V1.Content
end

defmodule Protocol.Harmonytypes.V1.Error do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          identifier: String.t(),
          human_message: String.t(),
          more_details: binary
        }

  defstruct [:identifier, :human_message, :more_details]

  field :identifier, 1, type: :string
  field :human_message, 2, type: :string
  field :more_details, 3, type: :bytes
end
