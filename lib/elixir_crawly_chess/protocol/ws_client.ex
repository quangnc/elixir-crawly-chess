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

  @impl true
  def handle_connect(_conn, state) do
    IO.puts("WSS connected")
    {:ok, bin} = Base.decode64("G1oAAAAAAAAAAAAAAAAAAd4AAAACAAAATQQFAAUAAABTAAAAAAAAAAAAAAAFAAAAR3Vlc3QEAAAAUGFzc8ZBNgLwmcxEhh/PER79thAFAAAAZW4tVVMIAAAATWFjSW50ZWzkBAAAAAAAAAAAAAAAAAAAAAAAAIAAAABwAAAANS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzE1XzcpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OS4wLjQ4NDQuNTEgU2FmYXJpLzUzNy4zNgAAAAA=")
    WebSockex.cast(self(), {:binary, bin})
    {:ok, state}
  end

  @impl true
  def handle_disconnect(_status, state) do
    IO.puts("disconnected")
    {:ok, state}
  end

  @impl true
  def handle_info(data, state) do
    IO.inspect("Handle info")
    {:reply, data, state}
  end

  @impl true
  def handle_frame({:binary, data}, state) do
    # IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    result = ElixirCrawlyChess.Protocol.WSMsg.decode(data, :false)
    IO.puts("MessType: #{result.header.type}")

    case result.header.type do
      7004 -> handle_user_info(result, state)
      7106 -> IO.inspect(result)
      _ -> IO.puts("No action mapping to type: #{result.header.type}")
    end

    {:ok, state}
  end

  @impl true
  def handle_frame(data, state) do
    IO.puts("------ NO FRAME HANDLE -----")
    IO.inspect(data)
    {:reply, data, state}
  end

  @impl true
  def handle_cast(data, state) do
    IO.puts "Sending cast"
    {:reply, data, state}
  end


  def handle_user_info(result, _state) do
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

    WebSockex.cast(self(), {:binary, msg})
  end


end
