# Data Model: Backup & Restore

## Domain Entities

### 1. `BackupMetadata`
Metadata embedded within the backup container header:

```dart
class BackupMetadata {
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
}
```

---

### 2. `BackupResult`
Result of a completed backup generation:

```dart
class BackupResult {
  final String filePath;
  final int fileSizeBytes;
  final BackupMetadata metadata;

  const BackupResult({
    required this.filePath,
    required this.fileSizeBytes,
    required this.metadata,
  });
}
```

---

### 3. `RestoreValidationResult`
Validation result before active database modification:

```dart
enum RestoreValidationError {
  fileNotFound,
  invalidContainerHeader,
  unsupportedSchemaVersion,
  checksumMismatch,
  passwordRequired,
  invalidPassword,
  sqliteIntegrityCorrupted,
}

class RestoreValidationResult {
  final bool isValid;
  final BackupMetadata? metadata;
  final RestoreValidationError? error;
  final String? diagnosticMessage;

  const RestoreValidationResult({
    required this.isValid,
    this.metadata,
    this.error,
    this.diagnosticMessage,
  });
}
```

---

### 4. `BackupRestoreState`
Application state for the presentation screen:

```dart
class BackupRestoreState {
  final bool isBusy;
  final String? currentStage;
  final DateTime? lastBackupAt;
  final AppFailure? failure;
  final String? successMessage;

  const BackupRestoreState({
    this.isBusy = false,
    this.currentStage,
    this.lastBackupAt,
    this.failure,
    this.successMessage,
  });
}
```
