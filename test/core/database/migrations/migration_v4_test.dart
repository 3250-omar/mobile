import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v3 -> v4', () {
    test('upgrades from v3 to v4 creating invoices, invoice_items, and invoice_payments without data loss', () async {
      // 1. Create a raw SQLite database representing v3
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
        'CREATE TABLE quotation_items ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'quotation_id INTEGER NOT NULL REFERENCES quotations(id) ON DELETE CASCADE, '
        'product_id INTEGER REFERENCES products(id) ON DELETE SET NULL, '
        'product_code TEXT NOT NULL, '
        'product_name TEXT NOT NULL, '
        'unit TEXT NOT NULL, '
        'unit_price_piastres INTEGER NOT NULL, '
        'quantity INTEGER NOT NULL, '
        'line_discount_piastres INTEGER NOT NULL DEFAULT 0, '
        'line_total_piastres INTEGER NOT NULL'
        ');',
      );
      rawDb.execute('PRAGMA user_version = 3;');

      // Insert pre-existing v3 records
      rawDb.execute(
        'INSERT INTO app_settings (id, theme_mode, locale_tag, created_at_utc, updated_at_utc, revision) '
        'VALUES (1, \'dark\', \'ar\', \'2026-10-13T10:00:00Z\', \'2026-10-13T10:00:00Z\', 5);',
      );
      rawDb.execute(
        'INSERT INTO products (code, name, category, unit, unit_price_piastres, normalized_search_text, created_at, updated_at) '
        'VALUES (\'VAL-50\', \'محبس 2 بوصة\', \'محابس\', \'قطعة\', 15000, \'محبس 2 بوصه val-50\', 1000, 1000);',
      );
      rawDb.execute(
        'INSERT INTO quotations (id, reference_number, customer_name, customer_phone, status, issue_date, subtotal_piastres, grand_total_piastres, created_at, updated_at) '
        'VALUES (1, \'QT-2026-0001\', \'شركة النيل للتشطيبات\', \'01011112222\', \'accepted\', 2000, 15000, 15000, 2000, 2000);',
      );
      rawDb.execute(
        'INSERT INTO quotation_items (id, quotation_id, product_id, product_code, product_name, unit, unit_price_piastres, quantity, line_total_piastres) '
        'VALUES (1, 1, 1, \'VAL-50\', \'محبس 2 بوصة\', \'قطعة\', 15000, 1, 15000);',
      );

      // 2. Open via AppDatabase, triggering onUpgrade from v3 to v4
      final appDb = AppDatabase(NativeDatabase.opened(rawDb));
      expect(appDb.schemaVersion, equals(4));

      // 3. Verify pre-existing data is preserved
      final settings = await (appDb.select(appDb.appSettingsTable)).getSingle();
      expect(settings.themeMode, equals('dark'));
      expect(settings.revision, equals(5));

      final product = await (appDb.select(appDb.productsTable)).getSingle();
      expect(product.code, equals('VAL-50'));

      final quotation = await (appDb.select(appDb.quotationsTable)).getSingle();
      expect(quotation.referenceNumber, equals('QT-2026-0001'));
      expect(quotation.status, equals('accepted'));

      // 4. Verify invoices, invoice_items, and invoice_payments tables work
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final invoiceId = await appDb
          .into(appDb.invoicesTable)
          .insert(
            InvoiceCompanion.insert(
              referenceNumber: 'INV-2026-0001',
              quotationId: const Value(1),
              customerName: 'شركة النيل للتشطيبات',
              customerPhone: const Value('01011112222'),
              status: const Value('unpaid'),
              issueDate: nowMs,
              subtotalPiastres: const Value(15000),
              discountPiastres: const Value(0),
              taxPiastres: const Value(0),
              grandTotalPiastres: const Value(15000),
              paidAmountPiastres: const Value(0),
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      expect(invoiceId, greaterThan(0));

      final itemId = await appDb
          .into(appDb.invoiceItemsTable)
          .insert(
            InvoiceItemCompanion.insert(
              invoiceId: invoiceId,
              productId: Value(product.id),
              productCode: 'VAL-50',
              productName: 'محبس 2 بوصة',
              unit: 'قطعة',
              unitPricePiastres: 15000,
              quantity: 1,
              lineDiscountPiastres: const Value(0),
              lineTotalPiastres: 15000,
            ),
          );
      expect(itemId, greaterThan(0));

      final paymentId = await appDb
          .into(appDb.invoicePaymentsTable)
          .insert(
            InvoicePaymentCompanion.insert(
              invoiceId: invoiceId,
              amountPiastres: 5000,
              paymentMethod: const Value('cash'),
              paymentDate: nowMs,
              notes: const Value('دفعة أولى'),
              createdAt: nowMs,
            ),
          );
      expect(paymentId, greaterThan(0));

      // 5. Query and verify relations
      final savedInvoice = await (appDb.select(appDb.invoicesTable))
          .getSingle();
      expect(savedInvoice.referenceNumber, equals('INV-2026-0001'));
      expect(savedInvoice.quotationId, equals(1));

      final savedPayments = await (appDb.select(appDb.invoicePaymentsTable))
          .get();
      expect(savedPayments.length, equals(1));
      expect(savedPayments.first.amountPiastres, equals(5000));

      // 6. Test Cascade Delete: deleting invoice deletes items and payments
      await (appDb.delete(
        appDb.invoicesTable,
      )..where((t) => t.id.equals(invoiceId))).go();
      expect(await (appDb.select(appDb.invoiceItemsTable)).get(), isEmpty);
      expect(await (appDb.select(appDb.invoicePaymentsTable)).get(), isEmpty);

      // Quotation and Product must remain intact
      expect(
        (await (appDb.select(appDb.quotationsTable)).get()).length,
        equals(1),
      );
      expect(
        (await (appDb.select(appDb.productsTable)).get()).length,
        equals(1),
      );

      await appDb.close();
    });
  });
}
