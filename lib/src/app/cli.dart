import 'package:flutter_package_size/src/app/package_command_runner.dart';

class Cli {
  Future<void> run(List<String> arguments) async {
    final runner = PackageCommandRunner();

    try {
      await runner.run(arguments);
    } catch (e) {
      print(e);
      print('');
      print('Run "flutter_package_size --help" for usage information.');
    }
  }
}
