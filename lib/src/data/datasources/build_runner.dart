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

    final process = await Process.start('flutter', args, runInShell: true);

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
