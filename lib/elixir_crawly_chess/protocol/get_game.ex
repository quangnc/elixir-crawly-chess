defmodule GetGame do
  def encode(%{
        arr_ids: arr_ids,
        game_no: game_no
      }) do
    bin_body = BinUtils.write_int(arr_ids)
    bin_game = list_to_bin(game_no)
    bin_body <> bin_game
  end

  def decode(bin) do
    {arr_ids, rest} = BinUtils.read_int(bin)
    game_no = bin_to_list(rest)

    %{
      arr_ids: arr_ids,
      game_no: game_no
    }
  end

  def list_to_bin(arr) do
    do_list_to_bin(arr, <<>>)
  end

  defp do_list_to_bin([], bin) do
    bin
  end

  defp do_list_to_bin([head | tail], bin) do
    bin = bin <> BinUtils.write_int(head)
    do_list_to_bin(tail, bin)
  end

  def bin_to_list(bin) do
    do_bin_to_list(bin, [])
  end

  defp do_bin_to_list(<<>>, list) do
    list
  end

  defp do_bin_to_list(<<n_game_no::little-size(32), rest::binary>>, list) do
    list = list ++ [n_game_no]
    do_bin_to_list(rest,  list)
  end
end
