# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Mediaproxy.V1.SiteMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          site_title: String.t(),
          page_title: String.t(),
          kind: String.t(),
          description: String.t(),
          url: String.t(),
          image: String.t()
        }

  defstruct [:site_title, :page_title, :kind, :description, :url, :image]

  field :site_title, 1, type: :string
  field :page_title, 2, type: :string
  field :kind, 3, type: :string
  field :description, 4, type: :string
  field :url, 5, type: :string
  field :image, 6, type: :string
end

defmodule Protocol.Mediaproxy.V1.MediaMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          mimetype: String.t(),
          filename: String.t()
        }

  defstruct [:mimetype, :filename]

  field :mimetype, 1, type: :string
  field :filename, 2, type: :string
end

defmodule Protocol.Mediaproxy.V1.FetchLinkMetadataRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          url: String.t()
        }

  defstruct [:url]

  field :url, 1, type: :string
end

defmodule Protocol.Mediaproxy.V1.FetchLinkMetadataResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: {atom, any}
        }

  defstruct [:data]

  oneof :data, 0
  field :is_site, 1, type: Protocol.Mediaproxy.V1.SiteMetadata, oneof: 0
  field :is_media, 2, type: Protocol.Mediaproxy.V1.MediaMetadata, oneof: 0
end

defmodule Protocol.Mediaproxy.V1.InstantViewRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          url: String.t()
        }

  defstruct [:url]

  field :url, 1, type: :string
end

defmodule Protocol.Mediaproxy.V1.InstantViewResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          metadata: Protocol.Mediaproxy.V1.SiteMetadata.t() | nil,
          content: String.t(),
          is_valid: boolean
        }

  defstruct [:metadata, :content, :is_valid]

  field :metadata, 1, type: Protocol.Mediaproxy.V1.SiteMetadata
  field :content, 2, type: :string
  field :is_valid, 3, type: :bool
end

defmodule Protocol.Mediaproxy.V1.CanInstantViewResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          can_instant_view: boolean
        }

  defstruct [:can_instant_view]

  field :can_instant_view, 1, type: :bool
end
