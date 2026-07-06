import 'dart:io';
import 'package:path/path.dart' as p;

class ProjectDetector {
  bool isFlutterProject() {
    final pubspec = File(
      p.join(Directory.current.path, 'pubspec.yaml'),
    );

    if (!pubspec.existsSync()) {
      return false;
    }

    final content = pubspec.readAsStringSync();

    return content.contains('flutter:');
  }
}