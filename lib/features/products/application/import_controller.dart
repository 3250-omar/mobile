import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../data/excel_importer.dart';
import '../domain/catalog_repository.dart';
import '../domain/import_summary.dart';

/// State of the Excel catalog import workflow.
sealed class ImportState {
  const ImportState();
}

class ImportIdle extends ImportState {
  const ImportIdle();
}

class ImportPickingFile extends ImportState {
  const ImportPickingFile();
}

class ImportParsing extends ImportState {
  const ImportParsing();
}

class ImportPersisting extends ImportState {
  const ImportPersisting({required this.processed, required this.total});
  final int processed;
  final int total;
}

class ImportSuccess extends ImportState {
  const ImportSuccess(this.summary);
  final ImportSummary summary;
}

class ImportFailure extends ImportState {
  const ImportFailure(this.failure);
  final AppFailure failure;
}

/// Controller managing Excel file selection, parsing, and batch persistence.
class ImportController extends StateNotifier<ImportState> {
  ImportController({
    required this.catalogRepository,
    this.excelImporter = const ExcelCatalogImporter(),
  }) : super(const ImportIdle());

  final CatalogRepository catalogRepository;
  final ExcelCatalogImporter excelImporter;

  /// Resets state back to idle.
  void reset() {
    state = const ImportIdle();
  }

  /// Launches the native file picker and imports the selected Excel sheet.
  Future<void> pickAndImportFile() async {
    state = const ImportPickingFile();

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (files.isEmpty) {
        state = const ImportIdle();
        return;
      }

      final file = files.first;
      List<int>? bytes;
      try {
        bytes = await file.readAsBytes();
      } catch (_) {
        if (file.path != null) {
          final ioFile = File(file.path!);
          if (await ioFile.exists()) {
            bytes = await ioFile.readAsBytes();
          }
        }
      }

      if (bytes == null || bytes.isEmpty) {
        state = const ImportFailure(
          AppFailure(
            code: 'FILE_READ_FAILED',
            messageKey: 'error_file_empty_or_unreadable',
            category: AppFailureCategory.validation,
            retryable: true,
          ),
        );
        return;
      }

      await importFromBytes(bytes);
    } catch (e) {
      state = ImportFailure(
        AppFailure(
          code: 'IMPORT_FAILED',
          messageKey: 'error_import_failed',
          category: AppFailureCategory.unexpected,
          retryable: true,
          causeForLogs: e.toString(),
        ),
      );
    }
  }

  /// Processes raw Excel file bytes, parsing in isolate and saving to SQLite.
  Future<void> importFromBytes(List<int> bytes) async {
    state = const ImportParsing();
    final stopwatch = Stopwatch()..start();

    try {
      final parseResult = await excelImporter.parseExcelBytes(bytes);

      if (parseResult.drafts.isEmpty && parseResult.errors.isNotEmpty) {
        stopwatch.stop();
        final summary = ImportSummary(
          totalRows: parseResult.totalDataRows,
          insertedCount: 0,
          updatedCount: 0,
          rejectedCount: parseResult.errors.length,
          errors: parseResult.errors,
          importedAt: DateTime.now().toUtc(),
          durationMs: stopwatch.elapsedMilliseconds,
        );
        state = ImportSuccess(summary);
        return;
      }

      state = ImportPersisting(processed: 0, total: parseResult.drafts.length);

      final upsertResult = await catalogRepository.batchUpsertProducts(
        parseResult.drafts,
      );

      stopwatch.stop();
      final summary = ImportSummary(
        totalRows: parseResult.totalDataRows,
        insertedCount: upsertResult.inserted,
        updatedCount: upsertResult.updated,
        rejectedCount: parseResult.errors.length,
        errors: parseResult.errors,
        importedAt: DateTime.now().toUtc(),
        durationMs: stopwatch.elapsedMilliseconds,
      );

      state = ImportSuccess(summary);
    } catch (e) {
      stopwatch.stop();
      state = ImportFailure(
        AppFailure(
          code: 'IMPORT_DATABASE_FAILED',
          messageKey: 'error_import_db_failed',
          category: AppFailureCategory.storage,
          retryable: true,
          causeForLogs: e.toString(),
        ),
      );
    }
  }
}
