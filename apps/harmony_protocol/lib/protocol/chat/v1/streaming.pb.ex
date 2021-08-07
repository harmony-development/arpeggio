# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.Event.LeaveReason do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3
  @type t :: integer | :willingly | :banned | :kicked

  field :willingly, 0

  field :banned, 1

  field :kicked, 2
end

defmodule Protocol.Chat.V1.StreamEventsRequest.SubscribeToGuild do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.StreamEventsRequest.SubscribeToActions do
  @moduledoc false
  use Protobuf, syntax: :proto3
  @type t :: %__MODULE__{}

  defstruct []
end

defmodule Protocol.Chat.V1.StreamEventsRequest.SubscribeToHomeserverEvents do
  @moduledoc false
  use Protobuf, syntax: :proto3
  @type t :: %__MODULE__{}

  defstruct []
end

defmodule Protocol.Chat.V1.StreamEventsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          request: {atom, any}
        }

  defstruct [:request]

  oneof :request, 0

  field :subscribe_to_guild, 1,
    type: Protocol.Chat.V1.StreamEventsRequest.SubscribeToGuild,
    oneof: 0

  field :subscribe_to_actions, 2,
    type: Protocol.Chat.V1.StreamEventsRequest.SubscribeToActions,
    oneof: 0

  field :subscribe_to_homeserver_events, 3,
    type: Protocol.Chat.V1.StreamEventsRequest.SubscribeToHomeserverEvents,
    oneof: 0
end

defmodule Protocol.Chat.V1.Event.MessageSent do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          echo_id: non_neg_integer,
          message: Protocol.Harmonytypes.V1.Message.t() | nil
        }

  defstruct [:echo_id, :message]

  field :echo_id, 1, type: :uint64
  field :message, 2, type: Protocol.Harmonytypes.V1.Message
end

defmodule Protocol.Chat.V1.Event.MessageUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          message_id: non_neg_integer,
          edited_at: Google.Protobuf.Timestamp.t() | nil,
          content: String.t()
        }

  defstruct [:guild_id, :channel_id, :message_id, :edited_at, :content]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :message_id, 3, type: :uint64
  field :edited_at, 4, type: Google.Protobuf.Timestamp
  field :content, 5, type: :string
end

defmodule Protocol.Chat.V1.Event.MessageDeleted do
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

defmodule Protocol.Chat.V1.Event.ChannelCreated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          name: String.t(),
          previous_id: non_neg_integer,
          next_id: non_neg_integer,
          is_category: boolean,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil
        }

  defstruct [:guild_id, :channel_id, :name, :previous_id, :next_id, :is_category, :metadata]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :name, 3, type: :string
  field :previous_id, 4, type: :uint64
  field :next_id, 5, type: :uint64
  field :is_category, 6, type: :bool
  field :metadata, 7, type: Protocol.Harmonytypes.V1.Metadata
end

defmodule Protocol.Chat.V1.Event.ChannelUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          name: String.t(),
          update_name: boolean,
          previous_id: non_neg_integer,
          next_id: non_neg_integer,
          update_order: boolean,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          update_metadata: boolean
        }

  defstruct [
    :guild_id,
    :channel_id,
    :name,
    :update_name,
    :previous_id,
    :next_id,
    :update_order,
    :metadata,
    :update_metadata
  ]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :name, 3, type: :string
  field :update_name, 4, type: :bool
  field :previous_id, 5, type: :uint64
  field :next_id, 6, type: :uint64
  field :update_order, 7, type: :bool
  field :metadata, 8, type: Protocol.Harmonytypes.V1.Metadata
  field :update_metadata, 9, type: :bool
end

defmodule Protocol.Chat.V1.Event.ChannelDeleted do
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

defmodule Protocol.Chat.V1.Event.GuildUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          name: String.t(),
          update_name: boolean,
          picture: String.t(),
          update_picture: boolean,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          update_metadata: boolean
        }

  defstruct [
    :guild_id,
    :name,
    :update_name,
    :picture,
    :update_picture,
    :metadata,
    :update_metadata
  ]

  field :guild_id, 1, type: :uint64
  field :name, 2, type: :string
  field :update_name, 3, type: :bool
  field :picture, 4, type: :string
  field :update_picture, 5, type: :bool
  field :metadata, 6, type: Protocol.Harmonytypes.V1.Metadata
  field :update_metadata, 7, type: :bool
end

defmodule Protocol.Chat.V1.Event.GuildDeleted do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.Event.MemberJoined do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          member_id: non_neg_integer,
          guild_id: non_neg_integer
        }

  defstruct [:member_id, :guild_id]

  field :member_id, 1, type: :uint64
  field :guild_id, 2, type: :uint64
end

defmodule Protocol.Chat.V1.Event.MemberLeft do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          member_id: non_neg_integer,
          guild_id: non_neg_integer,
          leave_reason: Protocol.Chat.V1.Event.LeaveReason.t()
        }

  defstruct [:member_id, :guild_id, :leave_reason]

  field :member_id, 1, type: :uint64
  field :guild_id, 2, type: :uint64
  field :leave_reason, 3, type: Protocol.Chat.V1.Event.LeaveReason, enum: true
end

defmodule Protocol.Chat.V1.Event.GuildAddedToList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          homeserver: String.t()
        }

  defstruct [:guild_id, :homeserver]

  field :guild_id, 1, type: :uint64
  field :homeserver, 2, type: :string
end

defmodule Protocol.Chat.V1.Event.GuildRemovedFromList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          homeserver: String.t()
        }

  defstruct [:guild_id, :homeserver]

  field :guild_id, 1, type: :uint64
  field :homeserver, 2, type: :string
end

defmodule Protocol.Chat.V1.Event.ActionPerformed do
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

defmodule Protocol.Chat.V1.Event.RoleMoved do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role_id: non_neg_integer,
          previous_id: non_neg_integer,
          next_id: non_neg_integer
        }

  defstruct [:guild_id, :role_id, :previous_id, :next_id]

  field :guild_id, 1, type: :uint64
  field :role_id, 2, type: :uint64
  field :previous_id, 3, type: :uint64
  field :next_id, 4, type: :uint64
end

defmodule Protocol.Chat.V1.Event.RoleDeleted do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role_id: non_neg_integer
        }

  defstruct [:guild_id, :role_id]

  field :guild_id, 1, type: :uint64
  field :role_id, 2, type: :uint64
end

defmodule Protocol.Chat.V1.Event.RoleCreated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role_id: non_neg_integer,
          role: Protocol.Chat.V1.Role.t() | nil
        }

  defstruct [:guild_id, :role_id, :role]

  field :guild_id, 1, type: :uint64
  field :role_id, 2, type: :uint64
  field :role, 3, type: Protocol.Chat.V1.Role
end

defmodule Protocol.Chat.V1.Event.RoleUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role_id: non_neg_integer,
          role: Protocol.Chat.V1.Role.t() | nil
        }

  defstruct [:guild_id, :role_id, :role]

  field :guild_id, 1, type: :uint64
  field :role_id, 3, type: :uint64
  field :role, 4, type: Protocol.Chat.V1.Role
end

defmodule Protocol.Chat.V1.Event.RolePermissionsUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          role_id: non_neg_integer,
          perms: Protocol.Chat.V1.PermissionList.t() | nil
        }

  defstruct [:guild_id, :channel_id, :role_id, :perms]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :role_id, 3, type: :uint64
  field :perms, 4, type: Protocol.Chat.V1.PermissionList
end

defmodule Protocol.Chat.V1.Event.UserRolesUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          user_id: non_neg_integer,
          role_ids: [non_neg_integer]
        }

  defstruct [:guild_id, :user_id, :role_ids]

  field :guild_id, 1, type: :uint64
  field :user_id, 2, type: :uint64
  field :role_ids, 3, repeated: true, type: :uint64
end

defmodule Protocol.Chat.V1.Event.ProfileUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer,
          new_username: String.t(),
          update_username: boolean,
          new_avatar: String.t(),
          update_avatar: boolean,
          new_status: Protocol.Harmonytypes.V1.UserStatus.t(),
          update_status: boolean,
          is_bot: boolean,
          update_is_bot: boolean
        }

  defstruct [
    :user_id,
    :new_username,
    :update_username,
    :new_avatar,
    :update_avatar,
    :new_status,
    :update_status,
    :is_bot,
    :update_is_bot
  ]

  field :user_id, 1, type: :uint64
  field :new_username, 2, type: :string
  field :update_username, 3, type: :bool
  field :new_avatar, 4, type: :string
  field :update_avatar, 5, type: :bool
  field :new_status, 6, type: Protocol.Harmonytypes.V1.UserStatus, enum: true
  field :update_status, 7, type: :bool
  field :is_bot, 8, type: :bool
  field :update_is_bot, 9, type: :bool
end

defmodule Protocol.Chat.V1.Event.Typing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer,
          guild_id: non_neg_integer,
          channel_id: non_neg_integer
        }

  defstruct [:user_id, :guild_id, :channel_id]

  field :user_id, 1, type: :uint64
  field :guild_id, 2, type: :uint64
  field :channel_id, 3, type: :uint64
end

defmodule Protocol.Chat.V1.Event.PermissionUpdated do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          query: String.t(),
          ok: boolean
        }

  defstruct [:guild_id, :channel_id, :query, :ok]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :query, 3, type: :string
  field :ok, 4, type: :bool
end

defmodule Protocol.Chat.V1.Event do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          event: {atom, any}
        }

  defstruct [:event]

  oneof :event, 0
  field :guild_added_to_list, 1, type: Protocol.Chat.V1.Event.GuildAddedToList, oneof: 0
  field :guild_removed_from_list, 2, type: Protocol.Chat.V1.Event.GuildRemovedFromList, oneof: 0
  field :action_performed, 3, type: Protocol.Chat.V1.Event.ActionPerformed, oneof: 0
  field :sent_message, 4, type: Protocol.Chat.V1.Event.MessageSent, oneof: 0
  field :edited_message, 5, type: Protocol.Chat.V1.Event.MessageUpdated, oneof: 0
  field :deleted_message, 6, type: Protocol.Chat.V1.Event.MessageDeleted, oneof: 0
  field :created_channel, 7, type: Protocol.Chat.V1.Event.ChannelCreated, oneof: 0
  field :edited_channel, 8, type: Protocol.Chat.V1.Event.ChannelUpdated, oneof: 0
  field :deleted_channel, 9, type: Protocol.Chat.V1.Event.ChannelDeleted, oneof: 0
  field :edited_guild, 10, type: Protocol.Chat.V1.Event.GuildUpdated, oneof: 0
  field :deleted_guild, 11, type: Protocol.Chat.V1.Event.GuildDeleted, oneof: 0
  field :joined_member, 12, type: Protocol.Chat.V1.Event.MemberJoined, oneof: 0
  field :left_member, 13, type: Protocol.Chat.V1.Event.MemberLeft, oneof: 0
  field :profile_updated, 14, type: Protocol.Chat.V1.Event.ProfileUpdated, oneof: 0
  field :typing, 15, type: Protocol.Chat.V1.Event.Typing, oneof: 0
  field :role_created, 16, type: Protocol.Chat.V1.Event.RoleCreated, oneof: 0
  field :role_deleted, 17, type: Protocol.Chat.V1.Event.RoleDeleted, oneof: 0
  field :role_moved, 18, type: Protocol.Chat.V1.Event.RoleMoved, oneof: 0
  field :role_updated, 19, type: Protocol.Chat.V1.Event.RoleUpdated, oneof: 0
  field :role_perms_updated, 20, type: Protocol.Chat.V1.Event.RolePermissionsUpdated, oneof: 0
  field :user_roles_updated, 21, type: Protocol.Chat.V1.Event.UserRolesUpdated, oneof: 0
  field :permission_updated, 22, type: Protocol.Chat.V1.Event.PermissionUpdated, oneof: 0
end
