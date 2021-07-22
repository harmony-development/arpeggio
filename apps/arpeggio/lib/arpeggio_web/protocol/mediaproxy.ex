# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.Mediaproxy do
  @spec url_data(binary) :: {:error, %{}} | {:ok, %{text: binary}}
  def url_data(url) do
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        text = body
        |> Readability.article
        |> Readability.readable_text

        { :ok, %{text: text} }

      _ -> { :error, %{} }
    end
  end

  @spec instant_view(any, Protocol.Mediaproxy.V1.InstantViewRequest.t()) :: { :ok, Protocol.Mediaproxy.V1.InstantViewResponse.t() } | { :error, term() }
  def instant_view(_conn, request) do
    import Protocol.Mediaproxy.V1.InstantViewResponse

    case url_data(request.url) do
      { :ok, %{text: text} } ->
        { :ok, new(content: text, is_valid: true) }
      _ ->
        { :error, "bad body" }
    end
  end

  @spec fetch_link_metadata(any, Protocol.Mediaproxy.V1.FetchLinkMetadataRequest.t()) :: { :ok, Protocol.Mediaproxy.V1.FetchLinkMetadataResponse.t() } | { :error, term() }
  def fetch_link_metadata(_conn, _request) do
    { :error, "not implemented" }
  end

  @spec can_instant_view(any, Protocol.Mediaproxy.V1.InstantViewRequest.t()) :: { :ok, Protocol.Mediaproxy.V1.CanInstantViewResponse.t() } | { :error, term() }
  def can_instant_view(_conn, request) do
    import Protocol.Mediaproxy.V1.CanInstantViewResponse

    case url_data(request.url) do
      { :ok, %{text: _text } } ->
        { :ok, new(can_instant_view: true) }
      _ ->
        { :ok, new(can_instant_view: false) }
    end
  end
end
