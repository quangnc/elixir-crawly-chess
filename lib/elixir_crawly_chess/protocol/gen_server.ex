defmodule WsGenserver do
  use GenServer

  def start_link(_default) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(stack) do

    {:ok, conn_pid} = :gun.open('dbserver.chessbase.com', 443, %{transport: :tcp})
    {:ok, _protocol} = :gun.await_up(conn_pid)

    extra_headers = [
      {'Accept-Encoding', 'gzip, deflate, br'},
      {'Accept-Language', 'en-US,en;q=0.9'},
      {'Cache-Control', 'no-cache'},
      {'Connection', 'Upgrade'},
      {'Host', 'dbserver.chessbase.com'},
      {'Origin', 'https://database.chessbase.com'},
      # {'Sec-WebSocket-Key', 'AfzXlw1T23Li9VOsOpYP0Q=='},
      {'Sec-WebSocket-Version', 13},
      {'User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36'},
      {'Upgrade', 'websocket'}
    ]

    :gun.ws_upgrade(conn_pid, '/', extra_headers)

    # {:ok, _protocol} = :gun.await_up(conn_pid)
    IO.puts('upgrade')
    {:ok, bin} = Base.decode64("G1oAAAAAAAAAAAAAAAAAAd4AAAACAAAATQQFAAUAAABTAAAAAAAAAAAAAAAFAAAAR3Vlc3QEAAAAUGFzc8ZBNgLwmcxEhh/PER79thAFAAAAZW4tVVMIAAAATWFjSW50ZWzkBAAAAAAAAAAAAAAAAAAAAAAAAIAAAABwAAAANS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzE1XzcpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OS4wLjQ4NDQuNTEgU2FmYXJpLzUzNy4zNgAAAAA=")

    :gun.ws_send(conn_pid, {:binary, bin})

    {:ok, Map.put(stack, :pid, conn_pid)}
  end

  def handle_info(data, state) do
    IO.inspect(data)
    {:ok, state}
  end
end
