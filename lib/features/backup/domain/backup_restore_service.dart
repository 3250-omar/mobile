/// Pure Dart service contract for backup creation, validation, and restoration.
/// Zero dependencies on Flutter, Drift, or external packages.
library;

import 'backup_result.dart';

abstract class BackupRestoreService {
  /// Exports an atomic, integrity-sealed backup file from the current database.
  /// If [password] is provided, encrypts the database payload.
  Future<BackupResult> createBackup({String? password});

  /// Validates a backup file at [filePath] without modifying active data.
  Future<RestoreValidationResult> validateBackupFile(
    String filePath, {
    String? password,
  });

  /// Safely restores data from [filePath].
  /// Takes an automated safety snapshot and rolls back on failure.
  Future<void> restoreBackup(String filePath, {String? password});

  /// Gets the timestamp of the last successful backup.
  Future<DateTime?> getLastBackupTimestamp();
}
