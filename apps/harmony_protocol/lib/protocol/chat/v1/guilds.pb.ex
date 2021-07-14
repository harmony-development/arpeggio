# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.CreateGuildRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          guild_name: String.t(),
          picture_url: String.t()
        }

  defstruct [:metadata, :guild_name, :picture_url]

  field :metadata, 3, type: Protocol.Harmonytypes.V1.Metadata
  field :guild_name, 1, type: :string
  field :picture_url, 2, type: :string
end

defmodule Protocol.Chat.V1.CreateGuildResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.CreateInviteRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          name: String.t(),
          possible_uses: integer
        }

  defstruct [:guild_id, :name, :possible_uses]

  field :guild_id, 1, type: :uint64
  field :name, 2, type: :string
  field :possible_uses, 3, type: :int32
end

defmodule Protocol.Chat.V1.CreateInviteResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t()
        }

  defstruct [:name]

  field :name, 1, type: :string
end

defmodule Protocol.Chat.V1.GetGuildListRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3
  @type t :: %__MODULE__{}

  defstruct []
end

defmodule Protocol.Chat.V1.GetGuildListResponse.GuildListEntry do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          host: String.t()
        }

  defstruct [:guild_id, :host]

  field :guild_id, 1, type: :uint64
  field :host, 2, type: :string
end

defmodule Protocol.Chat.V1.GetGuildListResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guilds: [Protocol.Chat.V1.GetGuildListResponse.GuildListEntry.t()]
        }

  defstruct [:guilds]

  field :guilds, 1, repeated: true, type: Protocol.Chat.V1.GetGuildListResponse.GuildListEntry
end

defmodule Protocol.Chat.V1.GetGuildRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetGuildResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          guild_name: String.t(),
          guild_owner: non_neg_integer,
          guild_picture: String.t()
        }

  defstruct [:metadata, :guild_name, :guild_owner, :guild_picture]

  field :metadata, 4, type: Protocol.Harmonytypes.V1.Metadata
  field :guild_name, 1, type: :string
  field :guild_owner, 2, type: :uint64
  field :guild_picture, 3, type: :string
end

defmodule Protocol.Chat.V1.GetGuildInvitesRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetGuildInvitesResponse.Invite do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          invite_id: String.t(),
          possible_uses: integer,
          use_count: integer
        }

  defstruct [:invite_id, :possible_uses, :use_count]

  field :invite_id, 1, type: :string
  field :possible_uses, 2, type: :int32
  field :use_count, 3, type: :int32
end

defmodule Protocol.Chat.V1.GetGuildInvitesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          invites: [Protocol.Chat.V1.GetGuildInvitesResponse.Invite.t()]
        }

  defstruct [:invites]

  field :invites, 1, repeated: true, type: Protocol.Chat.V1.GetGuildInvitesResponse.Invite
end

defmodule Protocol.Chat.V1.GetGuildMembersRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetGuildMembersResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          members: [non_neg_integer]
        }

  defstruct [:members]

  field :members, 1, repeated: true, type: :uint64
end

defmodule Protocol.Chat.V1.UpdateGuildInformationRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          new_guild_name: String.t(),
          update_guild_name: boolean,
          new_guild_picture: String.t(),
          update_guild_picture: boolean,
          metadata: Protocol.Harmonytypes.V1.Metadata.t() | nil,
          update_metadata: boolean
        }

  defstruct [
    :guild_id,
    :new_guild_name,
    :update_guild_name,
    :new_guild_picture,
    :update_guild_picture,
    :metadata,
    :update_metadata
  ]

  field :guild_id, 1, type: :uint64
  field :new_guild_name, 2, type: :string
  field :update_guild_name, 3, type: :bool
  field :new_guild_picture, 4, type: :string
  field :update_guild_picture, 5, type: :bool
  field :metadata, 6, type: Protocol.Harmonytypes.V1.Metadata
  field :update_metadata, 7, type: :bool
end

defmodule Protocol.Chat.V1.DeleteGuildRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.DeleteInviteRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          invite_id: String.t()
        }

  defstruct [:guild_id, :invite_id]

  field :guild_id, 1, type: :uint64
  field :invite_id, 2, type: :string
end

defmodule Protocol.Chat.V1.JoinGuildRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          invite_id: String.t()
        }

  defstruct [:invite_id]

  field :invite_id, 1, type: :string
end

defmodule Protocol.Chat.V1.JoinGuildResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.PreviewGuildRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          invite_id: String.t()
        }

  defstruct [:invite_id]

  field :invite_id, 1, type: :string
end

defmodule Protocol.Chat.V1.PreviewGuildResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          avatar: String.t(),
          member_count: non_neg_integer
        }

  defstruct [:name, :avatar, :member_count]

  field :name, 1, type: :string
  field :avatar, 2, type: :string
  field :member_count, 3, type: :uint64
end

defmodule Protocol.Chat.V1.LeaveGuildRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.BanUserRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          user_id: non_neg_integer
        }

  defstruct [:guild_id, :user_id]

  field :guild_id, 1, type: :uint64
  field :user_id, 2, type: :uint64
end

defmodule Protocol.Chat.V1.KickUserRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          user_id: non_neg_integer
        }

  defstruct [:guild_id, :user_id]

  field :guild_id, 1, type: :uint64
  field :user_id, 2, type: :uint64
end

defmodule Protocol.Chat.V1.UnbanUserRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          user_id: non_neg_integer
        }

  defstruct [:guild_id, :user_id]

  field :guild_id, 1, type: :uint64
  field :user_id, 2, type: :uint64
end
