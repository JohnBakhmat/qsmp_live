defmodule Qsmplive.MixProject do
  use Mix.Project

  def project do
    [
      app: :qsmplive,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Qsmplive.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 5.0.0"},
      {:bandit, "~> 1.0-pre"},
      {:plug, "~> 1.14"},
      {:httpoison, "~> 2.2.0"},
      {:dotenvy, "~> 0.8.0"}
    ]
  end
end
