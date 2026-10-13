import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_connection.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../domain/backup_result.dart';
import '../domain/backup_restore_service.dart';
import 'backup_container_coder.dart';

/// Default implementation of [BackupRestoreService] with WAL checkpointing,
/// SHA-256 integrity verification, and non-destructive rollback safety.
class DefaultBackupRestoreService implements BackupRestoreService {
  DefaultBackupRestoreService({
    required this.db,
    this.coder = const BackupContainerCoder(),
    this.databasePathResolver = DatabaseConnectionFactory.resolveDatabasePath,
    Future<String> Function()? backupDirectoryResolver,
  }) : backupDirectoryResolver =
           backupDirectoryResolver ?? _defaultBackupDirectoryResolver;

  final AppDatabase db;
  final BackupContainerCoder coder;
  final Future<String> Function() databasePathResolver;
  final Future<String> Function() backupDirectoryResolver;

  static Future<String> _defaultBackupDirectoryResolver() async {
    final appSupport = await getApplicationSupportDirectory();
    final backupDir = Directory(p.join(appSupport.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  static const String _lastBackupMetaFile = 'last_backup.json';

  @override
  Future<BackupResult> createBackup({String? password}) async {
    try {
      // 1. Flush and truncate SQLite WAL log to ensure all committed data is in main file
      await db.customStatement('PRAGMA wal_checkpoint(TRUNCATE);');

      // 2. Fetch record counts for metadata
      final productsCountExp = db.productsTable.id.count();
      final productsRow = await (db.selectOnly(
        db.productsTable,
      )..addColumns([productsCountExp])).getSingle();
      final totalProducts = productsRow.read(productsCountExp) ?? 0;

      final quotationsCountExp = db.quotationsTable.id.count();
      final quotationsRow = await (db.selectOnly(
        db.quotationsTable,
      )..addColumns([quotationsCountExp])).getSingle();
      final totalQuotations = quotationsRow.read(quotationsCountExp) ?? 0;

      final invoicesCountExp = db.invoicesTable.id.count();
      final invoicesRow = await (db.selectOnly(
        db.invoicesTable,
      )..addColumns([invoicesCountExp])).getSingle();
      final totalInvoices = invoicesRow.read(invoicesCountExp) ?? 0;

      // 3. Read active SQLite file bytes
      final dbPath = await databasePathResolver();
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw const AppFailure(
          code: 'BACKUP_DB_FILE_NOT_FOUND',
          messageKey: 'errorDatabase',
          category: AppFailureCategory.storage,
          retryable: false,
        );
      }
      final rawSqliteBytes = await dbFile.readAsBytes();

      // 4. Encode container with SHA-256 and optional password
      final containerBytes = coder.encode(
        sqliteBytes: rawSqliteBytes,
        schemaVersion: db.schemaVersion,
        totalProducts: totalProducts,
        totalQuotations: totalQuotations,
        totalInvoices: totalInvoices,
        password: password,
      );

      // 5. Determine output file path
      final backupDirPath = await backupDirectoryResolver();
      final now = DateTime.now();
      final timestampStr =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      final backupFilePath = p.join(
        backupDirPath,
        'offline_quotes_backup_$timestampStr.aqb',
      );

      final backupFile = File(backupFilePath);
      await backupFile.writeAsBytes(containerBytes, flush: true);

      // 6. Record last backup timestamp
      await _recordLastBackupTimestamp(now);

      final metadata = coder.inspect(containerBytes).metadata!;
      return BackupResult(
        filePath: backupFilePath,
        fileSizeBytes: containerBytes.length,
        metadata: metadata,
      );
    } catch (e, st) {
      if (e is AppFailure) rethrow;
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Future<RestoreValidationResult> validateBackupFile(
    String filePath, {
    String? password,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const RestoreValidationResult(
          isValid: false,
          error: RestoreValidationError.fileNotFound,
          diagnosticMessage: 'File does not exist',
        );
      }

      final bytes = await file.readAsBytes();
      final inspection = coder.inspect(bytes);
      if (!inspection.isValid || inspection.metadata == null) {
        return inspection;
      }

      final meta = inspection.metadata!;
      if (meta.schemaVersion > db.schemaVersion) {
        return RestoreValidationResult(
          isValid: false,
          metadata: meta,
          error: RestoreValidationError.unsupportedSchemaVersion,
          diagnosticMessage: 'Backup is from a newer schema version',
        );
      }

      if (meta.isEncrypted && (password == null || password.isEmpty)) {
        return RestoreValidationResult(
          isValid: false,
          metadata: meta,
          error: RestoreValidationError.passwordRequired,
          diagnosticMessage: 'Password required',
        );
      }

      try {
        coder.decode(bytes, password: password);
      } catch (e) {
        return RestoreValidationResult(
          isValid: false,
          metadata: meta,
          error: meta.isEncrypted
              ? RestoreValidationError.invalidPassword
              : RestoreValidationError.checksumMismatch,
          diagnosticMessage: e.toString(),
        );
      }

      return RestoreValidationResult(isValid: true, metadata: meta);
    } catch (e) {
      return RestoreValidationResult(
        isValid: false,
        error: RestoreValidationError.invalidContainerHeader,
        diagnosticMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> restoreBackup(String filePath, {String? password}) async {
    final validation = await validateBackupFile(filePath, password: password);
    if (!validation.isValid) {
      throw AppFailure(
        code: 'RESTORE_VALIDATION_FAILED',
        messageKey: 'errorGeneric',
        category: AppFailureCategory.validation,
        retryable: false,
        causeForLogs: validation.diagnosticMessage,
      );
    }

    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final rawSqliteBytes = coder.decode(bytes, password: password);

    final dbPath = await databasePathResolver();
    final dbFile = File(dbPath);
    final safetyBackupPath = '$dbPath.pre_restore.bak';
    final safetyBackupFile = File(safetyBackupPath);

    final tempRestorePath = '$dbPath.restoring.tmp';
    final tempRestoreFile = File(tempRestorePath);

    try {
      // 1. Write decoded payload to temp file and test sqlite integrity
      await tempRestoreFile.writeAsBytes(rawSqliteBytes, flush: true);

      final testDb = sqlite3.open(tempRestorePath);
      try {
        final result = testDb.select('PRAGMA integrity_check;');
        if (result.isEmpty || result.first.values.first != 'ok') {
          throw const FormatException('SQLite PRAGMA integrity_check failed');
        }
      } finally {
        testDb.close();
      }

      // 2. Checkpoint active database and create pre-restore safety copy
      await db.customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
      if (await dbFile.exists()) {
        await dbFile.copy(safetyBackupPath);
      }

      // 3. Atomically overwrite active database with validated restored file
      await tempRestoreFile.copy(dbPath);

      // Clean auxiliary WAL files
      final walFile = File('$dbPath-wal');
      final shmFile = File('$dbPath-shm');
      if (await walFile.exists()) await walFile.delete();
      if (await shmFile.exists()) await shmFile.delete();

      // Clean safety snapshot on success
      if (await safetyBackupFile.exists()) {
        await safetyBackupFile.delete();
      }
    } catch (e, st) {
      // Rollback to safety snapshot if available
      if (await safetyBackupFile.exists()) {
        await safetyBackupFile.copy(dbPath);
        await safetyBackupFile.delete();
      }
      throw FailureMapper.map(e, stackTrace: st);
    } finally {
      if (await tempRestoreFile.exists()) {
        await tempRestoreFile.delete();
      }
    }
  }

  @override
  Future<DateTime?> getLastBackupTimestamp() async {
    try {
      final backupDir = await backupDirectoryResolver();
      final metaFile = File(p.join(backupDir, _lastBackupMetaFile));
      if (!await metaFile.exists()) return null;

      final contents = await metaFile.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      final timestampStr = json['lastBackupAt'] as String?;
      return timestampStr != null ? DateTime.parse(timestampStr) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _recordLastBackupTimestamp(DateTime timestamp) async {
    try {
      final backupDir = await backupDirectoryResolver();
      final metaFile = File(p.join(backupDir, _lastBackupMetaFile));
      final json = jsonEncode({'lastBackupAt': timestamp.toIso8601String()});
      await metaFile.writeAsString(json, flush: true);
    } catch (_) {
      // Non-fatal if timestamp file write fails
    }
  }
}
