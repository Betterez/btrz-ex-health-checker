use Mix.Config

config :btrz_ex_health_checker, :environment_info_api, BtrzHealthchecker.EnvironmentInfoMock
config :btrz_ex_health_checker, :service_api, BtrzHealthchecker.MyServiceMock

config :junit_formatter, report_dir: "/tmp/btrz-ex-health-checker-test-results/exunit"
