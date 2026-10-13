import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'migrations/migration_strategy.dart';
import 'tables/app_settings_table.dart';
import 'tables/products_table.dart';
import 'tables/quotations_table.dart';

part 'app_database.g.dart';

/// Central typed SQLite database managed via Drift.
///
/// Contains foundational infrastructure tables, products catalog, and quotations.
@DriftDatabase(
  tables: [
    AppSettingsTable,
    ProductsTable,
    QuotationsTable,
    QuotationItemsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? DatabaseConnectionFactory.createConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(database: this);
}
