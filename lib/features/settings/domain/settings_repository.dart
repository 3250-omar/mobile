import 'app_settings.dart';

/// Contract for persistent foundational application settings.
///
/// Guaranteed to be 100% offline, local, and transactional.
abstract class SettingsRepository {
  /// Loads the persisted singleton [AppSettings].
  ///
  /// Atomically inserts deterministic defaults on first successful use if absent.
  Future<AppSettings> load();

  /// Emits committed [AppSettings] updates.
  Stream<AppSettings> watch();

  /// Persists a new theme mode atomically, incrementing revision and updating timestamp.
  ///
  /// Mode must be one of: `system`, `light`, `dark`.
  Future<AppSettings> setThemeMode(String mode);
}
