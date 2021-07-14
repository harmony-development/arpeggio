# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.Permission.Mode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3
  @type t :: integer | :Allow | :Deny

  field :Allow, 0

  field :Deny, 1
end

defmodule Protocol.Chat.V1.QueryPermissionsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          check_for: String.t(),
          as: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :check_for, :as]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :check_for, 3, type: :string
  field :as, 4, type: :uint64
end

defmodule Protocol.Chat.V1.QueryPermissionsResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          ok: boolean
        }

  defstruct [:ok]

  field :ok, 1, type: :bool
end

defmodule Protocol.Chat.V1.Permission do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          matches: String.t(),
          mode: Protocol.Chat.V1.Permission.Mode.t()
        }

  defstruct [:matches, :mode]

  field :matches, 1, type: :string
  field :mode, 2, type: Protocol.Chat.V1.Permission.Mode, enum: true
end

defmodule Protocol.Chat.V1.PermissionList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          permissions: [Protocol.Chat.V1.Permission.t()]
        }

  defstruct [:permissions]

  field :permissions, 1, repeated: true, type: Protocol.Chat.V1.Permission
end

defmodule Protocol.Chat.V1.SetPermissionsRequest do
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

defmodule Protocol.Chat.V1.GetPermissionsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          channel_id: non_neg_integer,
          role_id: non_neg_integer
        }

  defstruct [:guild_id, :channel_id, :role_id]

  field :guild_id, 1, type: :uint64
  field :channel_id, 2, type: :uint64
  field :role_id, 3, type: :uint64
end

defmodule Protocol.Chat.V1.GetPermissionsResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          perms: Protocol.Chat.V1.PermissionList.t() | nil
        }

  defstruct [:perms]

  field :perms, 1, type: Protocol.Chat.V1.PermissionList
end

defmodule Protocol.Chat.V1.Role do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role_id: non_neg_integer,
          name: String.t(),
          color: integer,
          hoist: boolean,
          pingable: boolean
        }

  defstruct [:role_id, :name, :color, :hoist, :pingable]

  field :role_id, 1, type: :uint64
  field :name, 2, type: :string
  field :color, 3, type: :int32
  field :hoist, 4, type: :bool
  field :pingable, 5, type: :bool
end

defmodule Protocol.Chat.V1.MoveRoleRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role_id: non_neg_integer,
          before_id: non_neg_integer,
          after_id: non_neg_integer
        }

  defstruct [:guild_id, :role_id, :before_id, :after_id]

  field :guild_id, 1, type: :uint64
  field :role_id, 2, type: :uint64
  field :before_id, 3, type: :uint64
  field :after_id, 4, type: :uint64
end

defmodule Protocol.Chat.V1.MoveRoleResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3
  @type t :: %__MODULE__{}

  defstruct []
end

defmodule Protocol.Chat.V1.GetGuildRolesRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer
        }

  defstruct [:guild_id]

  field :guild_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetGuildRolesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          roles: [Protocol.Chat.V1.Role.t()]
        }

  defstruct [:roles]

  field :roles, 1, repeated: true, type: Protocol.Chat.V1.Role
end

defmodule Protocol.Chat.V1.AddGuildRoleRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role: Protocol.Chat.V1.Role.t() | nil
        }

  defstruct [:guild_id, :role]

  field :guild_id, 1, type: :uint64
  field :role, 2, type: Protocol.Chat.V1.Role
end

defmodule Protocol.Chat.V1.AddGuildRoleResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role_id: non_neg_integer
        }

  defstruct [:role_id]

  field :role_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.DeleteGuildRoleRequest do
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

defmodule Protocol.Chat.V1.ModifyGuildRoleRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          role: Protocol.Chat.V1.Role.t() | nil,
          modify_name: boolean,
          modify_color: boolean,
          modify_hoist: boolean,
          modify_pingable: boolean
        }

  defstruct [:guild_id, :role, :modify_name, :modify_color, :modify_hoist, :modify_pingable]

  field :guild_id, 1, type: :uint64
  field :role, 2, type: Protocol.Chat.V1.Role
  field :modify_name, 3, type: :bool
  field :modify_color, 4, type: :bool
  field :modify_hoist, 5, type: :bool
  field :modify_pingable, 6, type: :bool
end

defmodule Protocol.Chat.V1.ManageUserRolesRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          guild_id: non_neg_integer,
          user_id: non_neg_integer,
          give_role_ids: [non_neg_integer],
          take_role_ids: [non_neg_integer]
        }

  defstruct [:guild_id, :user_id, :give_role_ids, :take_role_ids]

  field :guild_id, 1, type: :uint64
  field :user_id, 2, type: :uint64
  field :give_role_ids, 3, repeated: true, type: :uint64
  field :take_role_ids, 4, repeated: true, type: :uint64
end

defmodule Protocol.Chat.V1.GetUserRolesRequest do
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

defmodule Protocol.Chat.V1.GetUserRolesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          roles: [non_neg_integer]
        }

  defstruct [:roles]

  field :roles, 1, repeated: true, type: :uint64
end
