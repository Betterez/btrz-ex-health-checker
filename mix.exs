defmodule BtrzHealthchecker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :btrz_healthchecker,
      version: "0.1.0",
      name: "BtrzHealthchecker",
      description: "Elixir health checker for checking the status of your services",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
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
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:httpoison, "~> 1.0"},
      {:mox, "~> 0.3", only: :test},
      {:postgrex, "~> 0.13.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
