import 'package:args/command_runner.dart';
import 'package:flutter_package_size/flutter_package_size.dart';
import 'package:flutter_package_size/src/core/constants.dart';

import '../commands/analyze_command.dart';
import '../commands/version_command.dart';

class PackageCommandRunner extends CommandRunner<void> {
  PackageCommandRunner()
      : super(
          'flutter_package_size',
          '''
📦 Analyze Flutter package sizes and generate beautiful reports.

Features:
  • Package size breakdown
  • Percentage analysis
  • JSON, CSV & HTML reports
  • GitHub Actions ready

Examples:
  flutter_package_size analyze
  flutter_package_size analyze --top 10
  flutter_package_size analyze --json
  flutter_package_size analyze --csv
  flutter_package_size analyze --html
  flutter_package_size analyze --json --csv --html
  flutter_package_size version
  flutter_package_size --version
''',
        ) {
    addCommand(AnalyzeCommand());
    addCommand(VersionCommand());

    argParser.addFlag(
      'version',
      abbr: 'V',
      negatable: false,
      help: 'Print the package version.',
    );
  }

  @override
  Future<void> run(Iterable<String> args) async {
    final results = parse(args);

    if (results['version'] as bool) {
      print('flutter_package_size $packageVersion');
      return;
    }

    return runCommand(results);
  }
}