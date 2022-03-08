defmodule ElixirCrawlyChess.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_crawly_chess,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirCrawlyChess.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  # credo để refactor code
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8"}
    ]
  end
end
