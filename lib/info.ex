defmodule BtrzHealthchecker.Info do
  @moduledoc """
  Defines the BtrzHealthchecker Info struct.
  """

  defstruct status: nil,
    services: [],
    commit: nil,
    instanceId: nil,
    build: nil

  @type t :: %__MODULE__{
    status: Integer.t | nil,
    services: [] | [service_status, ...],
    commit: String.t | nil,
    instanceId: String.t | nil,
    build: String.t | nil
  }

  @typedoc ~S"""
  an individual service status
  """
  @type service_status :: %{name: String.t, status: Integer.t | nil}
end 