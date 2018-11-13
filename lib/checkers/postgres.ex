defmodule BtrzHealthchecker.Checkers.Postgres do
  @moduledoc """
  Defines the Postgres status checker.
  """

  @behaviour BtrzHealthchecker.Checker
  @postgrex Application.get_env(:btrz_ex_health_checker, :postgrex_api) || Postgrex

  @doc """
  Returns the name of the service

  Returns "postgres".
  """
  def name, do: "postgres"

  @doc """
  Returns the status of the postgres service querying by all the tables of the catalog

  Returns 200 if the conection is reachable and the check query can be executed.
  Returns 500 in case of `Postgrex.Error` or other like `ArgumentError`, `DBConnection.ConnectionError`, `DBConnection.OwnershipError` or `RuntimeError`.

  ## Examples

      iex> BtrzHealthchecker.Checkers.Postgres.check_status(opts)
      200
      iex> BtrzHealthchecker.Checkers.Postgres.check_status(bad_opts)
      500

  """
  def check_status(opts) do
    try do
      {:ok, pid} = @postgrex.start_link(
        hostname: opts[:hostname],
        username: opts[:username],
        password: opts[:password],
        database: opts[:database])
      @postgrex.query!(pid, "SELECT * FROM pg_catalog.pg_tables", [], [])
      200
    rescue
      _error -> 500
    end
  end
end
