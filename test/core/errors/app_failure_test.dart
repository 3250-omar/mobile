import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/core/errors/failure_mapper.dart';

void main() {
  group('AppFailure & FailureMapper', () {
    test('maps ArgumentError or config error to CONFIG_INVALID', () {
      final failure = FailureMapper.map(ArgumentError('Missing APP_ENV'));
      expect(failure.code, 'CONFIG_INVALID');
      expect(failure.category, AppFailureCategory.configuration);
      expect(failure.retryable, isFalse);
      expect(failure.messageKey, 'errorConfig');
    });

    test(
      'maps newer schema exception to non-retryable MIGRATION_NEWER_SCHEMA',
      () {
        final failure = FailureMapper.map(
          Exception('NewerSchemaException: database is v2, supported is v1'),
        );
        expect(failure.code, 'MIGRATION_NEWER_SCHEMA');
        expect(failure.category, AppFailureCategory.migration);
        expect(failure.retryable, isFalse);
        expect(failure.messageKey, 'errorNewerSchema');
      },
    );

    test('maps migration failure to retryable MIGRATION_FAILED', () {
      final failure = FailureMapper.map(
        Exception('MigrationFailed during v1 upgrade'),
      );
      expect(failure.code, 'MIGRATION_FAILED');
      expect(failure.category, AppFailureCategory.migration);
      expect(failure.retryable, isTrue);
      expect(failure.messageKey, 'errorMigration');
    });

    test('maps sqlite and database errors to DB_OPEN_FAILED', () {
      final failure = FailureMapper.map(
        Exception('SqliteException: database is locked (code 5)'),
      );
      expect(failure.code, 'DB_OPEN_FAILED');
      expect(failure.category, AppFailureCategory.storage);
      expect(failure.retryable, isTrue);
      expect(failure.messageKey, 'errorDatabase');
    });

    test(
      'maps platform data protection failure to STORAGE_PROTECTION_FAILED',
      () {
        final failure = FailureMapper.map(
          Exception('ProtectionException: failed to apply backup exclusion'),
        );
        expect(failure.code, 'STORAGE_PROTECTION_FAILED');
        expect(failure.category, AppFailureCategory.storage);
        expect(failure.retryable, isTrue);
        expect(failure.messageKey, 'errorStorageProtection');
      },
    );

    test(
      'maps unknown exceptions to UNEXPECTED_ERROR with safe localized key',
      () {
        final failure = FailureMapper.map(
          Exception(
            'Unexpected null pointer at C:\\Users\\secret\\main.dart:42',
          ),
          diagnosticReference: 'ATTEMPT-991',
        );
        expect(failure.code, 'UNEXPECTED_ERROR');
        expect(failure.category, AppFailureCategory.unexpected);
        expect(failure.retryable, isTrue);
        expect(failure.messageKey, 'errorGeneric');
        expect(failure.diagnosticReference, 'ATTEMPT-991');
        // Assert that user-facing message key and code do NOT contain raw sensitive paths
        expect(failure.messageKey, isNot(contains('secret')));
        expect(failure.messageKey, isNot(contains('main.dart')));
      },
    );

    test('retains existing AppFailure code when passed through mapper', () {
      const original = AppFailure(
        code: 'CUSTOM_CODE',
        messageKey: 'customKey',
        category: AppFailureCategory.validation,
        retryable: false,
      );
      final mapped = FailureMapper.map(original, diagnosticReference: 'REF-1');
      expect(mapped.code, 'CUSTOM_CODE');
      expect(mapped.diagnosticReference, 'REF-1');
    });
  });
}
