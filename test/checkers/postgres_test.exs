defmodule BtrzHealthchecker.Checkers.PostgresTest do
  use ExUnit.Case

  import Mox

  setup :set_mox_from_context

  test "returns 200 if postgres server responds ok" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn(opts) -> {:ok, self()} end)
    |> stub(:query!, fn(_, _ , _, _) -> {:ok, %{}} end)

    opts = [
      hostname: "test",
      username: "test",
      password: "test",
      database: "test"
    ]

    assert BtrzHealthchecker.Checkers.Postgres.check_status(opts) == 200
  end

  test "returns 500 if Postgrex.start_link/1 returns error" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn(opts) -> {:error, %{}} end)

    opts = [
      hostname: "test",
      username: "test",
      password: "test",
      database: "test"
    ]

    assert BtrzHealthchecker.Checkers.Postgres.check_status(opts) == 500
  end

  test "returns 500 if Postgrex.query!/4 returns error" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn(opts) -> {:ok, self()} end)
    |> stub(:query!, fn(_, _ , _, _) -> {:error, %{}} end)

    opts = [
      hostname: "test",
      username: "test",
      password: "test",
      database: "test"
    ]

    assert BtrzHealthchecker.Checkers.Postgres.check_status(opts) == 500
  end

  test "returns 500 if Postgrex.query!/4 raise an error" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn(opts) -> {:ok, self()} end)
    |> stub(:query!, fn(_, _ , _, _) -> raise RuntimeError end)

    opts = [
      hostname: "test",
      username: "test",
      password: "test",
      database: "test"
    ]

    assert BtrzHealthchecker.Checkers.Postgres.check_status(opts) == 500
  end
end
