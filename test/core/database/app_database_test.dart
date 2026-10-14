import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/database/migrations/migration_strategy.dart';

void main() {
  group('AppDatabase & Migrations', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('schema version is 5', () {
      expect(db.schemaVersion, 5);
    });

    test(
      'inserts and queries AppSettings row respecting id = 1 singleton',
      () async {
        final now = DateTime.now().toUtc().toIso8601String();
        await db
            .into(db.appSettingsTable)
            .insert(
              AppSettingsCompanion.insert(
                id: const Value(1),
                themeMode: const Value('system'),
                localeTag: const Value('ar'),
                createdAtUtc: now,
                updatedAtUtc: now,
                revision: const Value(0),
              ),
            );

        final row = await (db.select(
          db.appSettingsTable,
        )..where((t) => t.id.equals(1))).getSingle();
        expect(row.id, 1);
        expect(row.themeMode, 'system');
        expect(row.localeTag, 'ar');
        expect(row.revision, 0);
      },
    );

    test('enforces CHECK constraint id = 1', () async {
      final now = DateTime.now().toUtc().toIso8601String();
      expect(
        () async => db
            .into(db.appSettingsTable)
            .insert(
              AppSettingsCompanion.insert(
                id: const Value(2), // Violates CHECK (id = 1)
                themeMode: const Value('system'),
                localeTag: const Value('ar'),
                createdAtUtc: now,
                updatedAtUtc: now,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('enforces CHECK constraint on themeMode', () async {
      final now = DateTime.now().toUtc().toIso8601String();
      expect(
        () async => db
            .into(db.appSettingsTable)
            .insert(
              AppSettingsCompanion.insert(
                id: const Value(1),
                themeMode: const Value(
                  'neon',
                ), // Violates CHECK (theme_mode IN (...))
                localeTag: const Value('ar'),
                createdAtUtc: now,
                updatedAtUtc: now,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('enforces CHECK constraint on localeTag', () async {
      final now = DateTime.now().toUtc().toIso8601String();
      expect(
        () async => db
            .into(db.appSettingsTable)
            .insert(
              AppSettingsCompanion.insert(
                id: const Value(1),
                themeMode: const Value('system'),
                localeTag: const Value(
                  'en',
                ), // Violates CHECK (locale_tag = 'ar')
                createdAtUtc: now,
                updatedAtUtc: now,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('refuses downgrade or newer schema version', () {
      final strategy = buildMigrationStrategy(database: db);
      expect(
        () => strategy.onUpgrade(
          db.createMigrator(),
          2, // from v2
          1, // to v1
        ),
        throwsA(isA<NewerSchemaException>()),
      );
    });
  });
}
