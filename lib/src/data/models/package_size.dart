class PackageSize {
  final String name;
  final int bytes;

  PackageSize({
    required this.name,
    required this.bytes,
  });

  double get kb => bytes / 1024;

  double get mb => bytes / (1024 * 1024);
}