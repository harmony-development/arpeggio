# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :arpeggio,
  ecto_repos: [Arpeggio.Repo]

# Configures the endpoint
config :arpeggio, ArpeggioWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ka4S9hfqVpL7Ha2h2e4tIeHwjcRJb2vIHrijpgZMHHgZPYtFV8KPkbThGmL5vlvv",
  render_errors: [view: ArpeggioWeb.ErrorView, accepts: ~w(application/hrpc), layout: false],
  pubsub_server: Arpeggio.PubSub,
  live_view: [signing_salt: "uUXCd+A/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :snowflake,
  epoch: 1595849247727

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
