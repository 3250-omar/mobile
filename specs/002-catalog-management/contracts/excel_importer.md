# Contract: ExcelCatalogImporter

**Feature**: [002-catalog-management](../spec.md)

## Interface Definition

```dart
abstract interface class ExcelCatalogImporter {
  /// Parses Excel file bytes in a background isolate and returns parsed drafts and row errors.
  Future<ExcelParseResult> parseExcelBytes(List<int> bytes);

  /// Executes end-to-end import from file path, handling isolate parsing and batch repository upserts.
  /// Notifies [onProgress] with (processedRows, totalRows).
  Future<ImportSummary> importFromFile(
    String filePath, {
    void Function(int processed, int total)? onProgress,
  });

  /// Exports current catalog products into a well-formed .xlsx file byte stream.
  Future<List<int>> exportToExcel(List<Product> products);
}
```

## Error Codes
- `EXCEL_FILE_EMPTY`: Workbook has no sheets or zero rows.
- `EXCEL_FORMAT_INVALID`: File corrupted or not a valid Excel document.
- `EXCEL_PARSE_FAILED`: Background isolate crashed during workbook extraction.
