import 'dart:convert';
import 'dart:io';
import '../domain/entities/package_size.dart';

class JsonReporter {
  void generate({
    required List<PackageSize> packages,
    required String outputPath,
  }) {
    final totalBytes = packages.fold<int>(0, (sum, item) => sum + item.bytes);

    final json = {
      'summary': {'totalPackages': packages.length, 'totalBytes': totalBytes},
      'packages': packages
          .map(
            (e) => {
              'package': e.packageName,
              'bytes': e.bytes,
              'percentage': double.parse(e.percentage.toStringAsFixed(2)),
            },
          )
          .toList(),
    };

    final file = File(outputPath);

    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));

    print('');
    print('✅ JSON report generated');
    print(file.absolute.path);
  }
}
