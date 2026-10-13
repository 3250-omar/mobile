import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/settings/application/settings_controller.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  AppSettings current = AppSettings.defaults();
  final _controller = StreamController<AppSettings>.broadcast();
  bool shouldFailOnSet = false;

  @override
  Future<AppSettings> load() async => current;

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<AppSettings> setThemeMode(String mode) async {
    if (shouldFailOnSet) {
      throw const AppFailure(
        code: 'STORAGE_WRITE_FAILED',
        messageKey: 'errorDatabase',
        category: AppFailureCategory.storage,
        retryable: true,
      );
    }
    current = current.copyWith(themeMode: mode, revision: current.revision + 1);
    _controller.add(current);
    return current;
  }
}

void main() {
  group('SettingsController', () {
    test('loads initial settings and updates state', () async {
      final repo = MockSettingsRepository();
      final controller = SettingsController(repo);

      await Future<void>.delayed(Duration.zero);

      expect(controller.state.value?.themeMode, equals('system'));
      expect(controller.state.value?.revision, equals(0));
    });

    test('updates theme mode atomically and publishes new revision', () async {
      final repo = MockSettingsRepository();
      final controller = SettingsController(repo);

      await Future<void>.delayed(Duration.zero);

      await controller.setThemeMode('dark');

      expect(controller.state.value?.themeMode, equals('dark'));
      expect(controller.state.value?.revision, equals(1));
    });

    test('rolls back previous state when setThemeMode fails', () async {
      final repo = MockSettingsRepository();
      final controller = SettingsController(repo);

      await Future<void>.delayed(Duration.zero);

      repo.shouldFailOnSet = true;

      expect(
        () => controller.setThemeMode('light'),
        throwsA(isA<AppFailure>()),
      );

      expect(controller.state.value?.themeMode, equals('system'));
    });
  });
}
