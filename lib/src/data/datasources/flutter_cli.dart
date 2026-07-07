import 'dart:io';

class FlutterCli {
  Future<bool> isInstalled() async {
    final result = await Process.run('flutter', ['--version']);

    return result.exitCode == 0;
  }
}
