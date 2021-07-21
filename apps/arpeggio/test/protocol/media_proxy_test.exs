# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule ArpeggioWeb.MediaproxyTest do
  use ArpeggioWeb.ConnCase

  test "can instant view", %{conn: conn} do
    import Protocol.Mediaproxy.V1.InstantViewRequest

    body = new(url: "https://en.wikipedia.org/wiki/Ben_Shapiro")

    res = ArpeggioWeb.Mediaproxy.can_instant_view(body)

    assert match?({:ok, _}, res)
    {:ok, response} = res

    assert response.can_instant_view
  end

  test "can't instant view", %{conn: conn} do
    import Protocol.Mediaproxy.V1.InstantViewRequest

    body = new(url: "https://google.com")

    res = ArpeggioWeb.Mediaproxy.can_instant_view(body)

    assert match?({:ok, _}, res)
    {:ok, response} = res

    assert !response.can_instant_view
  end

  test "instant view", %{conn: conn} do
    import Protocol.Mediaproxy.V1.InstantViewRequest

    body = new(url: "https://en.wikipedia.org/wiki/Ben_Shapiro")

    res = ArpeggioWeb.Mediaproxy.instant_view(body)
    assert match?({:ok, _}, res)
    {:ok, response} = res

    assert response.content =~ "Ben"
  end

  test "link preview", %{conn: conn} do
    import Protocol.Mediaproxy.V1.FetchLinkMetadataRequest

    body = new(url: "https://en.wikipedia.org/wiki/Ben_Shapiro")

    res = ArpeggioWeb.Mediaproxy.fetch_link_metadata(body)
    assert match?({:ok, _}, res)
    {:ok, response} = res
  end
end
