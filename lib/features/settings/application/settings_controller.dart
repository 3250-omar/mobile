import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

/// Controller managing durable settings state with serialized updates and rollback.
class SettingsController extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsController(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  final SettingsRepository _repository;
  StreamSubscription<AppSettings>? _subscription;

  Future<void> _init() async {
    try {
      final initial = await _repository.load();
      state = AsyncValue.data(initial);
      _subscription = _repository.watch().listen(
        (updated) {
          state = AsyncValue.data(updated);
        },
        onError: (Object e, StackTrace st) {
          state = AsyncValue.error(e, st);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Updates theme mode atomically with rollback on failure.
  Future<void> setThemeMode(String mode) async {
    final previous = state;
    try {
      final updated = await _repository.setThemeMode(mode);
      state = AsyncValue.data(updated);
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
