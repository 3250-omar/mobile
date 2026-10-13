/// Summary record generated after importing an Excel catalog file.
///
/// Pure Dart domain model with zero dependencies on Flutter or Drift.
class ImportSummary {
  const ImportSummary({
    required this.totalRows,
    required this.insertedCount,
    required this.updatedCount,
    required this.rejectedCount,
    required this.errors,
    required this.importedAt,
    required this.durationMs,
  });

  /// Total data rows processed from the workbook.
  final int totalRows;

  /// Count of completely new products added to the database.
  final int insertedCount;

  /// Count of existing products updated by matching product code.
  final int updatedCount;

  /// Count of rows skipped due to missing or invalid data.
  final int rejectedCount;

  /// Detailed list of errors for each rejected row.
  final List<ImportRowError> errors;

  /// UTC timestamp when the import operation concluded.
  final DateTime importedAt;

  /// Total elapsed processing time in milliseconds.
  final int durationMs;

  /// Returns true if all processed rows were either inserted or updated without rejection.
  bool get isCleanSuccess => rejectedCount == 0 && totalRows > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportSummary &&
          runtimeType == other.runtimeType &&
          totalRows == other.totalRows &&
          insertedCount == other.insertedCount &&
          updatedCount == other.updatedCount &&
          rejectedCount == other.rejectedCount &&
          importedAt == other.importedAt &&
          durationMs == other.durationMs;

  @override
  int get hashCode => Object.hash(
    totalRows,
    insertedCount,
    updatedCount,
    rejectedCount,
    importedAt,
    durationMs,
  );

  @override
  String toString() =>
      'ImportSummary(total: $totalRows, inserted: $insertedCount, updated: $updatedCount, rejected: $rejectedCount, time: ${durationMs}ms)';
}

/// Represents a row-level error encountered during Excel workbook parsing.
class ImportRowError {
  const ImportRowError({
    required this.rowNumber,
    this.rawCode,
    this.rawName,
    this.rawPrice,
    required this.reason,
  });

  /// 1-based row number in the source Excel file.
  final int rowNumber;

  /// Raw unparsed value found in the code column (if any).
  final String? rawCode;

  /// Raw unparsed value found in the product name column (if any).
  final String? rawName;

  /// Raw unparsed value found in the price column (if any).
  final String? rawPrice;

  /// Explanatory failure reason.
  final String reason;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportRowError &&
          runtimeType == other.runtimeType &&
          rowNumber == other.rowNumber &&
          rawCode == other.rawCode &&
          rawName == other.rawName &&
          rawPrice == other.rawPrice &&
          reason == other.reason;

  @override
  int get hashCode =>
      Object.hash(rowNumber, rawCode, rawName, rawPrice, reason);

  @override
  String toString() =>
      'ImportRowError(row: $rowNumber, code: $rawCode, name: $rawName, reason: $reason)';
}

/// Result of a batch upsert operation on the repository.
class BatchUpsertResult {
  const BatchUpsertResult({required this.inserted, required this.updated});

  final int inserted;
  final int updated;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchUpsertResult &&
          runtimeType == other.runtimeType &&
          inserted == other.inserted &&
          updated == other.updated;

  @override
  int get hashCode => Object.hash(inserted, updated);

  @override
  String toString() =>
      'BatchUpsertResult(inserted: $inserted, updated: $updated)';
}
