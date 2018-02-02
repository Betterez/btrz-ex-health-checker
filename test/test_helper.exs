ExUnit.start()

Application.ensure_all_started(:mox)

Mox.defmock(BtrzHealthchecker.EnvironmentInfoMock, for: BtrzHealthchecker.EnvironmentInfoApi)
Mox.defmock(BtrzHealthchecker.MyServiceMock, for: BtrzHealthchecker.Checker)
Mox.defmock(BtrzHealthchecker.MyDatabaseServiceMock, for: BtrzHealthchecker.Checker)

File.mkdir_p(Path.dirname(JUnitFormatter.get_report_file_path()))
ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])