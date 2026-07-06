import 'package:flutter_package_size/flutter_package_size.dart';
import 'package:test/test.dart';

void main() {
  test('FlutterPackageSize can be created', () {
    final app = FlutterPackageSize();

    expect(app, isNotNull);
  });
}