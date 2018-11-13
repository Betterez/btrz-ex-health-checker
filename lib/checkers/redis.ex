defmodule BtrzHealthchecker.Checkers.Redis do
  @moduledoc """
  Defines the Redis status checker.
  """

  @behaviour BtrzHealthchecker.Checker
  @redis Application.get_env(:btrz_ex_health_checker, :redis_api) || Redix

  @doc """
  Returns the name of the service

  Returns "redis".
  """
  def name, do: "redis"

  @doc """
  Returns the status of the redis service sending the "PING" command

  Returns 200 if the conection is reachable and the command returns `PONG`.
  Returns 500 if `PONG` is not returned or the `command!` function raises.

  ## Examples

      iex> BtrzHealthchecker.Checkers.Redis.check_status(opts)
      200
      iex> BtrzHealthchecker.Checkers.Redis.check_status(bad_opts)
      500

  """
  def check_status(opts) do
    try do
      {:ok, conn} = @redis.start_link(host: opts[:hostname], port: opts[:port])
      "PONG" = @redis.command!(conn, ["PING"])
      200
    rescue
      _error -> 500
    end
  end
end
