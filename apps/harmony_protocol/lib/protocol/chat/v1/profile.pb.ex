# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.GetUserRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer
        }

  defstruct [:user_id]

  field :user_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetUserResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_name: String.t(),
          user_avatar: String.t(),
          user_status: Protocol.Harmonytypes.V1.UserStatus.t(),
          is_bot: boolean
        }

  defstruct [:user_name, :user_avatar, :user_status, :is_bot]

  field :user_name, 1, type: :string
  field :user_avatar, 2, type: :string
  field :user_status, 3, type: Protocol.Harmonytypes.V1.UserStatus, enum: true
  field :is_bot, 4, type: :bool
end

defmodule Protocol.Chat.V1.GetUserBulkRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_ids: [non_neg_integer]
        }

  defstruct [:user_ids]

  field :user_ids, 1, repeated: true, type: :uint64
end

defmodule Protocol.Chat.V1.GetUserBulkResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          users: [Protocol.Chat.V1.GetUserResponse.t()]
        }

  defstruct [:users]

  field :users, 1, repeated: true, type: Protocol.Chat.V1.GetUserResponse
end

defmodule Protocol.Chat.V1.GetUserMetadataRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          app_id: String.t()
        }

  defstruct [:app_id]

  field :app_id, 1, type: :string
end

defmodule Protocol.Chat.V1.GetUserMetadataResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          metadata: String.t()
        }

  defstruct [:metadata]

  field :metadata, 1, type: :string
end

defmodule Protocol.Chat.V1.ProfileUpdateRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
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
    :new_username,
    :update_username,
    :new_avatar,
    :update_avatar,
    :new_status,
    :update_status,
    :is_bot,
    :update_is_bot
  ]

  field :new_username, 1, type: :string
  field :update_username, 2, type: :bool
  field :new_avatar, 3, type: :string
  field :update_avatar, 4, type: :bool
  field :new_status, 5, type: Protocol.Harmonytypes.V1.UserStatus, enum: true
  field :update_status, 6, type: :bool
  field :is_bot, 7, type: :bool
  field :update_is_bot, 8, type: :bool
end
