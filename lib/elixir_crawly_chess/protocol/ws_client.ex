defmodule WsClient do
  use WebSockex

  def start_link(state) do
    extra_headers = [
      {"Accept-Encoding", "gzip, deflate, br"},
      {"Accept-Language", "en-US,en;q=0.9"},
      {"Cache-Control", "no-cache"},
      {"Connection", "Upgrade"},
      {"Host", "dbserver.chessbase.com"},
      {"Origin", "https://database.chessbase.com"},
      # {"Sec-WebSocket-Key", "AfzXlw1T23Li9VOsOpYP0Q=="},
      {"Sec-WebSocket-Version", 13},
      {"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36"},
      {"Upgrade", "websocket"}
    ]
    WebSockex.start_link("wss://dbserver.chessbase.com", __MODULE__, state, extra_headers: extra_headers)
  end

  def handle_connect(_conn, state) do
    IO.puts("WSS connected")
    send_first_message()
    {:ok, state}
  end

  def send_first_message() do
    {:ok, bin} = Base.decode64("G1oAAAAAAAAAAAAAAAAAAd4AAAACAAAATQQFAAUAAABTAAAAAAAAAAAAAAAFAAAAR3Vlc3QEAAAAUGFzc8ZBNgLwmcxEhh/PER79thAFAAAAZW4tVVMIAAAATWFjSW50ZWzkBAAAAAAAAAAAAAAAAAAAAAAAAIAAAABwAAAANS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzE1XzcpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OS4wLjQ4NDQuNTEgU2FmYXJpLzUzNy4zNgAAAAA=")
    IO.inspect(self())
    WebSockex.send_frame(self(), {:binary, bin})
    {:reply, {:binary, bin}}
  end

  def handle_disconnect(_status, state) do
    IO.puts("disconnected")
    {:ok, state}
  end

  def handle_info(data, state) do
    IO.inspect("Send data")
    {:reply, data, state}
  end


  def handle_frame({:binary, data}, state) do
    # IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    result = ElixirCrawlyChess.Protocol.WSMsg.decode(data, :false)

    IO.puts("MessType: #{result.header.type}")
    if (result.header.type === 7004) do
      header = %{
        :id_receiver => 1,
        :is_sender => result.body.n_id,
        :n_val => 0,
        :type => 7100,
        :user_type => 0,
        :msg_id => 100
      }
      body = %{
        :free_text => "",
        :i_black_min_elo => 0,
        :i_max_elo => 65535,
        :i_max_year => 3000,
        :i_min_elo => 0,
        :i_min_year => 0,
        :i_white_min_elo => 0,
        :n_flags => 368,
        :str_bl_mask => "",
        :str_place_mask => "",
        :str_title => "",
        :str_wh_mask => "Carrettoni",
      }

      body_frame = %{:header => header,:body => body }
      msg = ElixirCrawlyChess.Protocol.WSMsg.encode(body_frame)
      IO.inspect("Body length: #{byte_size(msg)}")
      # resultSend = WebSockex.send_frame(self(), {:binary, msg})
      resultSend = send(self(), {:binary, msg})
      IO.inspect(resultSend)
      {:reply, state}
    end


    {:reply, state}
  end

  def handle_cast(_, data, state) do
    IO.puts "Sending cast"
    {:reply, data, state}
  end
  def handle_cast() do
    # IO.puts "Sending #{type} frame with payload: #{msg}"
    IO.puts("send data ok")
    {:reply}
  end
end
