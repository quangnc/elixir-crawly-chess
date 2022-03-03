defmodule ElixirCrawlyChess.SearchMaskChess do
  def decode_search_mask(bin) do
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
      rest: res,
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

  def encode_search_mask(%{
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

    <<strWhMask_size::little-size(32), strWhMask::binary,
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
  end

  def decode_logon do

  end

  def search_mask(bin) do
    <<type::size(16), nVal::size(32), isSender::size(32), userType::size(16),
      idReceiver::size(32), msgId::size(32), nSize::size(32), body::binary>> = bin

    body =
      case type do
        7100 -> decode_body_search(body)
        _ -> decode_logon()
      end

    %{
      type: type,
      body: body
    }
  end

end
