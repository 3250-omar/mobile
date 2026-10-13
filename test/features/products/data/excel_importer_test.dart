import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/products/data/excel_importer.dart';
import 'package:offline_quotes/features/products/domain/product.dart';

void main() {
  group('ExcelCatalogImporter', () {
    const importer = ExcelCatalogImporter();

    test(
      'parses valid Excel bytes and maps plumbing items to drafts',
      () async {
        final excel = Excel.createExcel();
        final sheet = excel['Sheet1'];

        // Header row
        sheet.appendRow([
          TextCellValue('كود الصنف'),
          TextCellValue('اسم الصنف'),
          TextCellValue('الفئة'),
          TextCellValue('الوحدة'),
          TextCellValue('سعر الوحدة'),
        ]);

        // Row 1: Normal row
        sheet.appendRow([
          TextCellValue('PPR-ELB-020'),
          TextCellValue('كوع 20 مم زاوية 90'),
          TextCellValue('لوازم بولي'),
          TextCellValue('قطعة'),
          const DoubleCellValue(15.50),
        ]);

        // Row 2: Eastern Arabic digits and missing code
        sheet.appendRow([
          TextCellValue(''),
          TextCellValue('محبس بلية ١ بوصة إيطالي'),
          TextCellValue('محابس'),
          TextCellValue('قطعة'),
          TextCellValue('١٢٠٫٥٠ ج.م'),
        ]);

        // Row 3: Invalid price row
        sheet.appendRow([
          TextCellValue('ERR-01'),
          TextCellValue('صنف معطوب'),
          TextCellValue('عام'),
          TextCellValue('قطعة'),
          TextCellValue('غير معروف'),
        ]);

        final bytes = excel.encode()!;
        final result = await importer.parseExcelBytes(bytes);

        expect(result.totalDataRows, equals(3));
        expect(result.drafts.length, equals(2));
        expect(result.errors.length, equals(1));

        // Check item 1
        final item1 = result.drafts[0];
        expect(item1.code, equals('PPR-ELB-020'));
        expect(item1.name, equals('كوع 20 مم زاوية 90'));
        expect(item1.unitPricePiastres, equals(1550));

        // Check item 2 (auto-generated code, parsed Eastern Arabic price)
        final item2 = result.drafts[1];
        expect(item2.code, startsWith('GEN-'));
        expect(item2.name, equals('محبس بلية ١ بوصة إيطالي'));
        expect(item2.unitPricePiastres, equals(12050));

        // Check error row
        final error = result.errors[0];
        expect(error.rowNumber, equals(4)); // 1 header + 3 data rows -> row 4
        expect(error.rawCode, equals('ERR-01'));
        expect(error.reason, contains('السعر غير صالح'));
      },
    );

    test('exports products to Excel and round-trips correctly', () async {
      final now = DateTime.now().toUtc();
      final products = [
        Product(
          id: 1,
          code: 'VALVE-01',
          name: 'محبس سكينة 2 بوصة',
          category: 'محابس',
          unit: 'قطعة',
          unitPricePiastres: 25000,
          normalizedSearchText: 'محبس سكينه 2 بوصه valve-01 محابس',
          barcode: '12345678',
          notes: 'أصلي',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final bytes = importer.exportToExcel(products);
      expect(bytes, isNotEmpty);

      // Round-trip parse
      final parsed = await importer.parseExcelBytes(bytes);
      expect(parsed.drafts.length, equals(1));
      expect(parsed.drafts[0].code, equals('VALVE-01'));
      expect(parsed.drafts[0].name, equals('محبس سكينة 2 بوصة'));
      expect(parsed.drafts[0].unitPricePiastres, equals(25000));
    });
  });
}
