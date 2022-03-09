defmodule ReadMessageSearch do
  def encode(msg) do
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

  def list_game_no(bin) do
    do_game_no(bin, 0, [])
  end

  defp do_game_no(<<rest::binary-size(2)>>, _, list) do
    list
  end

  defp do_game_no(<<n_game_no::little-size(32), rest::binary>>, i, list) do
    list = list ++ [n_game_no]
    do_game_no(rest, i + 1, list)
  end
end
