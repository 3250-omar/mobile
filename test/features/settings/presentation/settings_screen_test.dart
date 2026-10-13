import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';
import 'package:offline_quotes/features/settings/presentation/settings_screen.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

class FakeSettingsRepo implements SettingsRepository {
  AppSettings current = AppSettings.defaults();

  @override
  Future<AppSettings> load() async => current;

  @override
  Stream<AppSettings> watch() => Stream.value(current);

  @override
  Future<AppSettings> setThemeMode(String mode) async {
    current = current.copyWith(themeMode: mode, revision: current.revision + 1);
    return current;
  }
}

void main() {
  group('SettingsScreen Widget Tests', () {
    testWidgets('renders Arabic theme options and allows selecting dark mode', (
      tester,
    ) async {
      final fakeRepo = FakeSettingsRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [settingsRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المظهر'), findsOneWidget);
      expect(find.text('تلقائي (حسب النظام)'), findsOneWidget);
      expect(find.text('فاتح'), findsOneWidget);
      expect(find.text('داكن'), findsOneWidget);

      await tester.tap(find.byKey(const Key('theme_mode_dark')));
      await tester.pumpAndSettle();

      expect(fakeRepo.current.themeMode, equals('dark'));
    });
  });
}
