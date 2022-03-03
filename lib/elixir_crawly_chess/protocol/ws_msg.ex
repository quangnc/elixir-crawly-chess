defmodule ElixirCrawlyChess.Protocol.WSMsg do
  alias ElixirCrawlyChess.Protocol.SearchMsg, as: SearchMsg

  def encode(msg) do
    header_encode = <<msg.header.type::size(16), msg.header.n_val::size(32), msg.header.is_sender::size(32), msg.header.user_type::size(16),
      msg.header.id_receiver::size(32), msg.header.msg_id::size(32)>>

    body_encode = case msg.header.type do
      7100 -> SearchMsg.encode(msg.body)
      _ -> decode_logon()
    end

    body_encode_size = byte_size(body_encode)
    content = header_encode <> <<body_encode_size::little-size(32)>> <> body_encode
    check_sum = checkSum(content)
    content <> <<check_sum::size(16)>>
  end

  def decode_logon() do

  end

  def decode(bin) do
    <<type::size(16), n_val::size(32), is_sender::size(32), user_type::size(16),
      id_receiver::size(32), msg_id::size(32), n_size::little-size(32), body::binary-size(n_size),
      rest::binary>> = bin

      body_decoded = case type do
        7100 -> SearchMsg.decode(body)
        _ -> decode_logon()
      end

    %{
      header: %{
        type: type,
        n_val: n_val,
        is_sender: is_sender,
        user_type: user_type,
        id_receiver: id_receiver,
        msg_id: msg_id
      },
      body: body_decoded,
      checkSum: rest
    }
  end

  def checkSum(bin) do
     :binary.bin_to_list(bin) |> Enum.sum()
  end

end
