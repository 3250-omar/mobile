import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/settings/data/drift_settings_repository.dart';

void main() {
  group('DriftSettingsRepository', () {
    late AppDatabase db;
    late DriftSettingsRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repository = DriftSettingsRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('initial load inserts deterministic defaults atomically', () async {
      final settings = await repository.load();
      expect(settings.id, 1);
      expect(settings.themeMode, 'system');
      expect(settings.localeTag, 'ar');
      expect(settings.revision, 0);

      // Verify row exists in database
      final row = await (db.select(
        db.appSettingsTable,
      )..where((t) => t.id.equals(1))).getSingle();
      expect(row.themeMode, 'system');
      expect(row.revision, 0);
    });

    test(
      'setThemeMode updates theme, increments revision, and updates timestamp',
      () async {
        await repository.load();

        final updated = await repository.setThemeMode('dark');
        expect(updated.themeMode, 'dark');
        expect(updated.revision, 1);

        final secondUpdate = await repository.setThemeMode('light');
        expect(secondUpdate.themeMode, 'light');
        expect(secondUpdate.revision, 2);
      },
    );

    test(
      'rejects invalid theme mode and leaves database state intact',
      () async {
        await repository.load();

        expect(
          () => repository.setThemeMode('invalid_theme'),
          throwsA(isA<AppFailure>()),
        );

        final current = await repository.load();
        expect(current.themeMode, 'system');
        expect(current.revision, 0);
      },
    );

    test('watch emits committed updates', () async {
      final streamEvents = <String>[];
      final subscription = repository.watch().listen((settings) {
        streamEvents.add(settings.themeMode);
      });

      await repository.load();
      await repository.setThemeMode('dark');
      await repository.setThemeMode('light');

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(streamEvents, containsAllInOrder(['system', 'dark', 'light']));

      await subscription.cancel();
    });
  });
}
