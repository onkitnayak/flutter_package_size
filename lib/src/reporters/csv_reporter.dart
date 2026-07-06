import 'dart:io';
import '../domain/entities/package_size.dart';
import '../utils/size_formatter.dart';

class CsvReporter {
  void generate({
    required List<PackageSize> packages,
    required String outputPath,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('Package,Bytes,Size,Percentage');

    for (final package in packages) {
      buffer.writeln(
        '${package.packageName},'
        '${package.bytes},'
        '${formatSize(package.bytes)},'
        '${package.percentage.toStringAsFixed(2)}',
      );
    }

    final file = File(outputPath);

    file.writeAsStringSync(buffer.toString());

    print('');
    print('✅ CSV report generated');
    print(file.absolute.path);
  }
}
