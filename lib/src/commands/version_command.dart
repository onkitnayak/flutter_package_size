import 'package:args/command_runner.dart';

import '../core/constants.dart';

class VersionCommand extends Command<void> {
  @override
  final name = 'version';

  @override
  final description = 'Print package version.';

  @override
  Future<void> run() async {
    print(packageVersion);
  }
}