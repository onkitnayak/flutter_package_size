import '../entities/package_size.dart';

abstract class AnalyzerRepository {
  Future<List<PackageSize>> analyze();
}