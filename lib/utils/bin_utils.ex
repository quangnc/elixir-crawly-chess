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

  def write_size(bin) do
    <<bin::size(32)>>
  end

  def write_size16(bin) do
    <<bin::size(16)>>
  end

  def read_string(<<size::little-size(32), str::binary-size(size), rest::binary>>) do
    {
      str,
      rest
    }
  end

  def read_byte_len_string(bin) do
    <<size::little-size(8), rest::binary>> = bin
    numberSize = size - 1
    <<str::binary-size(numberSize), _::little-size(8), rest::binary>> = rest
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

  def read_int8(<<number::little-integer-size(8), rest::binary>>) do
    {
      number,
      rest
    }
  end

  def read_size(<<number::size(32), rest::binary>>) do
    {
      number,
      rest
    }
  end

  def read_size16(<<number::size(16), rest::binary>>) do
    {
      number,
      rest
    }
  end
end
