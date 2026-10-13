import 'dart:ui';

import '../diagnostics/app_logger.dart';
import '../../features/settings/domain/settings_repository.dart';

/// Coordinates application lifecycle state transitions (inactive, paused, resumed, detached).
/// Ensures bounded flushing of committed diagnostics/settings buffers and safe reloads.
class AppLifecycleCoordinator {
  AppLifecycleCoordinator({
    required this.logger,
    required this.settingsRepository,
  });

  final AppLogger logger;
  final SettingsRepository settingsRepository;

  AppLifecycleState _lastState = AppLifecycleState.resumed;
  AppLifecycleState get lastState => _lastState;

  Future<void> onLifecycleStateChanged(AppLifecycleState state) async {
    _lastState = state;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        await logger.flush();
        break;
      case AppLifecycleState.resumed:
        await settingsRepository.load();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        await logger.flush();
        break;
    }
  }

  void dispose() {}
}
