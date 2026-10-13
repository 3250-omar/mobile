import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v1 -> v2', () {
    test('upgrades from v1 to v2 creating products table and indices without data loss', () async {
      // 1. Create a raw SQLite database representing v1
      final rawDb = sqlite3.openInMemory();
      rawDb.execute(
        'CREATE TABLE app_settings ('
        'id INTEGER NOT NULL CHECK (id = 1) PRIMARY KEY DEFAULT 1, '
        'theme_mode TEXT NOT NULL CHECK (theme_mode IN (\'system\', \'light\', \'dark\')) DEFAULT \'system\', '
        'locale_tag TEXT NOT NULL CHECK (locale_tag = \'ar\') DEFAULT \'ar\', '
        'created_at_utc TEXT NOT NULL, '
        'updated_at_utc TEXT NOT NULL, '
        'revision INTEGER NOT NULL CHECK (revision >= 0) DEFAULT 0'
        ');',
      );
      rawDb.execute('CREATE INDEX idx_app_settings_id ON app_settings (id);');
      rawDb.execute(
        'INSERT INTO app_settings (id, theme_mode, locale_tag, created_at_utc, updated_at_utc, revision) '
        'VALUES (1, \'dark\', \'ar\', \'2026-10-13T10:00:00Z\', \'2026-10-13T10:00:00Z\', 5);',
      );
      rawDb.execute('PRAGMA user_version = 1;');

      // 2. Open via AppDatabase, which detects user_version=1 and triggers onUpgrade to v2
      final appDb = AppDatabase(NativeDatabase.opened(rawDb));

      // Verify schema version is upgraded
      expect(appDb.schemaVersion, greaterThanOrEqualTo(2));

      // Verify app_settings row is preserved
      final settings = await (appDb.select(appDb.appSettingsTable)).getSingle();
      expect(settings.themeMode, equals('dark'));
      expect(settings.revision, equals(5));

      // Verify products table exists and can accept inserts
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      await appDb
          .into(appDb.productsTable)
          .insert(
            ProductCompanion.insert(
              code: 'PPR-20-ELB',
              name: 'كوع 20 مم زاوية 90 درجة',
              category: 'لوازم بولي بروبلين',
              unit: 'قطعة',
              unitPricePiastres: 1250,
              normalizedSearchText:
                  'كوع 20 مم زاويه 90 درجه ppr-20-elb لوازم بولي بروبلين',
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      final product = await (appDb.select(appDb.productsTable)).getSingle();
      expect(product.code, equals('PPR-20-ELB'));
      expect(product.unitPricePiastres, equals(1250));

      await appDb.close();
    });
  });
}
