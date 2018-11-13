defmodule BtrzHealthchecker.Mixfile do
  use Mix.Project

  @github_url "https://github.com/Betterez/btrz_ex_health_checker"
  @version "0.3.0"

  def project do
    [
      app: :btrz_ex_health_checker,
      version: @version,
      name: "BtrzHealthchecker",
      description: "Elixir health checker for checking the status of your services",
      source_url: @github_url,
      homepage_url: @github_url,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:junit_formatter, "~> 2.1", only: :test},
      {:postgrex, "~> 0.13.5"},
      {:redix, ">= 0.0.0"}
    ]
  end

  defp docs do
    [
      main: "BtrzHealthchecker",
      source_ref: "v#{@version}",
      source_url: @github_url
    ]
  end

  defp package do
    %{
      name: "btrz_ex_health_checker",
      licenses: ["MIT"],
      maintainers: ["Hernán García", "Pablo Brudnick"],
      links: %{"GitHub" => @github_url}
    }
  end
end
