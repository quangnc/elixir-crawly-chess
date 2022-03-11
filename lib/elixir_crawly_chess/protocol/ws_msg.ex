defmodule ElixirCrawlyChess.Protocol.WSMsg do
  alias ElixirCrawlyChess.Protocol.SearchMsg, as: SearchMsg

  def encode(msg, has_msg_id \\ true) do
    header_encode =
      BinUtils.write_size16(msg.header.type) <>
        BinUtils.write_size(msg.header.n_val) <>
        BinUtils.write_size(msg.header.is_sender) <>
        BinUtils.write_size16(msg.header.user_type) <>
        BinUtils.write_size(msg.header.id_receiver)

    body_encode =
      case msg.header.type do
        7100 -> SearchMsg.encode(msg.body)
        7002 -> LogonData.encode(msg.body)
        7004 -> ReadMessage.encode(msg.body)
        7101 -> GetGame.encode(msg.body)
        _ -> decode_logon()
      end

    body_encode_size = byte_size(body_encode)
    bin_body = <<body_encode_size::little-size(32)>> <> body_encode

    if has_msg_id do
      check_sum_body = check_sum(body_encode)

      header_encode <>
        BinUtils.write_int(msg.header.msg_id) <> bin_body <> BinUtils.write_size16(check_sum_body)
    else
      header_encode <> bin_body
    end
  end

  def decode_logon() do
  end

  def decode(bin, has_msg_id \\ true) do
    {type, rest} = BinUtils.read_size16(bin)
    {n_val, rest} = BinUtils.read_size(rest)
    {is_sender, rest} = BinUtils.read_size(rest)
    {user_type, rest} = BinUtils.read_size16(rest)
    {id_receiver, rest} = BinUtils.read_size(rest)

    msg =
      if has_msg_id do
        {msg_id, rest} = BinUtils.read_int(rest)

        %{
          msg_id: msg_id,
          rest: rest
        }
      end

    {body, rest} = BinUtils.read_string(if(has_msg_id, do: msg.rest, else: rest))

    body_decoded =
      case type do
        # QUERY_ONLINE_DB
        7100 -> SearchMsg.decode(body)
        7002 -> LogonData.decode(body)
        7004 -> ReadMessage.decode(body)
        # ONLINE_DB_NUMBERS
        7106 -> ReadMessageSearch.decode(body)
        7101 -> GetGame.decode(body)
        # ONLINE_DB_GAMES
        7107 -> ReadMessageSearch.decode_ids_game(body)
        _ -> decode_logon()
      end

    %{
      header: %{
        type: type,
        n_val: n_val,
        is_sender: is_sender,
        user_type: user_type,
        id_receiver: id_receiver,
        msg_id: if(has_msg_id, do: msg.msg_id, else: 0)
      },
      body: body_decoded,
      checkSum: rest
    }
  end

  def check_sum(bin) do
    do_check_sum(bin, 0, 0)
  end

  defp do_check_sum(<<>>, _, sum) do
    rem(sum, 0x7FFF)
  end

  defp do_check_sum(<<b, rest::binary>>, i, sum) do
    sum = sum + b + i
    do_check_sum(rest, i + 1, sum)
  end
end
