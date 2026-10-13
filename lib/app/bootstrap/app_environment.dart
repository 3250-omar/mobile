/// Application environments defined at compile-time via `--dart-define=APP_ENV=...`.
///
/// Contains strictly no URLs, endpoints, secrets, or remote fallbacks.
/// Every environment maintains 100% offline local behavior.
enum AppEnvironment {
  development,
  testing,
  production;

  static const String dartDefineKey = 'APP_ENV';

  /// Parses a string representation into a closed [AppEnvironment].
  ///
  /// Rejects unknown or empty values explicitly without silent fallbacks.
  static AppEnvironment parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      throw ArgumentError('APP_ENV is missing or empty.');
    }
    switch (raw.trim().toLowerCase()) {
      case 'development':
        return AppEnvironment.development;
      case 'testing':
        return AppEnvironment.testing;
      case 'production':
        return AppEnvironment.production;
      default:
        throw ArgumentError(
          'Unknown APP_ENV: "$raw". Allowed values are "development", "testing", or "production".',
        );
    }
  }

  /// Resolves the compile-time `--dart-define=APP_ENV` value.
  ///
  /// Defaults to [development] when not explicitly passed in development mode.
  static AppEnvironment fromEnvironment() {
    const raw = String.fromEnvironment(
      dartDefineKey,
      defaultValue: 'development',
    );
    return parse(raw);
  }

  bool get isDevelopment => this == AppEnvironment.development;
  bool get isTesting => this == AppEnvironment.testing;
  bool get isProduction => this == AppEnvironment.production;
}
