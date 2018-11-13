defmodule BtrzHealthchecker.Checkers.RedisTest do
  use ExUnit.Case

  import Mox

  setup :set_mox_from_context

  test "returns 200 if redis server responds ok" do
    BtrzHealthchecker.RedisMock
    |> stub(:start_link, fn _opts -> {:ok, self()} end)
    |> stub(:command!, fn _, _ -> "PONG" end)

    opts = [
      hostname: "test",
      post: 6379
    ]

    assert BtrzHealthchecker.Checkers.Redis.check_status(opts) == 200
  end

  test "returns 500 if Redix.start_link/1 returns error" do
    BtrzHealthchecker.RedisMock
    |> stub(:start_link, fn _opts -> {:error, %{}} end)

    opts = [
      hostname: "test",
      post: 6379
    ]

    assert BtrzHealthchecker.Checkers.Redis.check_status(opts) == 500
  end

  test "returns 500 if Redix.command!/2 with PING raises" do
    BtrzHealthchecker.RedisMock
    |> stub(:start_link, fn _opts -> {:ok, self()} end)
    |> stub(:command!, fn _, _ -> raise RuntimeError end)

    opts = [
      hostname: "test",
      post: 6379
    ]

    assert BtrzHealthchecker.Checkers.Redis.check_status(opts) == 500
  end

  test "returns 500 if Redix.command!/2 with PING does not return 'PONG'" do
    BtrzHealthchecker.RedisMock
    |> stub(:start_link, fn _opts -> {:ok, self()} end)
    |> stub(:command!, fn _, _ -> nil end)

    opts = [
      hostname: "test",
      post: 6379
    ]

    assert BtrzHealthchecker.Checkers.Redis.check_status(opts) == 500
  end
end
