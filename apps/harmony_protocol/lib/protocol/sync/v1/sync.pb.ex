# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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

defmodule Protocol.Sync.V1.PostEventRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          event: Protocol.Sync.V1.Event.t() | nil
        }

  defstruct [:event]

  field :event, 1, type: Protocol.Sync.V1.Event
end

defmodule Protocol.Sync.V1.Ack do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          event_id: non_neg_integer
        }

  defstruct [:event_id]

  field :event_id, 1, type: :uint64
end

defmodule Protocol.Sync.V1.Syn do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          event_id: non_neg_integer,
          event: Protocol.Sync.V1.Event.t() | nil
        }

  defstruct [:event_id, :event]

  field :event_id, 1, type: :uint64
  field :event, 2, type: Protocol.Sync.V1.Event
end
