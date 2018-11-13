defmodule BtrzHealthchecker do
  @moduledoc """
  BtrzHealthchecker main module.

  Used to get the information about the desired services passed as Checkers.
  """
  alias BtrzHealthchecker.{Info, EnvironmentInfo}

  @environment_info_api Application.get_env(:btrz_ex_health_checker, :environment_info_api) ||
                          EnvironmentInfo

  @typedoc """
  A checker that implements the Checker behaviour
  """
  @type checker :: BtrzHealthchecker.Checker

  @doc """
  Returns the Info struct with the status of the desired services.

  ## Examples
      iex> my_connection_opts = %{hostname: "localhost", username: "postgres", password: "mypass", database: "mydb"}
      iex> BtrzHealthchecker.info([%{checker_module: BtrzHealthchecker.Checkers.Postgres, opts: my_connection_opts}])
      %BtrzHealthchecker.Info{build: "d3b3f9133f68b8877347e06b3d7285dd1d5d3921", commit: "3d7285dd1d5d3921d3b3f9133f68b8877347e06b",
            instanceId: "i-b3f9133f68b88", services: [%{name: "postgres", status: 200}], status: 200}

      Or without any service
      iex> BtrzHealthchecker.info()
      %BtrzHealthchecker.Info{build: "d3b3f9133f68b8877347e06b3d7285dd1d5d3921", commit: "3d7285dd1d5d3921d3b3f9133f68b8877347e06b",
            instanceId: "i-b3f9133f68b88", services: [], status: 200}

  """
  @spec info() :: %Info{}
  def info() do
    %Info{} =
      set_environment_info()
      |> Map.put(:status, 200)
  end

  @spec info([checker]) :: %Info{}
  def info(checkers) when is_list(checkers) do
    services_status =
      checkers
      |> Enum.map(fn checker_item ->
        Task.async(fn ->
          %{
            name: checker_item.checker_module.name,
            status: checker_item.checker_module.check_status(checker_item.opts)
          }
        end)
      end)
      |> Enum.map(&Task.await/1)

    %Info{} =
      set_environment_info()
      |> Map.put(:status, 200)
      |> Map.put(:services, services_status)
  end

  defp set_environment_info do
    %Info{
      commit: @environment_info_api.git_revision_hash(),
      instanceId: @environment_info_api.ec2_instance_id(),
      build: @environment_info_api.build_number()
    }
  end
end
