/// Enforces privacy-safe diagnostics by redacting sensitive data.
class Redaction {
  const Redaction._();

  static const List<String> prohibitedKeySubstrings = <String>[
    'customer',
    'client',
    'phone',
    'email',
    'token',
    'secret',
    'price',
    'quotation',
    'invoice',
    'item',
    'catalog',
    'ocr',
    'image',
  ];

  /// Filters attributes against privacy-sensitive patterns.
  static Map<String, Object> sanitizeAttributes(Map<String, Object> raw) {
    final sanitized = <String, Object>{};
    for (final entry in raw.entries) {
      final keyLower = entry.key.toLowerCase();
      var prohibited = false;
      for (final forbidden in prohibitedKeySubstrings) {
        if (keyLower.contains(forbidden)) {
          prohibited = true;
          break;
        }
      }
      if (prohibited) {
        sanitized[entry.key] = '[REDACTED]';
      } else {
        final val = entry.value;
        if (val is num || val is bool) {
          sanitized[entry.key] = val;
        } else {
          sanitized[entry.key] = sanitizeString(val.toString());
        }
      }
    }
    return sanitized;
  }

  /// Strips personal home directory or user paths from error strings.
  static String sanitizeString(String input) {
    final pathRegex = RegExp(
      r'([A-Za-z]:\\[^\s,]+|/[A-Za-z0-9_\-\.]+/[^\s,]+)',
    );
    return input.replaceAllMapped(pathRegex, (match) => '[REDACTED_PATH]');
  }
}
