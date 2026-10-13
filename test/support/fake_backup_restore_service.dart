import 'package:offline_quotes/features/backup/domain/backup_metadata.dart';
import 'package:offline_quotes/features/backup/domain/backup_result.dart';
import 'package:offline_quotes/features/backup/domain/backup_restore_service.dart';

class FakeBackupRestoreService implements BackupRestoreService {
  FakeBackupRestoreService({
    this.lastBackupTimestamp,
    this.createBackupResult,
    this.validationResult = const RestoreValidationResult(isValid: true),
  });

  DateTime? lastBackupTimestamp;
  BackupResult? createBackupResult;
  RestoreValidationResult validationResult;

  bool createBackupCalled = false;
  bool restoreBackupCalled = false;
  bool validateBackupCalled = false;

  @override
  Future<BackupResult> createBackup({String? password}) async {
    createBackupCalled = true;
    final now = DateTime.now();
    lastBackupTimestamp = now;
    return createBackupResult ??
        BackupResult(
          filePath: '/mock/backups/backup_test.aqb',
          fileSizeBytes: 1024,
          metadata: BackupMetadata(
            schemaVersion: 4,
            createdAt: now,
            checksumSha256: 'mock_checksum',
            isEncrypted: password != null,
            totalProductsCount: 10,
            totalQuotationsCount: 2,
            totalInvoicesCount: 1,
          ),
        );
  }

  @override
  Future<DateTime?> getLastBackupTimestamp() async => lastBackupTimestamp;

  @override
  Future<RestoreValidationResult> validateBackupFile(
    String filePath, {
    String? password,
  }) async {
    validateBackupCalled = true;
    return validationResult;
  }

  @override
  Future<void> restoreBackup(String filePath, {String? password}) async {
    restoreBackupCalled = true;
    if (!validationResult.isValid) {
      throw Exception('Restore validation failed');
    }
  }
}
