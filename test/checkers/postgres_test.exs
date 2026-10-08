defmodule BtrzHealthchecker.Checkers.PostgresTest do
  use ExUnit.Case

  import Mox

  alias BtrzHealthchecker.Checkers.Postgres

  setup :set_mox_from_context
  setup :verify_on_exit!

  @opts [
    hostname: "test",
    username: "test",
    password: "test",
    database: "test"
  ]

  defp start_fake_connection do
    {:ok, pid} = Agent.start(fn -> nil end)
    pid
  end

  defp stub_start_link(pid) do
    stub(BtrzHealthchecker.PostgresMock, :start_link, fn _opts -> {:ok, pid} end)
  end

  test "name/0 returns postgres" do
    assert Postgres.name() == "postgres"
  end

  test "passes the connection options to Postgrex.start_link/1" do
    pid = start_fake_connection()

    BtrzHealthchecker.PostgresMock
    |> expect(:start_link, fn opts ->
      assert opts == @opts
      {:ok, pid}
    end)
    |> stub(:query!, fn _, _, _, _ -> %Postgrex.Result{} end)

    assert Postgres.check_status(@opts) == 200
  end

  test "returns 200 and runs exactly SELECT 1 if postgres server responds ok" do
    pid = start_fake_connection()
    stub_start_link(pid)

    expect(BtrzHealthchecker.PostgresMock, :query!, fn ^pid, "SELECT 1", [], [] ->
      %Postgrex.Result{}
    end)

    assert Postgres.check_status(@opts) == 200
  end

  test "stops the connection after a successful query" do
    pid = start_fake_connection()
    stub_start_link(pid)
    stub(BtrzHealthchecker.PostgresMock, :query!, fn _, _, _, _ -> %Postgrex.Result{} end)

    assert Postgres.check_status(@opts) == 200
    refute Process.alive?(pid)
  end

  test "returns 500 if Postgrex.start_link/1 returns error" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn _opts -> {:error, %{}} end)
    |> expect(:query!, 0, fn _, _, _, _ -> %Postgrex.Result{} end)

    assert Postgres.check_status(@opts) == 500
  end

  test "returns 500 if Postgrex.start_link/1 returns :ignore" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn _opts -> :ignore end)
    |> expect(:query!, 0, fn _, _, _, _ -> %Postgrex.Result{} end)

    assert Postgres.check_status(@opts) == 500
  end

  test "returns 500 if Postgrex.start_link/1 raises" do
    BtrzHealthchecker.PostgresMock
    |> stub(:start_link, fn _opts -> raise ArgumentError end)
    |> expect(:query!, 0, fn _, _, _, _ -> %Postgrex.Result{} end)

    assert Postgres.check_status(@opts) == 500
  end

  test "returns 500 and stops the connection if Postgrex.query!/4 raises" do
    pid = start_fake_connection()
    stub_start_link(pid)
    stub(BtrzHealthchecker.PostgresMock, :query!, fn _, _, _, _ -> raise RuntimeError end)

    assert Postgres.check_status(@opts) == 500
    refute Process.alive?(pid)
  end

  test "returns 500 and stops the connection if Postgrex.query!/4 exits" do
    pid = start_fake_connection()
    stub_start_link(pid)
    stub(BtrzHealthchecker.PostgresMock, :query!, fn _, _, _, _ -> exit(:timeout) end)

    assert Postgres.check_status(@opts) == 500
    refute Process.alive?(pid)
  end

  test "tolerates a connection that already terminated before cleanup" do
    pid = start_fake_connection()
    stub_start_link(pid)

    stub(BtrzHealthchecker.PostgresMock, :query!, fn conn, _, _, _ ->
      Agent.stop(conn)
      %Postgrex.Result{}
    end)

    assert Postgres.check_status(@opts) == 200
    refute Process.alive?(pid)
  end

  test "tolerates a connection that already terminated when the query raises" do
    pid = start_fake_connection()
    stub_start_link(pid)

    stub(BtrzHealthchecker.PostgresMock, :query!, fn conn, _, _, _ ->
      Agent.stop(conn)
      raise DBConnection.ConnectionError, "connection closed"
    end)

    assert Postgres.check_status(@opts) == 500
  end
end
