import 'command_runner.dart';

class Cli {
  void run(List<String> arguments) {
    CommandRunner().run(arguments);
  }
}