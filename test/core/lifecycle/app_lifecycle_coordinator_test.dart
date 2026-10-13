import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/diagnostics/app_logger.dart';
import 'package:offline_quotes/core/lifecycle/app_lifecycle_coordinator.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';

class MockSettingsRepo implements SettingsRepository {
  int loadCalls = 0;
  AppSettings current = AppSettings.defaults();

  @override
  Future<AppSettings> load() async {
    loadCalls++;
    return current;
  }

  @override
  Stream<AppSettings> watch() => Stream.value(current);

  @override
  Future<AppSettings> setThemeMode(String mode) async => current;
}

void main() {
  group('AppLifecycleCoordinator', () {
    test(
      'transitions through states, flushes on pause, reloads on resume',
      () async {
        final logger = AppLogger();
        final repo = MockSettingsRepo();
        final coordinator = AppLifecycleCoordinator(
          logger: logger,
          settingsRepository: repo,
        );

        // On paused
        await coordinator.onLifecycleStateChanged(AppLifecycleState.paused);
        expect(coordinator.lastState, equals(AppLifecycleState.paused));

        // On resumed -> reloads settings
        await coordinator.onLifecycleStateChanged(AppLifecycleState.resumed);
        expect(coordinator.lastState, equals(AppLifecycleState.resumed));
        expect(repo.loadCalls, equals(1));

        coordinator.dispose();
      },
    );
  });
}
