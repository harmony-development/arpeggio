# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Chat.V1.CreateEmotePackRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_name: String.t()
        }

  defstruct [:pack_name]

  field :pack_name, 1, type: :string
end

defmodule Protocol.Chat.V1.CreateEmotePackResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer
        }

  defstruct [:pack_id]

  field :pack_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetEmotePacksRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3
  @type t :: %__MODULE__{}

  defstruct []
end

defmodule Protocol.Chat.V1.GetEmotePacksResponse.EmotePack do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer,
          pack_owner: non_neg_integer,
          pack_name: String.t()
        }

  defstruct [:pack_id, :pack_owner, :pack_name]

  field :pack_id, 1, type: :uint64
  field :pack_owner, 2, type: :uint64
  field :pack_name, 3, type: :string
end

defmodule Protocol.Chat.V1.GetEmotePacksResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          packs: [Protocol.Chat.V1.GetEmotePacksResponse.EmotePack.t()]
        }

  defstruct [:packs]

  field :packs, 1, repeated: true, type: Protocol.Chat.V1.GetEmotePacksResponse.EmotePack
end

defmodule Protocol.Chat.V1.GetEmotePackEmotesRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer
        }

  defstruct [:pack_id]

  field :pack_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.GetEmotePackEmotesResponse.Emote do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          image_id: String.t(),
          name: String.t()
        }

  defstruct [:image_id, :name]

  field :image_id, 1, type: :string
  field :name, 2, type: :string
end

defmodule Protocol.Chat.V1.GetEmotePackEmotesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          emotes: [Protocol.Chat.V1.GetEmotePackEmotesResponse.Emote.t()]
        }

  defstruct [:emotes]

  field :emotes, 1, repeated: true, type: Protocol.Chat.V1.GetEmotePackEmotesResponse.Emote
end

defmodule Protocol.Chat.V1.AddEmoteToPackRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer,
          image_id: String.t(),
          name: String.t()
        }

  defstruct [:pack_id, :image_id, :name]

  field :pack_id, 1, type: :uint64
  field :image_id, 2, type: :string
  field :name, 3, type: :string
end

defmodule Protocol.Chat.V1.DeleteEmoteFromPackRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer,
          image_id: String.t()
        }

  defstruct [:pack_id, :image_id]

  field :pack_id, 1, type: :uint64
  field :image_id, 2, type: :string
end

defmodule Protocol.Chat.V1.DeleteEmotePackRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer
        }

  defstruct [:pack_id]

  field :pack_id, 1, type: :uint64
end

defmodule Protocol.Chat.V1.DequipEmotePackRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pack_id: non_neg_integer
        }

  defstruct [:pack_id]

  field :pack_id, 1, type: :uint64
end
