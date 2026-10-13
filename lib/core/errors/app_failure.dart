/// Categories of application failures.
enum AppFailureCategory {
  configuration,
  storage,
  migration,
  validation,
  navigation,
  unexpected,
}

/// Represents an application boundary failure value.
///
/// Guaranteed to contain no raw infrastructure exceptions, SQL queries,
/// raw file paths, or sensitive user data in user-facing fields.
class AppFailure {
  const AppFailure({
    required this.code,
    required this.messageKey,
    required this.category,
    required this.retryable,
    this.diagnosticReference,
    this.causeForLogs,
  });

  /// Stable, non-localized diagnostic and test identifier (e.g., `DB_OPEN_FAILED`).
  final String code;

  /// Localization key for user-facing, safe Arabic message lookup.
  final String messageKey;

  /// High-level failure category.
  final AppFailureCategory category;

  /// Whether an immediate or user-initiated retry is safe and reasonable.
  final bool retryable;

  /// Opaque correlation reference (e.g. attempt ID or short hash) for local logs.
  final String? diagnosticReference;

  /// Sanitized/redacted technical detail recorded exclusively in local log files.
  final String? causeForLogs;

  @override
  String toString() =>
      'AppFailure(code: $code, category: $category, retryable: $retryable, ref: $diagnosticReference)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFailure &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          messageKey == other.messageKey &&
          category == other.category &&
          retryable == other.retryable &&
          diagnosticReference == other.diagnosticReference;

  @override
  int get hashCode =>
      Object.hash(code, messageKey, category, retryable, diagnosticReference);
}
