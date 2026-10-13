# Contract: Backup & Restore Service

The `BackupRestoreService` interface manages local backup export, integrity verification, and safe rollback-enabled restoration.

## Interface Definition

```dart
abstract class BackupRestoreService {
  /// Exports an atomic, integrity-sealed backup file to local cache/storage.
  /// If [password] is provided, the SQLite payload is encrypted.
  Future<BackupResult> createBackup({String? password});

  /// Validates a backup file from [filePath] without modifying current database.
  Future<RestoreValidationResult> validateBackupFile(
    String filePath, {
    String? password,
  });

  /// Safely restores data from [filePath].
  /// Creates an automatic `.pre_restore.bak` snapshot and rolls back on failure.
  Future<void> restoreBackup(String filePath, {String? password});

  /// Gets the timestamp of the last successful backup.
  Future<DateTime?> getLastBackupTimestamp();
}
```

## Guarantees

1. **Non-Destructive**: In any failure scenario (checksum mismatch, wrong password, corrupted SQLite payload, power loss), the active database is preserved or automatically restored from safety snapshot.
2. **Deterministic Checksum**: SHA-256 verifies the payload byte-for-byte.
3. **100% Offline**: All file handling, encryption, and hashing run exclusively on-device.
