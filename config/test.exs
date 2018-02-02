use Mix.Config

config :btrz_healthchecker, :environment_info_api, BtrzHealthchecker.EnvironmentInfoMock
config :btrz_healthchecker, :service_api, BtrzHealthchecker.MyServiceMock

config :junit_formatter, report_dir: "/tmp/btrz-ex-health-checker-test-results/exunit"