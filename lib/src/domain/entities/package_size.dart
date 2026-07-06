class PackageSize {
  final String packageName;
  final int bytes;
  final double percentage;

  const PackageSize({
    required this.packageName,
    required this.bytes,
    this.percentage = 0,
  });

  PackageSize copyWith({
    String? packageName,
    int? bytes,
    double? percentage,
  }) {
    return PackageSize(
      packageName: packageName ?? this.packageName,
      bytes: bytes ?? this.bytes,
      percentage: percentage ?? this.percentage,
    );
  }
}