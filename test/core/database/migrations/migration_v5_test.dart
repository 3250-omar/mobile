import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v4 -> v5', () {
    test(
      'upgrades from v4 to v5 creating business_profiles table without data loss',
      () async {
        // 1. Create raw SQLite database at v4
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
        rawDb.execute(
          'CREATE TABLE products ('
          'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
          'code TEXT NOT NULL UNIQUE, '
          'name TEXT NOT NULL, '
          'category TEXT NOT NULL, '
          'unit TEXT NOT NULL, '
          'unit_price_piastres INTEGER NOT NULL CHECK (unit_price_piastres >= 0), '
          'normalized_search_text TEXT NOT NULL, '
          'barcode TEXT, '
          'notes TEXT, '
          'created_at INTEGER NOT NULL, '
          'updated_at INTEGER NOT NULL'
          ');',
        );
        rawDb.execute(
          'CREATE TABLE quotations ('
          'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
          'reference_number TEXT NOT NULL UNIQUE, '
          'customer_name TEXT NOT NULL, '
          'customer_phone TEXT, '
          'status TEXT NOT NULL DEFAULT \'draft\', '
          'issue_date INTEGER NOT NULL, '
          'expiry_date INTEGER, '
          'notes TEXT, '
          'subtotal_piastres INTEGER NOT NULL DEFAULT 0, '
          'discount_piastres INTEGER NOT NULL DEFAULT 0, '
          'tax_piastres INTEGER NOT NULL DEFAULT 0, '
          'grand_total_piastres INTEGER NOT NULL DEFAULT 0, '
          'created_at INTEGER NOT NULL, '
          'updated_at INTEGER NOT NULL'
          ');',
        );
        rawDb.execute(
          'CREATE TABLE invoices ('
          'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
          'reference_number TEXT NOT NULL UNIQUE, '
          'quotation_id INTEGER REFERENCES quotations(id) ON DELETE SET NULL, '
          'customer_name TEXT NOT NULL, '
          'customer_phone TEXT, '
          'status TEXT NOT NULL DEFAULT \'unpaid\', '
          'issue_date INTEGER NOT NULL, '
          'due_date INTEGER, '
          'notes TEXT, '
          'subtotal_piastres INTEGER NOT NULL DEFAULT 0, '
          'discount_piastres INTEGER NOT NULL DEFAULT 0, '
          'tax_piastres INTEGER NOT NULL DEFAULT 0, '
          'grand_total_piastres INTEGER NOT NULL DEFAULT 0, '
          'paid_amount_piastres INTEGER NOT NULL DEFAULT 0, '
          'created_at INTEGER NOT NULL, '
          'updated_at INTEGER NOT NULL'
          ');',
        );
        rawDb.execute('PRAGMA user_version = 4;');

        // Insert pre-existing v4 data
        rawDb.execute(
          'INSERT INTO app_settings (id, theme_mode, locale_tag, created_at_utc, updated_at_utc, revision) '
          'VALUES (1, \'dark\', \'ar\', \'2026-10-13T10:00:00Z\', \'2026-10-13T10:00:00Z\', 7);',
        );

        // 2. Open via AppDatabase, triggering onUpgrade from v4 to v5
        final appDb = AppDatabase(NativeDatabase.opened(rawDb));
        expect(appDb.schemaVersion, equals(5));

        // 3. Verify pre-existing data preserved
        final settings =
            await (appDb.select(appDb.appSettingsTable)).getSingle();
        expect(settings.themeMode, equals('dark'));
        expect(settings.revision, equals(7));

        // 4. Verify business_profiles table is created and queryable
        final profile =
            await (appDb.select(appDb.businessProfilesTable))
                .getSingleOrNull();
        expect(profile, isNull);

        // Can insert business profile
        await appDb
            .into(appDb.businessProfilesTable)
            .insert(
              BusinessProfileCompanion.insert(
                businessName: 'مؤسسة الاختبار',
                phonePrimary: '01012345678',
                updatedAtUtc: DateTime.now().toUtc().toIso8601String(),
              ),
            );

        final inserted =
            await (appDb.select(appDb.businessProfilesTable)).getSingle();
        expect(inserted.id, equals(1));
        expect(inserted.businessName, equals('مؤسسة الاختبار'));

        await appDb.close();
      },
    );
  });
}
