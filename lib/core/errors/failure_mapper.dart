import 'app_failure.dart';

/// Translates raw system, database, and unexpected exceptions into safe, typed [AppFailure]s.
class FailureMapper {
  const FailureMapper();

  /// Maps any caught [error] and optional [stackTrace] into an [AppFailure].
  ///
  /// Guarantees that raw exceptions, SQL statements, and system paths are never leaked
  /// to the UI message key.
  static AppFailure map(
    Object error, {
    StackTrace? stackTrace,
    String? diagnosticReference,
  }) {
    if (error is AppFailure) {
      if (diagnosticReference != null && error.diagnosticReference == null) {
        return AppFailure(
          code: error.code,
          messageKey: error.messageKey,
          category: error.category,
          retryable: error.retryable,
          diagnosticReference: diagnosticReference,
          causeForLogs: error.causeForLogs,
        );
      }
      return error;
    }

    final rawString = error.toString();
    final sanitizedLog = _sanitizeForLogs(rawString);

    if (rawString.contains('NewerSchemaException') ||
        rawString.contains('newer than supported schema')) {
      return AppFailure(
        code: 'MIGRATION_NEWER_SCHEMA',
        messageKey: 'errorNewerSchema',
        category: AppFailureCategory.migration,
        retryable: false,
        diagnosticReference: diagnosticReference,
        causeForLogs: sanitizedLog,
      );
    }

    if (rawString.contains('MigrationFailed') ||
        rawString.contains('sqlite3.SqliteException') &&
            rawString.contains('migration')) {
      return AppFailure(
        code: 'MIGRATION_FAILED',
        messageKey: 'errorMigration',
        category: AppFailureCategory.migration,
        retryable: true,
        diagnosticReference: diagnosticReference,
        causeForLogs: sanitizedLog,
      );
    }

    if (rawString.contains('SqliteException') ||
        rawString.contains('database') ||
        rawString.contains('database is locked') ||
        rawString.contains('busy')) {
      return AppFailure(
        code: 'DB_OPEN_FAILED',
        messageKey: 'errorDatabase',
        category: AppFailureCategory.storage,
        retryable: true,
        diagnosticReference: diagnosticReference,
        causeForLogs: sanitizedLog,
      );
    }

    if (rawString.contains('ProtectionException') ||
        rawString.contains('data protection') ||
        rawString.contains('backup exclusion')) {
      return AppFailure(
        code: 'STORAGE_PROTECTION_FAILED',
        messageKey: 'errorStorageProtection',
        category: AppFailureCategory.storage,
        retryable: true,
        diagnosticReference: diagnosticReference,
        causeForLogs: sanitizedLog,
      );
    }

    if (error is ArgumentError || rawString.contains('APP_ENV')) {
      return AppFailure(
        code: 'CONFIG_INVALID',
        messageKey: 'errorConfig',
        category: AppFailureCategory.configuration,
        retryable: false,
        diagnosticReference: diagnosticReference,
        causeForLogs: sanitizedLog,
      );
    }

    return AppFailure(
      code: 'UNEXPECTED_ERROR',
      messageKey: 'errorGeneric',
      category: AppFailureCategory.unexpected,
      retryable: true,
      diagnosticReference: diagnosticReference,
      causeForLogs: sanitizedLog,
    );
  }

  static String _sanitizeForLogs(String raw) {
    // Redact absolute paths containing user profile names
    final pathRegex = RegExp(r'([A-Za-z]:\\[^\s,]+|/[^\s,]+)');
    return raw.replaceAllMapped(pathRegex, (match) {
      final path = match.group(0) ?? '';
      if (path.contains('app_support') || path.contains('databases')) {
        return '[PROTECTED_APP_PATH]';
      }
      return '[REDACTED_PATH]';
    });
  }
}
