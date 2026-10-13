import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v2 -> v3', () {
    test('upgrades from v2 to v3 creating quotations and quotation_items without data loss', () async {
      // 1. Create a raw SQLite database representing v2
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
      rawDb.execute('PRAGMA user_version = 2;');

      // Insert pre-existing v2 records
      rawDb.execute(
        'INSERT INTO app_settings (id, theme_mode, locale_tag, created_at_utc, updated_at_utc, revision) '
        'VALUES (1, \'light\', \'ar\', \'2026-10-13T10:00:00Z\', \'2026-10-13T10:00:00Z\', 2);',
      );
      rawDb.execute(
        'INSERT INTO products (code, name, category, unit, unit_price_piastres, normalized_search_text, created_at, updated_at) '
        'VALUES (\'VAL-50\', \'محبس 2 بوصة\', \'محابس\', \'قطعة\', 15000, \'محبس 2 بوصه val-50\', 1000, 1000);',
      );

      // 2. Open via AppDatabase, triggering onUpgrade from v2 to v3
      final appDb = AppDatabase(NativeDatabase.opened(rawDb));
      expect(appDb.schemaVersion, equals(3));

      // 3. Verify pre-existing data is completely preserved
      final settings = await (appDb.select(appDb.appSettingsTable)).getSingle();
      expect(settings.themeMode, equals('light'));
      expect(settings.revision, equals(2));

      final product = await (appDb.select(appDb.productsTable)).getSingle();
      expect(product.code, equals('VAL-50'));
      expect(product.unitPricePiastres, equals(15000));

      // 4. Verify quotations and quotation_items can be inserted and queried
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final quotationId = await appDb
          .into(appDb.quotationsTable)
          .insert(
            QuotationCompanion.insert(
              referenceNumber: 'QT-2026-0001',
              customerName: 'مؤسسة الأمل للسباكة',
              customerPhone: const Value('01012345678'),
              issueDate: nowMs,
              subtotalPiastres: const Value(15000),
              discountPiastres: const Value(1000),
              taxPiastres: const Value(0),
              grandTotalPiastres: const Value(14000),
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      expect(quotationId, greaterThan(0));

      final itemId = await appDb
          .into(appDb.quotationItemsTable)
          .insert(
            QuotationItemCompanion.insert(
              quotationId: quotationId,
              productId: Value(product.id),
              productCode: 'VAL-50',
              productName: 'محبس 2 بوصة',
              unit: 'قطعة',
              unitPricePiastres: 15000,
              quantity: 1,
              lineDiscountPiastres: const Value(1000),
              lineTotalPiastres: 14000,
            ),
          );

      expect(itemId, greaterThan(0));

      // 5. Query and verify relationships
      final savedQuotation = await (appDb.select(appDb.quotationsTable))
          .getSingle();
      expect(savedQuotation.referenceNumber, equals('QT-2026-0001'));
      expect(savedQuotation.grandTotalPiastres, equals(14000));

      final savedItem = await (appDb.select(appDb.quotationItemsTable))
          .getSingle();
      expect(savedItem.productName, equals('محبس 2 بوصة'));
      expect(savedItem.lineTotalPiastres, equals(14000));

      // 6. Test Cascade Delete: deleting quotation must delete quotation items
      await (appDb.delete(
        appDb.quotationsTable,
      )..where((t) => t.id.equals(quotationId))).go();
      final remainingItems = await (appDb.select(appDb.quotationItemsTable))
          .get();
      expect(remainingItems, isEmpty);

      // Product must still exist
      final remainingProducts = await (appDb.select(appDb.productsTable)).get();
      expect(remainingProducts.length, equals(1));

      await appDb.close();
    });
  });
}
