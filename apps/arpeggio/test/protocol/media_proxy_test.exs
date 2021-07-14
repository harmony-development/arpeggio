# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.MediaproxyTest do
  use ArpeggioWeb.ConnCase

  test "can instant view", %{conn: conn} do
    import Protocol.Mediaproxy.V1.InstantViewRequest

    body = new(url: "https://en.wikipedia.org/wiki/Ben_Shapiro") |> encode()

    conn =
      conn
      |> put_req_header("content-type", "application/hrpc")
      |> post("/protocol.mediaproxy.v1.MediaProxyService/CanInstantView", body)

    assert conn.status == 200

    resp = Protocol.Mediaproxy.V1.CanInstantViewResponse.decode(conn.resp_body)
    assert resp.can_instant_view
  end

  test "can't instant view", %{conn: conn} do
    import Protocol.Mediaproxy.V1.InstantViewRequest

    body = new(url: "https://google.com") |> encode()

    conn =
      conn
      |> put_req_header("content-type", "application/hrpc")
      |> post("/protocol.mediaproxy.v1.MediaProxyService/CanInstantView", body)

    assert conn.status == 200

    resp = Protocol.Mediaproxy.V1.CanInstantViewResponse.decode(conn.resp_body)
    assert !resp.can_instant_view
  end

  test "instant view", %{conn: conn} do
    import Protocol.Mediaproxy.V1.InstantViewRequest

    body = new(url: "https://en.wikipedia.org/wiki/Ben_Shapiro") |> encode()

    conn =
      conn
      |> put_req_header("content-type", "application/hrpc")
      |> post("/protocol.mediaproxy.v1.MediaProxyService/InstantView", body)

    assert conn.status == 200

    resp = Protocol.Mediaproxy.V1.InstantViewResponse.decode(conn.resp_body)
    assert resp.content =~ "Ben"
  end

  test "link preview", %{conn: conn} do
    import Protocol.Mediaproxy.V1.FetchLinkMetadataRequest

    body = new(url: "https://en.wikipedia.org/wiki/Ben_Shapiro") |> encode()

    conn =
      conn
      |> put_req_header("content-type", "application/hrpc")
      |> post("/protocol.mediaproxy.v1.MediaProxyService/FetchLinkMetadata", body)

    assert conn.status == 200

    Protocol.Mediaproxy.V1.FetchLinkMetadataResponse.decode(conn.resp_body)
  end
end
