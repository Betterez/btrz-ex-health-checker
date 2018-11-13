defmodule BtrzHealthchecker.Checker do
  @moduledoc """
  BtrzHealthchecker.Checker defines the behaviour of a service checker
  """

  @callback check_status(Keyword.t()) :: integer
  @callback name() :: String.t()
end
