import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/backup/application/backup_restore_controller.dart';
import 'package:offline_quotes/features/backup/domain/backup_result.dart';

import '../../support/fake_backup_restore_service.dart';

void main() {
  group('BackupRestoreController Tests', () {
    late FakeBackupRestoreService service;
    late BackupRestoreController controller;

    setUp(() {
      service = FakeBackupRestoreService();
      controller = BackupRestoreController(service);
    });

    test('creates backup and updates state with success message', () async {
      expect(controller.state.isBusy, false);

      final result = await controller.createBackup();

      expect(result, isNotNull);
      expect(service.createBackupCalled, true);
      expect(controller.state.isBusy, false);
      expect(controller.state.lastBackupResult, result);
      expect(controller.state.successMessage, isNotNull);
      expect(controller.state.failure, isNull);
    });

    test('validates backup file and updates state', () async {
      final validation = await controller.validateBackupFile('/test/path.aqb');

      expect(validation.isValid, true);
      expect(service.validateBackupCalled, true);
      expect(controller.state.validationResult, validation);
    });

    test('restores backup and updates success state', () async {
      final success = await controller.restoreBackup('/test/path.aqb');

      expect(success, true);
      expect(service.restoreBackupCalled, true);
      expect(controller.state.successMessage, 'تمت استعادة البيانات بنجاح');
    });

    test('handles restore failure gracefully', () async {
      service.validationResult = const RestoreValidationResult(
        isValid: false,
        error: RestoreValidationError.checksumMismatch,
      );

      final success = await controller.restoreBackup('/test/path.aqb');

      expect(success, false);
      expect(controller.state.failure, isNotNull);
    });
  });
}
