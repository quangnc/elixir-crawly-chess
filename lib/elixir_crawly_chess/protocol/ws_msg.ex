defmodule ElixirCrawlyChess.Protocol.WSMsg do
  alias ElixirCrawlyChess.Protocol.SearchMsg, as: SearchMsg

  def encode(msg, has_msg_id \\ true) do
    header_encode = BinUtils.write_size16(msg.header.type) <>
    BinUtils.write_int(msg.header.n_val) <>
    BinUtils.write_int(msg.header.is_sender) <>
    BinUtils.write_int16(msg.header.user_type) <>
    BinUtils.write_int(msg.header.id_receiver)

    body_encode = case msg.header.type do
      7100 -> SearchMsg.encode(msg.body)
      7002 -> LogonData.encode(msg.body)
      _ -> decode_logon()
    end

    if has_msg_id do
      body_encode_size = byte_size(body_encode)
      check_sum_body = check_sum(body_encode)
      header_encode <> BinUtils.write_int(msg.header.msg_id) <> <<body_encode_size :: little - size(32)>> <> body_encode <> <<check_sum_body :: size(16)>>
    else
      header_encode <> body_encode
    end
  end

  def decode_logon() do

  end

  def decode(bin, has_msg_id \\ true) do

    {type, rest} = BinUtils.read_size16(bin)
    {n_val, rest} = BinUtils.read_int(rest)
    {is_sender, rest} = BinUtils.read_int(rest)
    {user_type, rest} = BinUtils.read_int16(rest)
    {id_receiver, rest} = BinUtils.read_int(rest)

    msg = if has_msg_id do
      {msg_id, rest} = BinUtils.read_int(rest)
      %{
        msg_id: msg_id,
        rest: rest
      }
    end

    {body, rest} = BinUtils.read_string(if(has_msg_id, do: msg.rest, else: rest))
    IO.inspect(type)

    body_decoded = case type do
      7100 -> SearchMsg.decode(body)
      7002 -> LogonData.decode(body)
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
    rem(sum, 0x7fff) end
  defp do_check_sum(<<b, rest :: binary>>, i, sum) do
    sum = (sum + b + i)
    do_check_sum(rest, i + 1, sum)
  end


end
