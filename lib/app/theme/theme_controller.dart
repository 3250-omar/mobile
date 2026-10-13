import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/providers.dart';

/// Provider resolving the active ThemeMode based on committed AppSettings.
final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final settingsAsync = ref.watch(settingsControllerProvider);
  return settingsAsync.when(
    data: (settings) {
      switch (settings.themeMode) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    },
    loading: () => ThemeMode.system,
    error: (_, _) => ThemeMode.system,
  );
});
