import 'dart:io';

class AnalysisFinder {
  File? findLatestAnalysisFile() {
    final home = Platform.environment['HOME'];

    if (home == null) {
      return null;
    }

    final directory = Directory('$home/.flutter-devtools');

    if (!directory.existsSync()) {
      return null;
    }

    final files = directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.contains('apk-code-size-analysis'))
        .toList();

    if (files.isEmpty) {
      return null;
    }

    files.sort(
      (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );

    return files.first;
  }
}