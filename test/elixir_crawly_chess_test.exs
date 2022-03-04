defmodule ElixirCrawlyChessTest do
  alias ElixirCrawlyChess.Protocol.WSMsg, as: WSMsg

  use ExUnit.Case
  doctest ElixirCrawlyChess

  test "greets the world" do
    bin =
      "G7wAAAAAAA8tBgAAAAAAAQAAAAc6AAAANgAAAAEJAAAAIE1hcnRpbmV6AAAAAAAAAAAAAAAAAAAAALgLAAAAAAAAAAAAAAAA//9wAQAAAAAAAA1R"
    bin_decode = bin
                 |> Base.decode64!()

    ws_msg_decode = WSMsg.decode(bin_decode, true)
    ws_msg_encode = WSMsg.encode(ws_msg_decode, true)
    IO.inspect(bin_decode, limit: :infinity)
    IO.inspect(ws_msg_encode, limit: :infinity)
    assert bin_decode == ws_msg_encode
  end

  test "logon" do
    bin = "G1oAAAAAAAAAAAAAAAAAAdwAAAACAAAATQQFAAUAAABTAAAAAAAAAAAAAAAFAAAAR3Vlc3QEAAAAUGFzc+tM6ED1wch6cOxacyxhieoCAAAAdmkIAAAATWFjSW50ZWzkBAAAAAAAAAAAAAAAAAAAAAAAAIAAAABxAAAANS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzE1XzcpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTA5IFNhZmFyaS81MzcuMzYAAAAA"
    bin_decode = bin
                 |> Base.decode64!()
    ws_msg_decode = WSMsg.decode(bin_decode, false)
    ws_msg_encode = WSMsg.encode(ws_msg_decode, false)
    IO.inspect(ws_msg_decode, limit: :infinity)
    IO.inspect(ws_msg_encode, limit: :infinity)
    assert bin_decode == ws_msg_encode
  end
end
