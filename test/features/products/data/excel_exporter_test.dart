import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/products/data/excel_importer.dart';
import 'package:offline_quotes/features/products/domain/product.dart';

void main() {
  group('ExcelCatalogImporter - Export and Round-trip Tests', () {
    const importer = ExcelCatalogImporter();

    test('exports products list to valid Excel bytes and supports round-trip parsing', () async {
      final sampleProducts = [
        Product(
          id: 1,
          code: 'VAL-01',
          name: 'محبس بلية 1/2 بوصة إيطالي',
          category: 'محابس ولوازمها',
          unit: 'قطعة',
          unitPricePiastres: 6500, // 65.00 EGP
          normalizedSearchText: 'محبس بلية 1/2 بوصة إيطالي VAL-01',
          barcode: '6221234567890',
          notes: 'نحاس أصلي ثقيل',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        Product(
          id: 2,
          code: 'PIP-20',
          name: 'ماسورة بولي 20 مم ضغط 20',
          category: 'مواسير بولي',
          unit: 'متر',
          unitPricePiastres: 2550, // 25.50 EGP
          normalizedSearchText: 'ماسورة بولي 20 مم ضغط 20 PIP-20',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];

      // 1. Export
      final bytes = importer.exportToExcel(sampleProducts);
      expect(bytes, isNotEmpty);

      // 2. Import back
      final parseResult = await importer.parseExcelBytes(bytes);

      expect(parseResult.errors, isEmpty);
      expect(parseResult.drafts.length, 2);

      // Verify Product 1
      final p1 = parseResult.drafts.firstWhere((d) => d.code == 'VAL-01');
      expect(p1.name, 'محبس بلية 1/2 بوصة إيطالي');
      expect(p1.category, 'محابس ولوازمها');
      expect(p1.unit, 'قطعة');
      expect(p1.unitPricePiastres, 6500);
      expect(p1.barcode, '6221234567890');
      expect(p1.notes, 'نحاس أصلي ثقيل');

      // Verify Product 2
      final p2 = parseResult.drafts.firstWhere((d) => d.code == 'PIP-20');
      expect(p2.name, 'ماسورة بولي 20 مم ضغط 20');
      expect(p2.category, 'مواسير بولي');
      expect(p2.unit, 'متر');
      expect(p2.unitPricePiastres, 2550);
    });

    test('exports empty product list without error', () {
      final bytes = importer.exportToExcel([]);
      expect(bytes, isNotEmpty);
    });
  });
}
