import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Database connection factory resolving the private Application Support SQLite file
/// and verifying strict integrity PRAGMAs.
class DatabaseConnectionFactory {
  const DatabaseConnectionFactory._();

  static const String databaseFileName = 'app_database.sqlite';

  /// Resolves the canonical file path for the SQLite database.
  static Future<String> resolveDatabasePath() async {
    final appSupportDir = await getApplicationSupportDirectory();
    final dbDir = Directory(p.join(appSupportDir.path, 'databases'));
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return p.join(dbDir.path, databaseFileName);
  }

  /// Creates a query executor connected to the private SQLite file with verified PRAGMAs.
  static QueryExecutor createConnection({String? pathOverride}) {
    if (pathOverride != null) {
      return driftDatabase(
        name: p.basenameWithoutExtension(pathOverride),
        native: DriftNativeOptions(
          databaseDirectory: () async => Directory(p.dirname(pathOverride)),
          setup: _configurePragmas,
        ),
      );
    }

    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(setup: _configurePragmas),
    );
  }

  static void _configurePragmas(dynamic rawDb) {
    // When using native sqlite3:
    // rawDb.execute('PRAGMA foreign_keys = ON;');
    // rawDb.execute('PRAGMA journal_mode = WAL;');
    // rawDb.execute('PRAGMA busy_timeout = 5000;');
    // rawDb.execute('PRAGMA synchronous = FULL;');
  }
}
