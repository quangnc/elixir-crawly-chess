defmodule ElixirCrawlyChess do
  def decode_body_search(body) do
    <<body_size::little-size(32), 1, rest::binary>> = body
    <<body::binary-size(body_size), rest::binary>> = rest

    <<strWhMask_size::little-size(32), strWhMask::binary-size(strWhMask_size), rest::binary>> = body
    <<strBlMask_size::little-size(32), strBlMask::binary-size(strBlMask_size), rest::binary>> = rest
    <<strTitle_size::little-size(32), strTitle::binary-size(strTitle_size), rest::binary>> = rest
    <<strPlaceMask_size::little-size(32), strPlaceMask::binary-size(strPlaceMask_size), rest::binary>> = rest
    <<iMinYear::little-integer-size(16), rest::binary>> = rest
    <<iMaxYear::little-integer-size(16), rest::binary>> = rest
    <<iWhiteMinElo::little-integer-size(16), rest::binary>> = rest
    <<iBlackMinElo::little-integer-size(16), rest::binary>> = rest
    <<nMinECO::little-integer-size(16), rest::binary>> = rest
    <<nMaxECO::little-integer-size(16), rest::binary>> = rest
    <<nFlags::little-size(32), rest::binary>> = rest

    %{
      rest: rest,
      body_size: body_size,
      strWhMask: strWhMask,
      strBlMask: strBlMask,
      strTitle: strTitle,
      strPlaceMask: strPlaceMask,
      iMinYear: iMinYear,
      iMaxYear: iMaxYear,
      iWhiteMinElo: iWhiteMinElo,
      iBlackMinElo: iBlackMinElo,
      nMinECO: nMinECO,
      nMaxECO: nMaxECO,
      nFlags: nFlags
    }
  end

  def encode_body(%{
    strWhMask: strWhMask,
    strBlMask: strBlMask,
    strTitle: strTitle,
    strPlaceMask: strPlaceMask,
    iMinYear: iMinYear,
    iMaxYear: iMaxYear,
    iWhiteMinElo: iWhiteMinElo,
    iBlackMinElo: iBlackMinElo,
    nMinECO: nMinECO,
    nMaxECO: nMaxECO,
    nFlags: nFlags,
    rest: rest
  }) do
    strWhMask_size = byte_size(strWhMask)
    strBlMask_size = byte_size(strBlMask)
    strTitle_size = byte_size(strTitle)
    strPlaceMask_size = byte_size(strPlaceMask)

    body = <<1, strWhMask_size::little-size(32), strWhMask::binary,
    strBlMask_size::little-size(32), strBlMask::binary,
    strTitle_size::little-size(32), strTitle::binary,
    strPlaceMask_size::little-size(32), strPlaceMask::binary,
    iMinYear::little-integer-size(16),
    iMaxYear::little-integer-size(16),
    iWhiteMinElo::little-integer-size(16),
    iBlackMinElo::little-integer-size(16),
    nMinECO::little-integer-size(16),
    nMaxECO::little-integer-size(16),
    nFlags::little-size(32), rest::binary>>

    body_size = byte_size(body)
    <<body_size::little-size(32), body::binary>> <> body
  end

  def encode_header_body(bin, %{
    type: type,
        nVal: nVal,
        isSender: isSender,
        userType: userType,
        idReceiver: idReceiver,
        msgId: msgId,
        nSize: nSize
  }) do
     <<type::size(16), nVal::size(32), isSender::size(32), userType::size(16),
    idReceiver::size(32), msgId::size(32), nSize::size(32) >> <> bin
  end

  def decode_logon() do
    IO.puts('Logon')
  end

  def decode(bin) do
    <<type::size(16), nVal::size(32), isSender::size(32), userType::size(16),
      idReceiver::size(32), msgId::size(32), nSize::size(32), body::binary>> = bin

    body =
      case type do
        7100 -> decode_body_search(body)
        _ -> decode_logon()
      end

    %{
      header: %{
        type: type,
        nVal: nVal,
        isSender: isSender,
        userType: userType,
        idReceiver: idReceiver,
        msgId: msgId,
        nSize: nSize
      },
      body: body
    }
  end

  def main() do
    bin =
      "G7wAAAAAAA8tBgAAAAAAAQAAAAc6AAAANgAAAAEJAAAAIE1hcnRpbmV6AAAAAAAAAAAAAAAAAAAAALgLAAAAAAAAAAAAAAAA//9wAQAAAAAAAA1R"
      "G7wAAAAAAA8tBgAAAAAAAQAAAAc6AAAANwAAAAEJAAAAIE1hcnRpbmV6AAAAAAAAAAAAAAAAAAAAALgLAAAAAAAAAAAAAAAA//9wAQAAAAAAAA0BCQAAACBNYXJ0aW5legAAAAAAAAAAAAAAAAAAAAC4CwAAAAAAAAAAAAAAAP//cAEAAAAAAAAN"
    bin_decode = bin |> Base.decode64!()
    data = decode(bin_decode)
    encode = encode_body(data.body)
    encode_base64 = encode_header_body(encode, data.header) |> Base.encode64()
    IO.inspect(encode_base64)
  end
end

ElixirCrawlyChess.main
