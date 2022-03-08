defmodule ReadMessage do
  def encode(%{
        n_id_default_playing_group: n_id_default_playing_group,
        n_id_broadcast_group: n_id_broadcast_group,
        n_id: n_id,
        n_id_CMS_archiv: n_id_CMS_archiv,
        str_token: str_token,
        account_type: account_type,
        str_userId: str_userId,
        n_flags: n_flags,
        rest: rest
      }) do
    BinUtils.write_int(n_id_default_playing_group) <>
      BinUtils.write_int(n_id_broadcast_group) <>
      BinUtils.write_int(n_id) <>
      BinUtils.write_int(n_id_CMS_archiv) <>
      BinUtils.write_string(str_token) <>
      BinUtils.write_int16(account_type) <>
      BinUtils.write_string(str_userId) <>
      BinUtils.write_int(n_flags) <> rest
  end

  def decode(bin) do
    {n_id_default_playing_group, rest} = BinUtils.read_int(bin)
    {n_id_broadcast_group, rest} = BinUtils.read_int(rest)
    {n_id, rest} = BinUtils.read_int(rest)
    {n_id_CMS_archiv, rest} = BinUtils.read_int(rest)
    {str_token, rest} = BinUtils.read_string(rest)
    {account_type, rest} = BinUtils.read_int16(rest)
    {str_userId, rest} = BinUtils.read_string(rest)
    {n_flags, rest} = BinUtils.read_int(rest)

    %{
      n_id_default_playing_group: n_id_default_playing_group,
      n_id_broadcast_group: n_id_broadcast_group,
      n_id: n_id,
      n_id_CMS_archiv: n_id_CMS_archiv,
      str_token: str_token,
      account_type: account_type,
      str_userId: str_userId,
      n_flags: n_flags,
      rest: rest
    }
  end
end
