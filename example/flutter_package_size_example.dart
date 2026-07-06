import 'package:flutter_package_size/flutter_package_size.dart';
import 'package:flutter_package_size/src/app/cli.dart';

class FlutterPackageSize {
  Future<void> run(List<String> args) async {
    await Cli().run(args);
  }
}