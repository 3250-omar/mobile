import 'dart:isolate';
import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../domain/import_summary.dart';
import '../domain/product.dart';

/// Parsed result returned from Excel workbook parsing.
class ExcelParseResult {
  const ExcelParseResult({
    required this.drafts,
    required this.errors,
    required this.totalDataRows,
  });

  final List<ProductDraft> drafts;
  final List<ImportRowError> errors;
  final int totalDataRows;
}

/// Service handling background Excel parsing and exporting for the catalog.
class ExcelCatalogImporter {
  const ExcelCatalogImporter();

  /// Parses Excel bytes inside a background isolate to avoid blocking the UI thread.
  Future<ExcelParseResult> parseExcelBytes(List<int> bytes) async {
    final uint8List = Uint8List.fromList(bytes);
    return Isolate.run(() => _parseExcelSync(uint8List));
  }

  /// Synchronous parser executed inside isolate.
  static ExcelParseResult _parseExcelSync(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) {
      return const ExcelParseResult(
        drafts: [],
        errors: [
          ImportRowError(
            rowNumber: 0,
            reason: 'الملف فارغ أو لا يحتوي على أي صفحات صالحة',
          ),
        ],
        totalDataRows: 0,
      );
    }

    // Pick first table that contains rows
    Sheet? activeSheet;
    for (final table in excel.tables.values) {
      if (table.maxRows > 0) {
        activeSheet = table;
        break;
      }
    }

    if (activeSheet == null || activeSheet.maxRows == 0) {
      return const ExcelParseResult(
        drafts: [],
        errors: [
          ImportRowError(
            rowNumber: 0,
            reason: 'صفحة البيانات لا تحتوي على أية صفوف',
          ),
        ],
        totalDataRows: 0,
      );
    }

    final rows = activeSheet.rows;
    if (rows.isEmpty) {
      return const ExcelParseResult(drafts: [], errors: [], totalDataRows: 0);
    }

    // Detect header row or use default indices
    int headerRowIndex = 0;
    int colCode = 0;
    int colName = 1;
    int colCategory = 2;
    int colUnit = 3;
    int colPrice = 4;
    int? colBarcode;
    int? colNotes;

    // Scan first 5 rows for header keywords
    for (var i = 0; i < rows.length && i < 5; i++) {
      final row = rows[i];
      int matches = 0;
      for (var c = 0; c < row.length; c++) {
        final val = _cellToString(row[c])?.trim().toLowerCase() ?? '';
        if (_isMatch(val, ['باركود', 'الباركود', 'barcode', 'sku'])) {
          colBarcode = c;
        } else if (_isMatch(val, ['سعر', 'السعر', 'price'])) {
          colPrice = c;
          matches++;
        } else if (!val.contains('سعر') &&
            _isMatch(val, ['وحدة', 'الوحدة', 'وحدة القياس', 'unit', 'uom'])) {
          colUnit = c;
          matches++;
        } else if (!val.contains('باركود') &&
            !val.contains('barcode') &&
            _isMatch(val, ['كود', 'الكود', 'رقم الصنف', 'code'])) {
          colCode = c;
          matches++;
        } else if (_isMatch(val, [
          'اسم',
          'الاسم',
          'الوصف',
          'بيان',
          'name',
          'description',
        ])) {
          colName = c;
          matches++;
        } else if (_isMatch(val, [
          'فئة',
          'الفئة',
          'التصنيف',
          'القسم',
          'مجموعة',
          'category',
        ])) {
          colCategory = c;
          matches++;
        } else if (_isMatch(val, ['ملاحظات', 'الملاحظات', 'notes'])) {
          colNotes = c;
        }
      }
      if (matches >= 2) {
        headerRowIndex = i;
        break;
      }
    }

    final drafts = <ProductDraft>[];
    final errors = <ImportRowError>[];
    int totalDataRows = 0;

    for (var r = headerRowIndex + 1; r < rows.length; r++) {
      final row = rows[r];
      if (row.isEmpty) continue;

      // Skip completely empty rows
      final isAllEmpty = row.every(
        (cell) => _cellToString(cell)?.trim().isEmpty ?? true,
      );
      if (isAllEmpty) continue;

      totalDataRows++;
      final rowNumber = r + 1;

      final rawName = _getCellValue(row, colName);
      final rawCode = _getCellValue(row, colCode);
      final rawCategory = _getCellValue(row, colCategory);
      final rawUnit = _getCellValue(row, colUnit);
      final rawPrice = _getCellValue(row, colPrice);
      final rawBarcode = colBarcode != null
          ? _getCellValue(row, colBarcode)
          : null;
      final rawNotes = colNotes != null ? _getCellValue(row, colNotes) : null;

      // Validate name
      if (rawName == null || rawName.trim().isEmpty) {
        errors.add(
          ImportRowError(
            rowNumber: rowNumber,
            rawCode: rawCode,
            rawName: rawName,
            rawPrice: rawPrice,
            reason: 'اسم الصنف مطلوب وغير موجود',
          ),
        );
        continue;
      }

      // Parse price
      final pricePiastres = _parsePriceToPiastres(rawPrice);
      if (pricePiastres == null || pricePiastres < 0) {
        errors.add(
          ImportRowError(
            rowNumber: rowNumber,
            rawCode: rawCode,
            rawName: rawName,
            rawPrice: rawPrice,
            reason: 'السعر غير صالح أو قيمة سالبة: "${rawPrice ?? ''}"',
          ),
        );
        continue;
      }

      // Auto-generate code if missing
      final code = (rawCode != null && rawCode.trim().isNotEmpty)
          ? rawCode.trim()
          : 'GEN-$rowNumber';

      final category = (rawCategory != null && rawCategory.trim().isNotEmpty)
          ? rawCategory.trim()
          : 'عام';

      final unit = (rawUnit != null && rawUnit.trim().isNotEmpty)
          ? rawUnit.trim()
          : 'قطعة';

      drafts.add(
        ProductDraft(
          code: code,
          name: rawName.trim(),
          category: category,
          unit: unit,
          unitPricePiastres: pricePiastres,
          barcode: rawBarcode?.trim().isEmpty ?? true
              ? null
              : rawBarcode?.trim(),
          notes: rawNotes?.trim().isEmpty ?? true ? null : rawNotes?.trim(),
        ),
      );
    }

    return ExcelParseResult(
      drafts: drafts,
      errors: errors,
      totalDataRows: totalDataRows,
    );
  }

  /// Exports a list of products to Excel (.xlsx) file bytes.
  List<int> exportToExcel(List<Product> products) {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    final sheet = excel[defaultSheet];

    // Arabic Header row
    sheet.appendRow([
      TextCellValue('كود الصنف'),
      TextCellValue('اسم الصنف'),
      TextCellValue('الفئة'),
      TextCellValue('الوحدة'),
      TextCellValue('سعر الوحدة (ج.م)'),
      TextCellValue('الباركود'),
      TextCellValue('ملاحظات'),
    ]);

    for (final product in products) {
      sheet.appendRow([
        TextCellValue(product.code),
        TextCellValue(product.name),
        TextCellValue(product.category),
        TextCellValue(product.unit),
        DoubleCellValue(product.unitPricePiastres / 100.0),
        TextCellValue(product.barcode ?? ''),
        TextCellValue(product.notes ?? ''),
      ]);
    }

    final bytes = excel.encode();
    return bytes ?? [];
  }

  static bool _isMatch(String value, List<String> synonyms) {
    for (final syn in synonyms) {
      if (value.contains(syn)) return true;
    }
    return false;
  }

  static String? _getCellValue(List<Data?> row, int index) {
    if (index < 0 || index >= row.length) return null;
    return _cellToString(row[index]);
  }

  static String? _cellToString(Data? cell) {
    if (cell == null) return null;
    final val = cell.value;
    if (val == null) return null;
    if (val is TextCellValue) return val.value.text;
    if (val is IntCellValue) return val.value.toString();
    if (val is DoubleCellValue) return val.value.toString();
    if (val is DateCellValue) return val.asDateTimeLocal().toIso8601String();
    if (val is BoolCellValue) return val.value ? 'true' : 'false';
    return val.toString();
  }

  /// Parses price strings (e.g. "12.50", "12,50", "12.5 EGP", "١٢٫٥٠") to integer piastres.
  static int? _parsePriceToPiastres(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    var cleaned = raw.trim();

    // Eastern Arabic numerals normalization
    cleaned = cleaned
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9')
        .replaceAll('٫', '.')
        .replaceAll(',', '.');

    // Extract the numeric decimal part (handles "ج.م" or "E.G.P." dots)
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(cleaned);
    if (match == null) return null;

    final numberStr = match.group(0)!;
    final parts = numberStr.split('.');
    if (parts.length == 1) {
      final pounds = int.tryParse(parts[0]);
      return pounds != null ? pounds * 100 : null;
    } else {
      final pounds = int.tryParse(parts[0]) ?? 0;
      var piastresStr = parts[1];
      if (piastresStr.length == 1) {
        piastresStr = '${piastresStr}0';
      } else if (piastresStr.length > 2) {
        piastresStr = piastresStr.substring(0, 2);
      }
      final piastres = int.tryParse(piastresStr) ?? 0;
      return (pounds * 100) + piastres;
    }
  }
}
