import 'package:args/command_runner.dart';
import 'package:flutter_package_size/src/data/datasources/analysis_finder.dart';

import '../data/datasources/build_runner.dart';
import '../data/datasources/flutter_cli.dart';
import '../data/datasources/json_parser.dart';
import '../data/datasources/project_detector.dart';
import '../reporters/csv_reporter.dart';
import '../reporters/html_reporter.dart';
import '../reporters/json_reporter.dart';
import '../utils/size_formatter.dart';

class AnalyzeCommand extends Command<void> {
  @override
  final name = 'analyze';

  @override
  final aliases = ['a'];

  @override
  final description = 'Analyze Flutter package sizes.';

  AnalyzeCommand() {
    argParser
      ..addFlag('json', help: 'Generate JSON report.', negatable: false)
      ..addFlag('csv', help: 'Generate CSV report.', negatable: false)
      ..addFlag('html', help: 'Generate HTML report.', negatable: false)
      ..addOption(
        'top',
        help: 'Show top N largest packages.',
        defaultsTo: '10',
        valueHelp: 'number',
      )
      ..addOption(
        'target',
        help: 'Flutter entry point.',
        defaultsTo: 'lib/main.dart',
        valueHelp: 'path',
      )
      ..addOption('flavor', help: 'Flutter build flavor.', valueHelp: 'name')
      ..addMultiOption(
        'dart-define',
        help: 'Pass Dart define values.',
        valueHelp: 'KEY=VALUE',
      );
  }

  @override
  Future<void> run() async {
    final detector = ProjectDetector();

    if (!detector.isFlutterProject()) {
      print('❌ Not a Flutter project.');
      return;
    }

    print('✅ Flutter project detected');

    final flutter = FlutterCli();

    if (!await flutter.isInstalled()) {
      print('❌ Flutter SDK not installed.');
      return;
    }

    print('✅ Flutter SDK found');
    print('');

    final target = argResults!['target'] as String;
    final flavor = argResults!['flavor'] as String?;
    final dartDefines = argResults!['dart-define'] as List<String>;

    final builder = BuildRunner();

    await builder.buildApk(
      target: target,
      flavor: flavor,
      dartDefines: dartDefines,
    );

    final analysisFile = AnalysisFinder().findLatestAnalysisFile();

    if (analysisFile == null || !analysisFile.existsSync()) {
      print('❌ Analysis JSON not found.');
      return;
    }

    print('');
    print('📄 Analysis JSON');
    print(analysisFile.path);
    print('');

    final parser = JsonParser();

    final packages = parser.parse(analysisFile);

    packages.sort((a, b) => b.bytes.compareTo(a.bytes));

    final top = int.parse(argResults!['top'] as String);

    print('${'Package'.padRight(45)}${'Size'.padRight(15)}Percent');
    print('-' * 72);

    for (final package in packages.take(top)) {
      print(
        '${package.packageName.padRight(45)}'
        '${formatSize(package.bytes).padRight(15)}'
        '${package.percentage.toStringAsFixed(2)}%',
      );
    }

    print('');
    print('Summary');
    print('-' * 72);

    final totalPackages = packages.length;

    final totalBytes = packages.fold<int>(
      0,
      (sum, package) => sum + package.bytes,
    );

    final largestPackage = packages.isNotEmpty ? packages.first : null;

    print('Total Packages : $totalPackages');
    print('Total Size     : ${formatSize(totalBytes)}');

    if (largestPackage != null) {
      print(
        'Largest Package: ${largestPackage.packageName} '
        '(${formatSize(largestPackage.bytes)})',
      );
    }

    final json = argResults!['json'] as bool;
    final csv = argResults!['csv'] as bool;
    final html = argResults!['html'] as bool;

    if (json) {
      JsonReporter().generate(
        packages: packages,
        outputPath: 'flutter_package_size_report.json',
      );
    }

    if (csv) {
      CsvReporter().generate(
        packages: packages,
        outputPath: 'flutter_package_size_report.csv',
      );
    }

    if (html) {
      HtmlReporter().generate(
        packages: packages,
        outputPath: 'flutter_package_size_report.html',
      );
    }

    if (json || csv || html) {
      print('');
      print('Generated Reports');
      print('----------------------------------------');

      if (json) {
        print('✓ JSON : flutter_package_size_report.json');
      }

      if (csv) {
        print('✓ CSV  : flutter_package_size_report.csv');
      }

      if (html) {
        print('✓ HTML : flutter_package_size_report.html');
      }
    }
  }
}
