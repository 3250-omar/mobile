import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/backup/data/default_backup_restore_service.dart';

void main() {
  group('Restore Safety & Non-Destructive Rollback Tests', () {
    late AppDatabase db;
    late Directory tempDir;
    late String dbPath;
    late DefaultBackupRestoreService service;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('restore_safety_test_');
      dbPath = '${tempDir.path}/test_db.sqlite';
      final backupsDir = Directory('${tempDir.path}/backups');
      await backupsDir.create();

      final rawDb = NativeDatabase(File(dbPath));
      db = AppDatabase(rawDb);

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

    test(
      'preserves existing data when restore is rejected due to corruption',
      () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        // 1. Insert original product
        await db
            .into(db.productsTable)
            .insert(
              ProductCompanion.insert(
                code: 'EXISTING-01',
                name: 'صنف أصلي محمي',
                category: 'مواسير',
                unit: 'متر',
                unitPricePiastres: 1000,
                normalizedSearchText: 'صنف اصلي محمي',
                createdAt: now,
                updatedAt: now,
              ),
            );

        // Verify original product is present
        var products = await db.select(db.productsTable).get();
        expect(products.length, 1);
        expect(products.first.code, 'EXISTING-01');

        // 2. Create a corrupted backup file
        final badFilePath = '${tempDir.path}/corrupted.aqb';
        await File(badFilePath).writeAsBytes(
          Uint8List.fromList([
            0x41,
            0x51,
            0x42,
            0x31,
            0x00,
            0x00,
            0x00,
            0x05,
            0x7B,
            0x7D,
            0xFF,
            0xFE,
          ]),
        );

        // 3. Attempt to restore corrupted file -> expect failure
        expect(
          () => service.restoreBackup(badFilePath),
          throwsA(isA<AppFailure>()),
        );

        // 4. Verify original product is STILL intact (zero data loss)
        products = await db.select(db.productsTable).get();
        expect(products.length, 1);
        expect(products.first.code, 'EXISTING-01');
      },
    );
  });
}
