defmodule BtrzHealthchecker.Support.RedisApi do
  @moduledoc false

  @callback start_link(any) :: any
  @callback command!(any, any) :: any
end
