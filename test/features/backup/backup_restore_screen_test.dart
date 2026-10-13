import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/backup/application/backup_restore_controller.dart';
import 'package:offline_quotes/features/backup/presentation/backup_restore_screen.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';
import 'package:offline_quotes/features/settings/presentation/settings_screen.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

import '../../support/fake_backup_restore_service.dart';

class _FakeSettingsRepo implements SettingsRepository {
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
  group('BackupRestoreScreen Widget Tests', () {
    late FakeBackupRestoreService fakeService;

    setUp(() {
      fakeService = FakeBackupRestoreService();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          backupRestoreServiceProvider.overrideWithValue(fakeService),
          backupRestoreControllerProvider.overrideWith(
            (ref) => BackupRestoreController(fakeService),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ar'),
          home: BackupRestoreScreen(),
        ),
      );
    }

    testWidgets('renders Backup and Restore cards with Arabic actions', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('النسخ الاحتياطي والاستعادة'), findsOneWidget);
      expect(find.text('النسخ الاحتياطي المحلي'), findsOneWidget);
      expect(find.text('استعادة البيانات'), findsOneWidget);
      expect(find.text('إنشاء نسخة احتياطية الآن'), findsOneWidget);
      expect(find.text('اختيار ملف النسخة الاحتياطية'), findsOneWidget);
    });

    testWidgets(
      'tapping create backup opens password dialog and creates backup',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('إنشاء نسخة احتياطية الآن'));
        await tester.pumpAndSettle();

        // Password prompt dialog is shown
        expect(find.text('حماية النسخة الاحتياطية'), findsOneWidget);
        expect(find.text('تأكيد'), findsOneWidget);

        // Confirm without entering password
        await tester.tap(find.text('تأكيد'));
        await tester.pumpAndSettle();

        expect(fakeService.createBackupCalled, isTrue);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets('SettingsScreen displays backup tile with navigation hint', (
      tester,
    ) async {
      final fakeSettings = _FakeSettingsRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsRepositoryProvider.overrideWithValue(fakeSettings),
            backupRestoreServiceProvider.overrideWithValue(fakeService),
            backupRestoreControllerProvider.overrideWith(
              (ref) => BackupRestoreController(fakeService),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_backup_tile')), findsOneWidget);
      expect(
        find.text('النسخ الاحتياطي والاستعادة'),
        findsNWidgets(2),
      ); // Header + title
      expect(find.text('لم يتم أخذ نسخة احتياطية بعد'), findsOneWidget);
    });
  });
}
