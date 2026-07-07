import 'dart:convert';
import 'dart:io';

import 'package:flutter_package_size/src/domain/entities/package_size.dart';

class JsonParser {
  List<PackageSize> parse(File file) {
    final json = jsonDecode(file.readAsStringSync());

    final Map<String, int> packages = {};

    void traverse(dynamic node, String? currentPackage) {
      if (node is! Map<String, dynamic>) {
        return;
      }

      final name = node['n']?.toString() ?? '';

      // Detect current package
      if (name.startsWith('package:')) {
        currentPackage = _extractPackage(name);
      }

      final children = node['children'];

      // Traverse children first
      if (children is List && children.isNotEmpty) {
        for (final child in children) {
          traverse(child, currentPackage);
        }
      } else {
        // Count only leaf nodes
        final value = (node['value'] as num?)?.toInt() ?? 0;

        if (currentPackage != null && value > 0) {
          packages[currentPackage] = (packages[currentPackage] ?? 0) + value;
        }
      }
    }

    traverse(json, null);

    final totalBytes = packages.values.fold<int>(
      0,
      (sum, value) => sum + value,
    );

    final result = packages.entries.map((entry) {
      final percentage = totalBytes == 0
          ? 0.0
          : (entry.value / totalBytes) * 100;

      return PackageSize(
        packageName: entry.key,
        bytes: entry.value,
        percentage: percentage,
      );
    }).toList();

    result.sort((a, b) => b.bytes.compareTo(a.bytes));

    return result;
  }

  String _extractPackage(String name) {
    final withoutPrefix = name.substring('package:'.length);

    final slashIndex = withoutPrefix.indexOf('/');

    if (slashIndex == -1) {
      return 'package:$withoutPrefix';
    }

    return 'package:${withoutPrefix.substring(0, slashIndex)}';
  }
}
