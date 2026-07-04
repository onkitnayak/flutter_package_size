import '../entities/package_size.dart';
import '../repositories/analyzer_repository.dart';

class AnalyzeProject {
  final AnalyzerRepository repository;

  AnalyzeProject(this.repository);

  Future<List<PackageSize>> call() {
    return repository.analyze();
  }
}