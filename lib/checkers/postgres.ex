defmodule BtrzHealthchecker.Checkers.Postgres do
  @moduledoc """
  Defines the Postgres status checker.
  """

  @behaviour BtrzHealthchecker.Checker
  @postgres Application.get_env(:btrz_ex_health_checker, :postgres_api) || Postgrex

  @doc """
  Returns the name of the service

  Returns "postgres".
  """
  def name, do: "postgres"

  @doc """
  Returns the status of the postgres service running `SELECT 1` on a temporary connection.

  The temporary connection is always stopped after the check, whether the query succeeds,
  raises or exits.

  Returns 200 if the conection is reachable and the check query can be executed.
  Returns 500 if the connection can't be started or in case of `Postgrex.Error` or other like `ArgumentError`, `DBConnection.ConnectionError`, `DBConnection.OwnershipError`, `RuntimeError` or an exit.

  ## Examples

      iex> BtrzHealthchecker.Checkers.Postgres.check_status(opts)
      200
      iex> BtrzHealthchecker.Checkers.Postgres.check_status(bad_opts)
      500

  """
  def check_status(opts) do
    opts
    |> start_connection()
    |> run_check()
  end

  defp start_connection(opts) do
    @postgres.start_link(
      hostname: opts[:hostname],
      username: opts[:username],
      password: opts[:password],
      database: opts[:database]
    )
  rescue
    error -> {:error, error}
  catch
    :exit, reason -> {:error, reason}
  end

  defp run_check({:ok, pid}) do
    @postgres.query!(pid, "SELECT 1", [], [])
    200
  rescue
    _error -> 500
  catch
    :exit, _reason -> 500
  after
    stop_connection(pid)
  end

  defp run_check(_start_error) do
    500
  end

  defp stop_connection(pid) do
    GenServer.stop(pid)
  catch
    :exit, _reason -> :ok
  end
end
