import 'package:flutter_package_size/src/app/cli.dart';

// void main(List<String> arguments) {
//   FlutterPackageSize().run(arguments);
// }

Future<void> main(List<String> arguments) async {
  await Cli().run(arguments);
}
