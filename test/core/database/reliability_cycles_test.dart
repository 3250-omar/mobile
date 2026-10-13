import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/features/settings/data/drift_settings_repository.dart';

void main() {
  group('Reliability & Lifecycle Cycles (100 Iterations)', () {
    test(
      'executes 100 consecutive load, update, and verification cycles',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        final repo = DriftSettingsRepository(db);

        // Verify clean initial singleton
        var settings = await repo.load();
        expect(settings.id, equals(1));
        expect(settings.themeMode, equals('system'));
        expect(settings.revision, equals(0));

        final modes = ['light', 'dark', 'system'];

        for (var i = 1; i <= 100; i++) {
          final targetMode = modes[i % modes.length];
          final updated = await repo.setThemeMode(targetMode);

          expect(updated.themeMode, equals(targetMode));
          expect(updated.revision, equals(i));

          // Direct query verification
          final rawRows = await db.select(db.appSettingsTable).get();
          expect(
            rawRows.length,
            equals(1),
            reason: 'Singleton constraint violated at cycle $i',
          );
          expect(rawRows.first.revision, equals(i));
          expect(rawRows.first.themeMode, equals(targetMode));
        }

        await db.close();
      },
    );
  });
}
