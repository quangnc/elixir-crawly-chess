defmodule ElixirCrawlyChess do
  alias ElixirCrawlyChess.Protocol.WSMsg, as: WSMsg

  def main() do
    bin =
      "G7wAAAAAAA8tBgAAAAAAAQAAAAc6AAAANgAAAAEJAAAAIE1hcnRpbmV6AAAAAAAAAAAAAAAAAAAAALgLAAAAAAAAAAAAAAAA//9wAQAAAAAAAA1R"

    bin_decode = bin |> Base.decode64!()
    # IO.inspect(bin_decode, limit: :infinity)

    ws_msg_decode = WSMsg.decode(bin_decode)
    #      ws_msg_encode = WSMsg.encode(ws_msg_decode)
  end
end

ElixirCrawlyChess.main()
