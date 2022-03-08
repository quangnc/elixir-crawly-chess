defmodule ElixirCrawlyChess.Protocol.SearchMsg do
  def encode(%{
        str_wh_mask: str_wh_mask,
        str_bl_mask: str_bl_mask,
        str_title: str_title,
        str_place_mask: str_place_mask,
        i_min_year: i_min_year,
        i_max_year: i_max_year,
        i_white_min_elo: i_white_min_elo,
        i_black_min_elo: i_black_min_elo,
        i_min_elo: i_min_elo,
        i_max_elo: i_max_elo,
        n_flags: n_flags,
        free_text: free_text
      }) do
    bin_body =
      BinUtils.write_string(str_wh_mask) <>
        BinUtils.write_string(str_bl_mask) <>
        BinUtils.write_string(str_title) <>
        BinUtils.write_string(str_place_mask) <>
        BinUtils.write_int(i_min_year) <>
        BinUtils.write_int(i_max_year) <>
        BinUtils.write_int(i_white_min_elo) <>
        BinUtils.write_int(i_black_min_elo) <>
        BinUtils.write_int16(i_min_elo) <>
        BinUtils.write_int16(i_max_elo) <>
        BinUtils.write_int(n_flags) <>
        BinUtils.write_string(free_text)

    bin_body_size = byte_size(bin_body) + 1
    <<bin_body_size::little-size(32), 1, bin_body::binary>>
  end

  def decode(bin) do
    <<_::binary-size(5), rest::binary>> = bin
    {str_wh_mask, rest} = BinUtils.read_string(rest)
    {str_bl_mask, rest} = BinUtils.read_string(rest)
    {str_title, rest} = BinUtils.read_string(rest)
    {str_place_mask, rest} = BinUtils.read_string(rest)
    {i_min_year, rest} = BinUtils.read_int(rest)
    {i_max_year, rest} = BinUtils.read_int(rest)
    {i_white_min_elo, rest} = BinUtils.read_int(rest)
    {i_black_min_elo, rest} = BinUtils.read_int(rest)
    {i_min_elo, rest} = BinUtils.read_int16(rest)
    {i_max_elo, rest} = BinUtils.read_int16(rest)
    {n_flags, rest} = BinUtils.read_int(rest)
    {free_text, <<>>} = BinUtils.read_string(rest)

    %{
      str_wh_mask: str_wh_mask,
      str_bl_mask: str_bl_mask,
      str_title: str_title,
      str_place_mask: str_place_mask,
      i_min_year: i_min_year,
      i_max_year: i_max_year,
      i_white_min_elo: i_white_min_elo,
      i_black_min_elo: i_black_min_elo,
      i_min_elo: i_min_elo,
      i_max_elo: i_max_elo,
      n_flags: n_flags,
      free_text: free_text
    }
  end
end
