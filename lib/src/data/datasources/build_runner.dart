import 'dart:async';
import 'dart:convert';
import 'dart:io';

class BuildRunner {
  Future<void> buildApk({
    required String target,
    String? flavor,
    List<String> dartDefines = const [],
  }) async {
    print('📦 Building APK...');
    print('');

    final args = <String>[
      'build',
      'apk',
      '--release',
      '--target-platform=android-arm64',
      '--analyze-size',
      '--target',
      target,
    ];

    if (flavor != null && flavor.isNotEmpty) {
      args.addAll(['--flavor', flavor]);
    }

    for (final define in dartDefines) {
      args.add('--dart-define=$define');
    }

    final flutterPath = (await Process.run('which', [
      'flutter',
    ])).stdout.toString().trim();

    print('Flutter path: $flutterPath');
    print('Running command:');
    print('$flutterPath ${args.join(' ')}');
    print('Working directory: ${Directory.current.path}');
    print('');

    final process = await Process.start('flutter', args);

    process.stdout.transform(utf8.decoder).listen(stdout.write);

    process.stderr.transform(utf8.decoder).listen(stderr.write);

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      throw Exception('Flutter build failed.');
    }

    print('');
    print('✅ Build completed');
  }
}
