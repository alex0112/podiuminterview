defmodule Kgb.MixProject do
  use Mix.Project

  def project do
    [
      app: :kgb,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:exvcr, "~> 0.11.0", only: :test},
      {:floki, "~> 0.23.0"},
    ]
  end
end
