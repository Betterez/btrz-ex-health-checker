defmodule BtrzHealthchecker.EnvironmentInfoTest do
  use ExUnit.Case

  alias BtrzHealthchecker.EnvironmentInfo

  test "build_number with no BUILD_NUMBER env is '0'" do
    System.put_env("BUILD_NUMBER", "")
    assert EnvironmentInfo.build_number() == "0"
  end

  test "build_number with BUILD_NUMBER env set is that value" do
    value = "123456"
    System.put_env("BUILD_NUMBER", value)
    assert EnvironmentInfo.build_number() == value
  end
end
