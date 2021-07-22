# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Arpeggio.Repo,
      # Start the Telemetry supervisor
      ArpeggioWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: :arpeggio},
      # Start the Endpoint (http/https)
      ArpeggioWeb.Endpoint
      # Start a worker by calling: Arpeggio.Worker.start_link(arg)
      # {Arpeggio.Worker, arg}
    ]

    :ets.new(:auth_sessions, [:set, :public, :named_table])

    load_privkey()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arpeggio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def load_privkey() do
    data = case File.read(Application.get_env(:arpeggio, :federation_private_key)) do
      {:ok, data} -> data
      {:error, _kind} -> raise "you don't have a valid private key! run mix gen_key to generate a key at the configured path in your config file."
    end

    key = case Ed25519.decode_pem data do
      :error -> raise "you don't have a valid private key! run mix gen_key to generate a key at the configured path in your config file."
      key -> key
    end

    Application.put_env(:arpeggio, :_private_key, key)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    load_privkey()

    ArpeggioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
