# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.DB do
  import Ecto.Query
  alias Arpeggio.Repo

  @doc """
  The password in the local_user is salted by this function,
  and should be passed in verbatim from user input.
  """
  @spec new_local_user(Arpeggio.LocalUser.t(), Arpeggio.User.t()) :: {:ok, any} | {:error, any}
  def new_local_user(local_user, user) do
    try do
      Repo.transaction(fn ->
        Repo.insert!(%{user | user_name: local_user.username} |> Arpeggio.User.changeset)
        Repo.insert!(%{local_user | user_id: user.id, password: local_user.password |> Bcrypt.hash_pwd_salt} |> Arpeggio.LocalUser.changeset)
      end)
    rescue
      x -> {:error, x}
    end
  end

  defp random(len) do
    for _ <- 1..len, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  @spec login(bitstring, bitstring) :: {:ok, Arpeggio.LocalUser.t, Arpeggio.Session.t} | {:error, any, any}
  def login(email, password) do
    case Repo.get_by(Arpeggio.LocalUser, email: email) |> Repo.preload(:user) do
      nil ->
        {:error, "email not found", nil}
      user ->
        case Bcrypt.verify_pass(password, user.password) do
          true ->
            case Repo.insert(%Arpeggio.Session{ id: random(64), user_id: user.user_id }) do
              {:ok, session} ->
                {:ok, user, session}
              {:error, err} ->
                {:error, err, nil}
            end
          false ->
            {:error, "bad password", nil}
        end
    end
  end

  @spec get_user_by_session(bitstring) :: {:error} | {:ok, Arpeggio.User.t, {:local, Arpeggio.LocalUser.t} | {:remote, Arpeggio.RemoteUser.t}}
  def get_user_by_session(session_id) do
    case Repo.get_by(Arpeggio.Session, id: session_id) do
      nil ->
        {:error}
      session ->
        get_user session.user_id
    end
  end

  @spec new_remote_user(Arpeggio.RemoteUser.t(), Arpeggio.User.t()) :: {:ok, any} | {:error, any}
  def new_remote_user(remote_user, user) do
    try do
      Repo.transaction(fn ->
        Repo.insert!(user |> Arpeggio.User.changeset)
        Repo.insert!(%{remote_user | user_id: user.id} |> Arpeggio.RemoteUser.changeset)
      end)
    rescue
      x -> {:error, x}
    end
  end

  @spec get_user(integer) :: {:error} | {:ok, Arpeggio.User.t, {:local, Arpeggio.LocalUser.t} | {:remote, Arpeggio.RemoteUser.t}}
  def get_user(user_id) do
    user = Repo.get(Arpeggio.User, user_id) |> Repo.preload([:local_user, :remote_user])
    case user do
      nil ->
        {:error}
      user ->
        case user.local_user do
          nil ->
            case user.remote_user do
              nil ->
                raise "user has neither local nor remote"
              val ->
                {:ok, user, {:remote, val}}
            end
          val ->
            {:ok, user, {:local, val}}
        end
    end
  end

  @spec new_guild(Arpeggio.Guild.t()) :: {:ok, any} | {:error, any}
  def new_guild(guild) do
    try do
      Repo.transaction(fn ->
        g = Repo.insert!(guild |> Arpeggio.Guild.changeset)
        Arpeggio.DB.Channel.new guild.id, "general"
        g
      end)
    rescue
      x -> {:error, x}
    end
  end

  @spec get_guild_by_id(integer) :: {:ok, Arpeggio.Guild.t} | {:error}
  def get_guild_by_id(guild_id) do
    guild = Repo.get(Arpeggio.Guild, guild_id)
    case guild do
      nil ->  {:error}
      guild -> {:ok, guild}
    end
  end

  def check_session(conn) do
    session = Repo.get(Arpeggio.Session, conn |> Plug.Conn.get_req_header("authorization") |> Enum.at(0))
    case session do
      nil -> throw "bad session"
      _ -> nil
    end
  end

  def get_session(conn) do
    session = Repo.get(Arpeggio.Session, conn |> Plug.Conn.get_req_header("authorization") |> Enum.at(0))
    case session do
      nil -> throw "bad session"
      _ -> session
    end
  end

  def get_user_from(%Plug.Conn{} = conn, opts \\ %{load_local_remote: false}) do
    auth = conn |> Plug.Conn.get_req_header("authorization")

    q = case opts[:load_local_remote] do
      false -> from session in Arpeggio.Session, where: session.id == ^auth, preload: [:user]

      true -> from session in Arpeggio.Session,
        where: session.id == ^auth,
        left_join: user in assoc(session, :user),
        left_join: local_user in assoc(user, :local_user),
        left_join: remote_user in assoc(user, :remote_user),
        preload: [user: {user, local_user: local_user, remote_user: remote_user}]
    end

    case Repo.one q do
      nil -> throw "bad session"
      it -> it.user
    end
  end
end
