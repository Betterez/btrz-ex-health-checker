defmodule BtrzHealthchecker.EnvironmentInfoApi do
  @moduledoc """
  Defines the behaviour of EnvironmentInfo
  """

  @callback build_number() :: String.t
  @callback git_revision_hash() :: String.t
  @callback ec2_instance_id() :: String.t
end

defmodule BtrzHealthchecker.EnvironmentInfo do
  @moduledoc """
  Defines the interface to get the environment variables.
  """

  @behaviour BtrzHealthchecker.EnvironmentInfoApi

  def build_number do
    case System.get_env("BUILD_NUMBER") do
      "" -> "0"
      nil -> "0"
      value -> value
    end
  end

  def git_revision_hash do
    {rev, _} = System.cmd("git", ["rev-parse", "HEAD"])
    String.replace(rev, "\n", "")
  end

  def ec2_instance_id do
    case HTTPoison.get("http://169.254.169.254/latest/meta-data/instance-id") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        ""
      {:error, %HTTPoison.Error{reason: _reason}} ->
        "localhost"
    end
  end
end