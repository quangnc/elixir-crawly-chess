defmodule ReadMessageSearch do
  use Bitwise

  def decode_ids_game(bin) do

    {n_read, rest} = BinUtils.read_int(bin)
    red_game = read_list_game(rest)

  end

  def decode(bin) do
    {n_games, rest} = BinUtils.read_int(bin)
    {n_total_found, rest} = BinUtils.read_int(rest)
    arr_game_no = list_game_no(rest)

    %{
      n_games: n_games,
      n_total_found: n_total_found,
      arr_game_no: arr_game_no
    }
  end

  def read_list_game(bin) do
    do_read_game(bin, [])
  end

  defp do_read_game(<<>>, list_game) do
    list_game
  end

  defp do_read_game(bin, list_game) do
    {begin_size_read, rest} = BinUtils.read_int(bin)
    {n_game_no, rest} = BinUtils.read_int(rest)
    #    IO.inspect(rest)
    {n_white_last, rest} = BinUtils.read_byte_len_string(rest)
    {n_white_first, rest} = BinUtils.read_byte_len_string(rest)

    {n_black_last, rest} = BinUtils.read_byte_len_string(rest)
    {n_black_first, rest} = BinUtils.read_byte_len_string(rest)

    # event
    {site, rest} = BinUtils.read_byte_len_string(rest)
    {event, rest} = BinUtils.read_byte_len_string(rest)
    {dt, rest} = BinUtils.read_int(rest)
    {type, rest} = BinUtils.read_int16(rest)
    {nation, rest} = BinUtils.read_int16(rest)
    {category, rest} = BinUtils.read_int8(rest)
    {flags, rest} = BinUtils.read_int8(rest)
    {rounds, rest} = BinUtils.read_int16(rest)
    # SourceData
    {source, rest} = BinUtils.read_byte_len_string(rest)
    {publisher, rest} = BinUtils.read_byte_len_string(rest)
    {pubdt, rest} = BinUtils.read_int(rest)
    {verdt, rest} = BinUtils.read_int(rest)
    {version, rest} = BinUtils.read_int8(rest)
    {quality, rest} = BinUtils.read_int8(rest)

    # annotator
    {annotator, rest} = BinUtils.read_byte_len_string(rest)
    # end annotator
    {elo_wh, rest} = BinUtils.read_int16(rest)
    {elo_bl, rest} = BinUtils.read_int16(rest)
    {n_eco, rest} = BinUtils.read_int16(rest)
    # eco
    {result, rest} = BinUtils.read_int8(rest)
    {_, rest} = BinUtils.read_int16(rest)
    {dt, rest} = BinUtils.read_int(rest)

    data = %{
      year: dt >>> 9,
      month: dt >>> 5 &&& 0x0F,
      day: dt &&& 0x1F
    }

    {ply_count, rest} = BinUtils.read_int16(rest)
    {round, rest} = BinUtils.read_int8(rest)
    {sub_round, rest} = BinUtils.read_int8(rest)
    {_, rest} = BinUtils.read_int(rest)
    {_, rest} = BinUtils.read_int(rest)
    {_, rest} = BinUtils.read_string(rest)
    {normal_init, rest} = BinUtils.read_int8(rest)

    rest_normal =
      if normal_init != 1 do
        {_, rest} = BinUtils.read_int16(rest)
        {_, rest} = BinUtils.read_int16(rest)
        {_, rest} = BinUtils.read_int8(rest)

        rest
      end
    # anno
    {anno, rest} = BinUtils.read_int8(if(normal_init != 1, do: rest_normal, else: rest))
    {line_len, rest} = BinUtils.read_int8(rest)
    len = list_line_len(rest, line_len)

    list_game =
      list_game ++
        [
          %{
            n_game_no: n_game_no,
            n_white: %{
              n_white_last: n_white_last,
              n_white_first: n_white_first
            },
            len: len.list
          }
        ]

    do_read_game(len.bin, list_game)
  end

  def list_line_len(bin, length) do
    do_line_len(bin, length, [])
  end

  defp do_line_len(bin, 0, list) do
    %{
      bin: bin,
      list: list
    }
  end

  defp do_line_len(bin, length, list) do
    {from, rest} = BinUtils.read_int8(bin)
    {to, rest} = BinUtils.read_int8(rest)
    {nFlags, rest} = BinUtils.read_int8(rest)

    list =
      list ++
        [
          %{
            from: from,
            to: to,
            nFlags: nFlags
          }
        ]

    do_line_len(rest, length - 1, list)
  end

  def list_game_no(bin) do
    do_game_no(bin, [])
  end

  defp do_game_no(<<rest::binary-size(2)>>, list) do
    list
  end

  defp do_game_no(<<n_game_no::little-size(32), rest::binary>>, list) do
    list = list ++ [n_game_no]
    do_game_no(rest, list)
  end
end
