defmodule BtrzHealthchecker.EnvironmentInfoApi do
  @moduledoc false

  @callback build_number() :: String.t()
  @callback git_revision_hash() :: String.t()
  @callback ec2_instance_id() :: String.t()
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
    token_url = "http://169.254.169.254/latest/api/token"
    instance_id_url = "http://169.254.169.254/latest/meta-data/instance-id"
    token_headers = [{"X-aws-ec2-metadata-token-ttl-seconds", "21600"}]
    opts = [hackney: [pool: false]]

    with {:ok, %HTTPoison.Response{status_code: 200, body: token}} <-
           HTTPoison.put(token_url, "", token_headers, opts),
         instance_id_headers = [{"X-aws-ec2-metadata-token", token}],
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(instance_id_url, instance_id_headers, opts) do
      body
    else
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        ""

      {:error, %HTTPoison.Error{reason: _reason}} ->
        "localhost"
    end
  end
end
