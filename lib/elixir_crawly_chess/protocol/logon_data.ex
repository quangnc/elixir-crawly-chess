defmodule LogonData do
  def encode(%{
        m_mode: m_mode,
        n_family: n_family,
        n_major: n_major,
        n_minor: n_minor,
        n_beta: n_beta,
        name: name,
        pass: pass,
        language: language,
        platform: platform,
        codepage: codepage,
        str_room: str_room,
        token: token,
        str_room_url: str_room_url,
        app: app,
        flags: flags,
        app_version: app_version,
        document_url: document_url,
        bytes_random: bytes_random
      }) do
    BinUtils.write_int(m_mode) <>
      BinUtils.write_int16(n_family) <>
      BinUtils.write_int16(n_major) <>
      BinUtils.write_int16(n_minor) <>
      BinUtils.write_int16(n_beta) <>
      BinUtils.write_int16(83) <>
      BinUtils.write_int16(0) <>
      BinUtils.write_int(0) <>
      BinUtils.write_int16(0) <>
      BinUtils.write_int16(0) <>
      BinUtils.write_string(name) <>
      BinUtils.write_string(pass) <>
      bytes_random <>
      BinUtils.write_string(language) <>
      BinUtils.write_string(platform) <>
      BinUtils.write_int(codepage) <>
      BinUtils.write_string(str_room) <>
      BinUtils.write_string(token) <>
      BinUtils.write_string(str_room_url) <>
      BinUtils.write_string(app) <>
      BinUtils.write_int(flags) <>
      BinUtils.write_string(app_version) <>
      BinUtils.write_string(document_url)
  end

  def decode(bin) do
    {m_mode, rest} = BinUtils.read_int(bin)
    {n_family, rest} = BinUtils.read_int16(rest)
    {n_major, rest} = BinUtils.read_int16(rest)
    {n_minor, rest} = BinUtils.read_int16(rest)
    {n_beta, rest} = BinUtils.read_int16(rest)
    # remove 12 bytes 83::size(16) 0::size(16) 0::size(32) 0::size(16) 0::size(16)
    <<_::binary-size(12), rest::binary>> = rest
    {name, rest} = BinUtils.read_string(rest)
    {pass, rest} = BinUtils.read_string(rest)
    # bytes_random: 16 byte random
    <<bytes_random::binary-size(16), rest::binary>> = rest
    {language, rest} = BinUtils.read_string(rest)
    {platform, rest} = BinUtils.read_string(rest)
    {codepage, rest} = BinUtils.read_int(rest)
    {str_room, rest} = BinUtils.read_string(rest)
    {token, rest} = BinUtils.read_string(rest)
    {str_room_url, rest} = BinUtils.read_string(rest)
    {app, rest} = BinUtils.read_string(rest)
    {flags, rest} = BinUtils.read_int(rest)
    {app_version, rest} = BinUtils.read_string(rest)
    {document_url, rest} = BinUtils.read_string(rest)

    %{
      m_mode: m_mode,
      n_family: n_family,
      n_major: n_major,
      n_minor: n_minor,
      n_beta: n_beta,
      name: name,
      pass: pass,
      language: language,
      platform: platform,
      codepage: codepage,
      str_room: str_room,
      token: token,
      str_room_url: str_room_url,
      app: app,
      flags: flags,
      app_version: app_version,
      document_url: document_url,
      bytes_random: bytes_random
    }
  end
end
