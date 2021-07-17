# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Arpeggio.DB do
  alias Arpeggio.Repo

  @doc """
  The password in the local_user is salted by this function,
  and should be passed in verbatim from user input.
  """
  @spec new_local_user(Arpeggio.LocalUser.t(), Arpeggio.User.t()) :: {:ok, any} | {:error, any}
  def new_local_user(local_user, user) do
    try do
      Repo.transaction(fn ->
        Repo.insert!(user |> Arpeggio.User.changeset)
        Repo.insert!(%{local_user | user_id: user.id, password: local_user.password |> Bcrypt.hash_pwd_salt} |> Arpeggio.LocalUser.changeset)
      end)
    rescue
      x -> {:error, x}
    end
  end

  @spec login(bitstring, bitstring) :: {:ok, Arpeggio.LocalUser.t, Arpeggio.User.t} | {:error, any, nil}
  def login(email, password) do
    case Repo.get_by(Arpeggio.LocalUser, email: email) do
      nil ->
        {:error, "email not found", nil}
      user ->
        case Bcrypt.verify_pass(password, user.password) do
          true ->
            {:ok, user, Repo.get!(Arpeggio.User, user.user_id)}
          false ->
            {:error, "bad password", nil}
        end
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
end
