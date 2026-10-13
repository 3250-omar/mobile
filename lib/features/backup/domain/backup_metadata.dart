/// Pure Dart domain entity representing backup container metadata.
/// Zero dependencies on Flutter, Drift, or external packages.
library;

class BackupMetadata {
  const BackupMetadata({
    required this.schemaVersion,
    required this.createdAt,
    required this.checksumSha256,
    this.isEncrypted = false,
    this.saltBase64,
    this.ivBase64,
    this.totalProductsCount = 0,
    this.totalQuotationsCount = 0,
    this.totalInvoicesCount = 0,
    this.appVersion = '0.1.0',
  });

  final int schemaVersion;
  final DateTime createdAt;
  final String checksumSha256;
  final bool isEncrypted;
  final String? saltBase64;
  final String? ivBase64;
  final int totalProductsCount;
  final int totalQuotationsCount;
  final int totalInvoicesCount;
  final String appVersion;

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'createdAt': createdAt.toIso8601String(),
    'checksumSha256': checksumSha256,
    'isEncrypted': isEncrypted,
    if (saltBase64 != null) 'saltBase64': saltBase64,
    if (ivBase64 != null) 'ivBase64': ivBase64,
    'totalProductsCount': totalProductsCount,
    'totalQuotationsCount': totalQuotationsCount,
    'totalInvoicesCount': totalInvoicesCount,
    'appVersion': appVersion,
  };

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      checksumSha256: json['checksumSha256'] as String? ?? '',
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      saltBase64: json['saltBase64'] as String?,
      ivBase64: json['ivBase64'] as String?,
      totalProductsCount: json['totalProductsCount'] as int? ?? 0,
      totalQuotationsCount: json['totalQuotationsCount'] as int? ?? 0,
      totalInvoicesCount: json['totalInvoicesCount'] as int? ?? 0,
      appVersion: json['appVersion'] as String? ?? '0.1.0',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupMetadata &&
          runtimeType == other.runtimeType &&
          schemaVersion == other.schemaVersion &&
          createdAt == other.createdAt &&
          checksumSha256 == other.checksumSha256 &&
          isEncrypted == other.isEncrypted &&
          saltBase64 == other.saltBase64 &&
          ivBase64 == other.ivBase64 &&
          totalProductsCount == other.totalProductsCount &&
          totalQuotationsCount == other.totalQuotationsCount &&
          totalInvoicesCount == other.totalInvoicesCount &&
          appVersion == other.appVersion;

  @override
  int get hashCode => Object.hash(
    schemaVersion,
    createdAt,
    checksumSha256,
    isEncrypted,
    saltBase64,
    ivBase64,
    totalProductsCount,
    totalQuotationsCount,
    totalInvoicesCount,
    appVersion,
  );
}
