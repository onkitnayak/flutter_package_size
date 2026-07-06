class CommandRunner {
  void run(List<String> arguments) {
    if (arguments.isEmpty) {
      _help();
      return;
    }

    switch (arguments.first) {
      case 'analyze':
        print('Analyzing project...');
        break;

      case '--version':
        print('0.1.1');
        break;

      case '--help':
      default:
        _help();
    }
  }

  void _help() {
    print('''
Flutter Package Size

Usage:

flutter_package_size analyze

flutter_package_size --help

flutter_package_size --version
''');
  }
}
