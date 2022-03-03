defmodule ElixirCrawlyChessTest do
    alias ElixirCrawlyChess.Protocol.WSMsg, as: WSMsg

  use ExUnit.Case
  doctest ElixirCrawlyChess

  test "greets the world" do
     bin =
      "G7wAAAAAAA8tBgAAAAAAAQAAAAc6AAAANgAAAAEJAAAAIE1hcnRpbmV6AAAAAAAAAAAAAAAAAAAAALgLAAAAAAAAAAAAAAAA//9wAQAAAAAAAA1R"
      bin_decode = bin |> Base.decode64!()
      ws_msg_decode = WSMsg.decode(bin_decode)
      ws_msg_encode = WSMsg.encode(ws_msg_decode)
      IO.inspect(bin_decode, limit: :infinity)
      IO.inspect(ws_msg_encode, limit: :infinity)
      assert bin_decode == ws_msg_encode
  end
end
