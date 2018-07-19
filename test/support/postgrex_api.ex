defmodule BtrzHealthchecker.Support.PostgrexApi do
  @moduledoc false

  @callback start_link(any) :: any
  @callback query!(any, any, any, any) :: any
end
