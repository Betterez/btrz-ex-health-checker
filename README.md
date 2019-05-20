# BtrzHealthchecker

Health checker gets the information for the desired services passed as Checkers in addition to environment information.

## Documentation
API documentation at HexDocs [https://hexdocs.pm/btrz_ex_health_checker](https://hexdocs.pm/btrz_ex_health_checker)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `btrz_ex_health_checker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:btrz_ex_health_checker, "~> 0.3.0"}]
end
```
## Usage

```elixir
  BtrzHealthchecker.info()
  
  %BtrzHealthchecker.Info{build: "d3b3f9133f68b8877347e06b3d7285dd1d5d3921", commit: "3d7285dd1d5d3921d3b3f9133f68b8877347e06b", 
    instanceId: "i-b3f9133f68b88", services: [], status: 200}
```

## Built-in checkers
This lib ships with some built-in checkers. You can pass one or more of them to the `BtrzHealthchecker.info/1` function.

### Postgres
Uses the `BtrzHealthchecker.Checkers.Postgres` checker module.

```elixir
opts = %{hostname: "localhost", username: "postgres", password: "mypass", database: "mydb"}
checkers = [%{checker_module: BtrzHealthchecker.Checkers.Postgres, opts: opts}]
BtrzHealthchecker.info(checkers)

## %BtrzHealthchecker.Info{build: "d3b3f9133f68b8877347e06b3d7285dd1d5d3921", commit: "3d7285dd1d5d3921d3b3f9133f68b8877347e06b" instanceId: "i-b3f9133f68b88", services: [%{name: "postgres", status: 200}], status: 200}
```

### Redis
Uses the `BtrzHealthchecker.Checkers.Redis` checker module.

```elixir
opts = %{hostname: "localhost", port: 6379}
checkers = [%{checker_module: BtrzHealthchecker.Checkers.Redis, opts: opts}]
BtrzHealthchecker.info(checkers)

## %BtrzHealthchecker.Info{build: "d3b3f9133f68b8877347e06b3d7285dd1d5d3921", commit: "3d7285dd1d5d3921d3b3f9133f68b8877347e06b" instanceId: "i-b3f9133f68b88", services: [%{name: "redis", status: 200}], status: 200}
```

## Create your custom checkers
You can create and pass your own checkers using the `BtrzHealthchecker.Checker` `behavour`, implementing `check_status/1` and `name/0`.

```elixir
defmodule MyApp.CustomChecker do
  @behaviour BtrzHealthchecker.Checker

  def name, do: "my_service"
  
  def check_status(opts) do
    // checking code here...
    200
  end
end
```
