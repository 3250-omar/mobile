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
      // Foundation schema is v1. Future versions will apply transactional migrations here.
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
