import 'package:drift/drift.dart';

/// Exception thrown when opening a database created by a newer application version.
class NewerSchemaException implements Exception {
  const NewerSchemaException(this.databaseVersion, this.supportedVersion);

  final int databaseVersion;
  final int supportedVersion;

  @override
  String toString() =>
      'NewerSchemaException: Database schema version ($databaseVersion) is newer than supported ($supportedVersion). Downgrade is rejected.';
}

/// Builds migration strategy enforcing forward-only schema transitions and integrity pragmas.
MigrationStrategy buildMigrationStrategy({
  required GeneratedDatabase database,
}) {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from > to) {
        throw NewerSchemaException(from, to);
      }
      if (from < 2) {
        // Migrate schema from v1 to v2: create products table and associated indices.
        for (final entity in database.allSchemaEntities) {
          if (entity is TableInfo && entity.actualTableName == 'products') {
            await m.createTable(entity);
          } else if (entity is Index &&
              entity.entityName.startsWith('idx_products_')) {
            await m.createIndex(entity);
          }
        }
      }
      if (from < 3) {
        // Migrate schema from v2 to v3: create quotations and quotation_items tables and indices.
        for (final entity in database.allSchemaEntities) {
          if (entity is TableInfo &&
              (entity.actualTableName == 'quotations' ||
                  entity.actualTableName == 'quotation_items')) {
            await m.createTable(entity);
          } else if (entity is Index &&
              (entity.entityName.startsWith('idx_quotations_') ||
                  entity.entityName.startsWith('idx_quotation_items_'))) {
            await m.createIndex(entity);
          }
        }
      }
      if (from < 4) {
        // Migrate schema from v3 to v4: create invoices, invoice_items, and invoice_payments tables and indices.
        for (final entity in database.allSchemaEntities) {
          if (entity is TableInfo &&
              (entity.actualTableName == 'invoices' ||
                  entity.actualTableName == 'invoice_items' ||
                  entity.actualTableName == 'invoice_payments')) {
            await m.createTable(entity);
          } else if (entity is Index &&
              (entity.entityName.startsWith('idx_invoices_') ||
                  entity.entityName.startsWith('idx_invoice_items_') ||
                  entity.entityName.startsWith('idx_invoice_payments_'))) {
            await m.createIndex(entity);
          }
        }
      }
    },
    beforeOpen: (OpeningDetails details) async {
      if (details.versionBefore != null &&
          details.versionBefore! > database.schemaVersion) {
        throw NewerSchemaException(
          details.versionBefore!,
          database.schemaVersion,
        );
      }

      // Enforce SQLite integrity pragmas
      await database.customStatement('PRAGMA foreign_keys = ON;');
      await database.customStatement('PRAGMA busy_timeout = 5000;');
    },
  );
}
