defmodule BtrzHealthchecker.Checkers.Postgres do
  @moduledoc """
  Defines the Postgres status checker.
  """

  @behaviour BtrzHealthchecker.Checker

  @doc """
  Returns the name of the service

  Returns "postgres".
  """
  def name, do: "postgres"

  @doc """
  Returns the status of the postgres service querying by all the tables of the catalog

  Returns 200.
  Returns 500.

  ## Examples

      iex> BtrzHealthchecker.Checkers.Postgres.check_status(opts)
      200
      iex> BtrzHealthchecker.Checkers.Postgres.check_status(bad_opts)
      500

  """
  def check_status(opts) do
    case Postgrex.start_link(
      hostname: opts[:hostname], 
      username: opts[:username], 
      password: opts[:password], 
      database: opts[:database]) do
      
      {:ok, pid} ->
        case Postgrex.query(pid, "SELECT * FROM pg_catalog.pg_tables", []) do
          {:ok, _} -> 200
          {:error, _reason} -> 500
        end
      {:error, err} -> 500
    end
  end
end