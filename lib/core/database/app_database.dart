import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'migrations/migration_strategy.dart';
import 'tables/app_settings_table.dart';
import 'tables/products_table.dart';

part 'app_database.g.dart';

/// Central typed SQLite database managed via Drift.
///
/// Contains foundational infrastructure tables and the products catalog.
@DriftDatabase(tables: [AppSettingsTable, ProductsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? DatabaseConnectionFactory.createConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(database: this);
}
