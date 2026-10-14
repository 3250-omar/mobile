import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'migrations/migration_strategy.dart';
import 'tables/app_settings_table.dart';
import 'tables/business_profile_table.dart';
import 'tables/invoices_table.dart';
import 'tables/products_table.dart';
import 'tables/quotations_table.dart';

part 'app_database.g.dart';

/// Central typed SQLite database managed via Drift.
///
/// Contains foundational infrastructure tables, products catalog, quotations, invoices, and business profile.
@DriftDatabase(
  tables: [
    AppSettingsTable,
    ProductsTable,
    QuotationsTable,
    QuotationItemsTable,
    InvoicesTable,
    InvoiceItemsTable,
    InvoicePaymentsTable,
    BusinessProfilesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? DatabaseConnectionFactory.createConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(database: this);
}
