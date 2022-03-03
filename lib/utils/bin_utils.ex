defmodule BinUtils do

  def write_string(bin) do
    bin_size = byte_size(bin)
    <<bin_size::little-size(32), bin::binary>>
  end

  def write_int(bin) do
   <<bin::little-integer-size(32)>>
  end

  def write_int16(bin) do
   <<bin::little-integer-size(16)>>
  end

  def read_string(<<size::little-size(32), str::binary-size(size), rest::binary>>) do
    {
      str,
      rest
    }
  end

  def read_int(<<int::little-integer-size(32), rest::binary>>) do
    {
      int,
      rest
    }
  end

   def read_int16(<<number::little-integer-size(16), rest::binary>>) do
    {
      number,
      rest
    }
  end


end
