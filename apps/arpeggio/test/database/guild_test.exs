defmodule ArpeggioWeb.Database.GuildTest do
  use ArpeggioWeb.ConnCase

  test "new guild" do
    {res, _val} = Arpeggio.DB.new_guild(%Arpeggio.Guild{
      id: 1,
      name: "test",
    })
    assert res == :ok

    {res, _val} = Arpeggio.DB.new_guild(%Arpeggio.Guild{
      id: 1,
      name: "test",
    })
    assert res == :error
  end

  test "default values are set" do
    res = Arpeggio.DB.new_guild(%Arpeggio.Guild{})
    assert match?({:ok, _}, res)
    {:ok, val} = res
    IO.inspect val
  end
end
