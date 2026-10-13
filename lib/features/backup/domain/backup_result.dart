/// Pure Dart domain entities representing backup and restore validation outcomes.
/// Zero dependencies on Flutter, Drift, or external packages.
library;

import 'backup_metadata.dart';

class BackupResult {
  const BackupResult({
    required this.filePath,
    required this.fileSizeBytes,
    required this.metadata,
  });

  final String filePath;
  final int fileSizeBytes;
  final BackupMetadata metadata;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupResult &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          fileSizeBytes == other.fileSizeBytes &&
          metadata == other.metadata;

  @override
  int get hashCode => Object.hash(filePath, fileSizeBytes, metadata);
}

enum RestoreValidationError {
  fileNotFound('الملف غير موجود'),
  invalidContainerHeader('تنسيق ملف النسخة الاحتياطية غير صالح'),
  unsupportedSchemaVersion('إصدار قاعدة البيانات غير متوافق'),
  checksumMismatch('فشل التحقق من سلامة البيانات (ملف تالف أو معدل)'),
  passwordRequired('الملف محمي بكلمة مرور'),
  invalidPassword('كلمة المرور غير صحيحة'),
  sqliteIntegrityCorrupted('هيكل قاعدة البيانات تالف');

  const RestoreValidationError(this.arabicDescription);
  final String arabicDescription;
}

class RestoreValidationResult {
  const RestoreValidationResult({
    required this.isValid,
    this.metadata,
    this.error,
    this.diagnosticMessage,
  });

  final bool isValid;
  final BackupMetadata? metadata;
  final RestoreValidationError? error;
  final String? diagnosticMessage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestoreValidationResult &&
          runtimeType == other.runtimeType &&
          isValid == other.isValid &&
          metadata == other.metadata &&
          error == other.error &&
          diagnosticMessage == other.diagnosticMessage;

  @override
  int get hashCode => Object.hash(isValid, metadata, error, diagnosticMessage);
}
