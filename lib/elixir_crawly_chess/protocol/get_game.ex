defmodule GetGame do
  def encode(%{
        arr_ids: arr_ids,
        game_no: game_no
      }) do
    bin_body = BinUtils.write_int(arr_ids)
    bin_game = bin_game(game_no)
    bin_body <> bin_game
  end

  def decode(bin) do
    {arr_ids, rest} = BinUtils.read_int(bin)
    game_no = list_game_no(rest)

    %{
      arr_ids: arr_ids,
      game_no: game_no
    }
  end

  def bin_game(arr) do
    do_bin_game(arr, <<>>)
  end

  defp do_bin_game([], bin) do
    bin
  end

  defp do_bin_game([head | tail], bin) do
    bin = bin <> BinUtils.write_int(head)
    do_bin_game(tail, bin)
  end

  def list_game_no(bin) do
    do_game_no(bin, [])
  end

  defp do_game_no(<<>>, list) do
    list
  end

  defp do_game_no(<<n_game_no::little-size(32), rest::binary>>, list) do
    list = list ++ [n_game_no]
    do_game_no(rest,  list)
  end
end
