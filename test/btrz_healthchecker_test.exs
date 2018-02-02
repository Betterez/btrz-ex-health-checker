defmodule BtrzHealthcheckerTest do
  use ExUnit.Case, async: true
  #doctest BtrzHealthchecker

  import Mox

  setup :verify_on_exit!
  setup :set_mox_global

  @env_data %{build_number: "d3b3f9133f68b8877347e06b3d7285dd1d5d3921", git_hash: "3d7285dd1d5d3921d3b3f9133f68b8877347e06b",
      instance_id: "i-b3f9133f68b88"}
  
  test "returns the Info struct with environment info and no checkers if not passed" do
    BtrzHealthchecker.EnvironmentInfoMock
    |> stub(:build_number, fn -> @env_data["build_number"] end)
    |> stub(:git_revision_hash, fn -> @env_data["git_hash"] end)
    |> stub(:ec2_instance_id, fn -> @env_data["instance_id"] end)

    assert BtrzHealthchecker.info([]) == %BtrzHealthchecker.Info{
      status: 200,
      commit: @env_data["git_hash"],
      instanceId: @env_data["instance_id"],
      build: @env_data["build_number"],
      services: []
    }
  end

  test "returns the Info struct with the service status" do
    BtrzHealthchecker.EnvironmentInfoMock
    |> stub(:build_number, fn -> @env_data["build_number"] end)
    |> stub(:git_revision_hash, fn -> @env_data["git_hash"] end)
    |> stub(:ec2_instance_id, fn -> @env_data["instance_id"] end)

    BtrzHealthchecker.MyServiceMock
    |> stub(:check_status, fn(_) -> 200 end)
    |> stub(:name, fn -> "my_checker" end)

    checkers = [%{checker_module: BtrzHealthchecker.MyServiceMock, opts: %{}}]

    assert BtrzHealthchecker.info(checkers) == %BtrzHealthchecker.Info{
      status: 200,
      commit: @env_data["git_hash"],
      instanceId: @env_data["instance_id"],
      build: @env_data["build_number"],
      services: [%{name: "my_checker" , status: 200}]
    }
  end

  test "returns the Info struct with the list of services status"  do
    BtrzHealthchecker.EnvironmentInfoMock
    |> stub(:build_number, fn -> @env_data["build_number"] end)
    |> stub(:git_revision_hash, fn -> @env_data["git_hash"] end)
    |> stub(:ec2_instance_id, fn -> @env_data["instance_id"] end)

    BtrzHealthchecker.MyServiceMock
    |> stub(:check_status, fn(_) -> 200 end)
    |> stub(:name, fn -> "my_checker" end)

    BtrzHealthchecker.MyDatabaseServiceMock
    |> stub(:check_status, fn(_) -> 500 end)
    |> stub(:name, fn -> "my_db_checker" end)

    checkers = [
      %{checker_module: BtrzHealthchecker.MyServiceMock, opts: %{}},
      %{checker_module: BtrzHealthchecker.MyDatabaseServiceMock, opts: %{}},
    ]

    assert BtrzHealthchecker.info(checkers) == %BtrzHealthchecker.Info{
      status: 200,
      commit: @env_data["git_hash"],
      instanceId: @env_data["instance_id"],
      build: @env_data["build_number"],
      services: [%{name: "my_checker" , status: 200}, %{name: "my_db_checker" , status: 500}]
    }
  end
end