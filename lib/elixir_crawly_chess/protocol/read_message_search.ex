defmodule ReadMessageSearch do
  use Bitwise

  def decode_ids_game(bin) do
    {n_read, rest} = BinUtils.read_int(bin)
    games = read_list_game(rest)

    %{
      n_read: n_read,
      games: games
    }
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

  defp do_read_game(
         <<size_read::little-size(32), bin::binary-size(size_read), rest_read::binary>>,
         list_game
       ) do
    {n_game_no, rest} = BinUtils.read_int(bin)
    {n_white_last, rest} = BinUtils.read_byte_len_string(rest)
    {n_white_first, rest} = BinUtils.read_byte_len_string(rest)
    {n_black_last, rest} = BinUtils.read_byte_len_string(rest)
    {n_black_first, rest} = BinUtils.read_byte_len_string(rest)
    # event
    {site, rest} = BinUtils.read_byte_len_string(rest)
    {event, rest} = BinUtils.read_byte_len_string(rest)
    {event_dt, rest} = BinUtils.read_int(rest)
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

    {annotator, rest} = BinUtils.read_byte_len_string(rest)
    {elo_wh, rest} = BinUtils.read_int16(rest)
    {elo_bl, rest} = BinUtils.read_int16(rest)
    {n_eco, rest} = BinUtils.read_int16(rest)
    # eco
    {result, rest} = BinUtils.read_int8(rest)
    {_, rest} = BinUtils.read_int16(rest)
    {dt, rest} = BinUtils.read_int(rest)
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
    l_line_len = list_line_len(rest, line_len)

    list_game =
      list_game ++
        [
          %{
            hdr: %{
              black: %{
                n_black_last: n_black_last,
                n_black_first: n_black_first
              },
              white: %{
                n_white_last: n_white_last,
                n_white_first: n_white_first
              },
              event: %{
                site: site,
                event: event,
                dt: event_dt,
                type: type,
                nation: nation,
                category: category,
                flags: flags,
                rounds: rounds
              },
              source: %{
                source: source,
                publisher: publisher,
                pubdt: pubdt,
                verdt: verdt,
                version: version,
                quality: quality
              },
              annotator: annotator,
              elo_wh: elo_wh,
              elo_bl: elo_bl,
              n_eco: n_eco,
              result: result,
              dt: dt,
              date: %{
                year: dt >>> 9,
                month: dt >>> 5 &&& 0x0F,
                day: dt &&& 0x1F
              },
              ply_count: ply_count,
              round: round,
              sub_round: sub_round
            },
            n_game_no: n_game_no,
            anno: anno,
            line_len: l_line_len
          }
        ]

    do_read_game(rest_read, list_game)
  end

  def list_line_len(bin, length) do
    do_line_len(bin, length, [])
  end

  defp do_line_len(_, 0, list) do
    list
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

  defp do_game_no(<<_::binary-size(2)>>, list) do
    list
  end

  defp do_game_no(<<n_game_no::little-size(32), rest::binary>>, list) do
    list = list ++ [n_game_no]
    do_game_no(rest, list)
  end
end
