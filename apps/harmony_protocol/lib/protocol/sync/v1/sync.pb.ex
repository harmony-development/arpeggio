# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Sync.V1.AuthData do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          host: String.t(),
          time: non_neg_integer
        }

  defstruct [:host, :time]

  field :host, 1, type: :string
  field :time, 2, type: :uint64
end

defmodule Protocol.Sync.V1.EventQueue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          events: [Protocol.Sync.V1.Event.t()]
        }

  defstruct [:events]

  field :events, 1, repeated: true, type: Protocol.Sync.V1.Event
end

defmodule Protocol.Sync.V1.Event.UserRemovedFromGuild do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer,
          guild_id: non_neg_integer
        }

  defstruct [:user_id, :guild_id]

  field :user_id, 1, type: :uint64
  field :guild_id, 2, type: :uint64
end

defmodule Protocol.Sync.V1.Event.UserAddedToGuild do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer,
          guild_id: non_neg_integer
        }

  defstruct [:user_id, :guild_id]

  field :user_id, 1, type: :uint64
  field :guild_id, 2, type: :uint64
end

defmodule Protocol.Sync.V1.Event do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: {atom, any}
        }

  defstruct [:kind]

  oneof :kind, 0
  field :user_removed_from_guild, 1, type: Protocol.Sync.V1.Event.UserRemovedFromGuild, oneof: 0
  field :user_added_to_guild, 2, type: Protocol.Sync.V1.Event.UserAddedToGuild, oneof: 0
end
