import 'dart:async';
import 'dart:convert';
import 'dart:io';

class BuildRunner {
  Future<void> buildApk() async {
    print('📦 Building APK...');
    print('');

    final process = await Process.start('flutter', [
      'build',
      'apk',
      '--target-platform=android-arm64',
      '--analyze-size',
    ], runInShell: true);

    process.stdout.transform(utf8.decoder).listen((data) => stdout.write(data));

    process.stderr.transform(utf8.decoder).listen((data) => stderr.write(data));

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      throw Exception('Flutter build failed.');
    }

    print('');
    print('✅ Build completed');
  }
}
