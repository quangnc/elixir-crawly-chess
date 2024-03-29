defmodule ElixirCrawlyChess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ElixirCrawlyChess.Worker.start_link(arg)
      # {ConnPoolWorker, []}
      { WsClient, ["start"]}
      # { WsGenserver, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    # ElixirCrawlyChess.WSClient.start_link("wss://dbserver.chessbase.com/", )
    opts = [strategy: :one_for_one, name: ElixirCrawlyChess.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
