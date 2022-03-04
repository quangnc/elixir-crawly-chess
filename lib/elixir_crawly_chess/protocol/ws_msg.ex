defmodule ElixirCrawlyChess.Protocol.WSMsg do
  alias ElixirCrawlyChess.Protocol.SearchMsg, as: SearchMsg

  def encode(msg) do
    header_encode = <<
      msg.header.type :: size(16),
      msg.header.n_val :: size(32),
      msg.header.is_sender :: size(32),
      msg.header.user_type :: size(16),
      msg.header.id_receiver :: size(32),
      msg.header.msg_id :: size(32)
    >>

    body_encode = case msg.header.type do
      7100 -> SearchMsg.encode(msg.body)
      _ -> decode_logon()
    end

    body_encode_size = byte_size(body_encode)
    check_sum_body = check_sum(body_encode)

    header_encode <> <<body_encode_size :: little - size(32)>> <> body_encode <> <<check_sum_body :: size(16)>>
  end

  def encode_no_msg_id(msg) do
    header_encode = <<
      msg.header.type :: size(16),
      msg.header.n_val :: size(32),
      msg.header.is_sender :: size(32),
      msg.header.user_type :: size(16),
      msg.header.id_receiver :: size(32)
    >>

    body_encode = case msg.header.type do
      7002 -> LogonData.encode(msg.body)
      _ -> decode_logon()
    end

    body_encode_size = byte_size(body_encode)
    header_encode <> body_encode
  end


  def decode_logon() do

  end

  def decode(bin) do
    <<
      type :: size(16),
      n_val :: size(32),
      is_sender :: size(32),
      user_type :: size(16),
      id_receiver :: size(32),
      msg_id :: size(32),
      n_size :: little - size(32),
      body :: binary - size(n_size),
      rest :: binary
    >> = bin

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

  def decode_no_msg_id(bin) do
    IO.inspect(bin)

    <<
      type :: size(16),
      n_val :: size(32),
      is_sender :: size(32),
      user_type :: size(16),
      id_receiver :: size(32),
      n_size :: little - size(32),
      body :: binary - size(n_size),
      rest :: binary
    >> = bin

    body_decoded = case type do
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
