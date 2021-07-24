# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Protocol.Auth.V1.BeginAuthResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          auth_id: String.t()
        }

  defstruct [:auth_id]

  field :auth_id, 1, type: :string
end

defmodule Protocol.Auth.V1.Session do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer,
          session_token: String.t()
        }

  defstruct [:user_id, :session_token]

  field :user_id, 1, type: :uint64
  field :session_token, 2, type: :string
end

defmodule Protocol.Auth.V1.AuthStep.Choice do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          title: String.t(),
          options: [String.t()]
        }

  defstruct [:title, :options]

  field :title, 1, type: :string
  field :options, 2, repeated: true, type: :string
end

defmodule Protocol.Auth.V1.AuthStep.Form.FormField do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          type: String.t()
        }

  defstruct [:name, :type]

  field :name, 1, type: :string
  field :type, 2, type: :string
end

defmodule Protocol.Auth.V1.AuthStep.Form do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          title: String.t(),
          fields: [Protocol.Auth.V1.AuthStep.Form.FormField.t()]
        }

  defstruct [:title, :fields]

  field :title, 1, type: :string
  field :fields, 2, repeated: true, type: Protocol.Auth.V1.AuthStep.Form.FormField
end

defmodule Protocol.Auth.V1.AuthStep.Waiting do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t()
        }

  defstruct [:title, :description]

  field :title, 1, type: :string
  field :description, 2, type: :string
end

defmodule Protocol.Auth.V1.AuthStep do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step: {atom, any},
          fallback_url: String.t(),
          can_go_back: boolean
        }

  defstruct [:step, :fallback_url, :can_go_back]

  oneof :step, 0
  field :fallback_url, 1, type: :string
  field :can_go_back, 2, type: :bool
  field :choice, 3, type: Protocol.Auth.V1.AuthStep.Choice, oneof: 0
  field :form, 4, type: Protocol.Auth.V1.AuthStep.Form, oneof: 0
  field :session, 5, type: Protocol.Auth.V1.Session, oneof: 0
  field :waiting, 6, type: Protocol.Auth.V1.AuthStep.Waiting, oneof: 0
end

defmodule Protocol.Auth.V1.NextStepRequest.Choice do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          choice: String.t()
        }

  defstruct [:choice]

  field :choice, 1, type: :string
end

defmodule Protocol.Auth.V1.NextStepRequest.FormFields do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          field: {atom, any}
        }

  defstruct [:field]

  oneof :field, 0
  field :bytes, 1, type: :bytes, oneof: 0
  field :string, 2, type: :string, oneof: 0
  field :number, 3, type: :int64, oneof: 0
end

defmodule Protocol.Auth.V1.NextStepRequest.Form do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          fields: [Protocol.Auth.V1.NextStepRequest.FormFields.t()]
        }

  defstruct [:fields]

  field :fields, 1, repeated: true, type: Protocol.Auth.V1.NextStepRequest.FormFields
end

defmodule Protocol.Auth.V1.NextStepRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step: {atom, any},
          auth_id: String.t()
        }

  defstruct [:step, :auth_id]

  oneof :step, 0
  field :auth_id, 1, type: :string
  field :choice, 2, type: Protocol.Auth.V1.NextStepRequest.Choice, oneof: 0
  field :form, 3, type: Protocol.Auth.V1.NextStepRequest.Form, oneof: 0
end

defmodule Protocol.Auth.V1.StepBackRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          auth_id: String.t()
        }

  defstruct [:auth_id]

  field :auth_id, 1, type: :string
end

defmodule Protocol.Auth.V1.StreamStepsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          auth_id: String.t()
        }

  defstruct [:auth_id]

  field :auth_id, 1, type: :string
end

defmodule Protocol.Auth.V1.FederateRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          target: String.t()
        }

  defstruct [:target]

  field :target, 1, type: :string
end

defmodule Protocol.Auth.V1.FederateReply do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          token: Protocol.Harmonytypes.V1.Token.t() | nil,
          nonce: String.t()
        }

  defstruct [:token, :nonce]

  field :token, 1, type: Protocol.Harmonytypes.V1.Token
  field :nonce, 2, type: :string
end

defmodule Protocol.Auth.V1.KeyReply do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: binary
        }

  defstruct [:key]

  field :key, 1, type: :bytes
end

defmodule Protocol.Auth.V1.LoginFederatedRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          auth_token: Protocol.Harmonytypes.V1.Token.t() | nil,
          domain: String.t()
        }

  defstruct [:auth_token, :domain]

  field :auth_token, 1, type: Protocol.Harmonytypes.V1.Token
  field :domain, 2, type: :string
end

defmodule Protocol.Auth.V1.TokenData do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: non_neg_integer,
          target: String.t(),
          username: String.t(),
          avatar: String.t()
        }

  defstruct [:user_id, :target, :username, :avatar]

  field :user_id, 1, type: :uint64
  field :target, 2, type: :string
  field :username, 3, type: :string
  field :avatar, 4, type: :string
end
