import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/features/backup/data/default_backup_restore_service.dart';
import 'package:offline_quotes/features/backup/domain/backup_result.dart';

void main() {
  group('DefaultBackupRestoreService Tests', () {
    late AppDatabase db;
    late Directory tempDir;
    late File dbFile;
    late DefaultBackupRestoreService service;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('backup_test_');
      final dbPath = '${tempDir.path}/test_db.sqlite';
      dbFile = File(dbPath);

      // Create valid minimal SQLite database file
      final rawDb = NativeDatabase(dbFile);
      db = AppDatabase(rawDb);
      // Touch database to initialize tables
      await db.select(db.appSettingsTable).get();

      final backupsDir = Directory('${tempDir.path}/backups');
      await backupsDir.create();

      service = DefaultBackupRestoreService(
        db: db,
        databasePathResolver: () async => dbPath,
        backupDirectoryResolver: () async => backupsDir.path,
      );
    });

    tearDown(() async {
      await db.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('creates backup file with valid header and metadata', () async {
      final result = await service.createBackup();

      expect(result.filePath, endsWith('.aqb'));
      expect(File(result.filePath).existsSync(), true);
      expect(result.metadata.schemaVersion, db.schemaVersion);
      expect(result.metadata.isEncrypted, false);
      expect(result.fileSizeBytes, greaterThan(0));

      final lastBackup = await service.getLastBackupTimestamp();
      expect(lastBackup, isNotNull);
    });

    test('validates valid backup file successfully', () async {
      final backupResult = await service.createBackup();
      final validation = await service.validateBackupFile(
        backupResult.filePath,
      );

      expect(validation.isValid, true);
      expect(validation.metadata?.schemaVersion, db.schemaVersion);
      expect(validation.error, isNull);
    });

    test('rejects non-existent file path with fileNotFound', () async {
      final validation = await service.validateBackupFile(
        '/non/existent/path.aqb',
      );

      expect(validation.isValid, false);
      expect(validation.error, RestoreValidationError.fileNotFound);
    });

    test('rejects tampered backup file with checksumMismatch', () async {
      final backupResult = await service.createBackup();
      final file = File(backupResult.filePath);
      final bytes = await file.readAsBytes();

      // Tamper last byte
      final tampered = Uint8List.fromList(bytes);
      tampered[tampered.length - 1] ^= 0xAA;
      await file.writeAsBytes(tampered);

      final validation = await service.validateBackupFile(
        backupResult.filePath,
      );
      expect(validation.isValid, false);
      expect(validation.error, RestoreValidationError.checksumMismatch);
    });
  });
}
