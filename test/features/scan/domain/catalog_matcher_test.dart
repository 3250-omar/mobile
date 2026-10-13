import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/features/products/data/drift_catalog_repository.dart';
import 'package:offline_quotes/features/scan/data/drift_catalog_matcher.dart';
import 'package:offline_quotes/features/scan/domain/plumbing_text_parser.dart';
import 'package:offline_quotes/features/scan/domain/scanned_line_item.dart';

void main() {
  group('DriftCatalogMatcher', () {
    late AppDatabase db;
    late DriftCatalogRepository catalogRepo;
    late DriftCatalogMatcher matcher;
    int prod1Id = 0;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      catalogRepo = DriftCatalogRepository(db);
      matcher = DriftCatalogMatcher(db);

      // Seed sample plumbing catalog
      final p1 = await catalogRepo.createProduct(
        code: 'ELB-20-PPR',
        name: 'كوع 20 مم بولي الشريف',
        category: 'بولي بروبلين',
        unit: 'قطعة',
        unitPricePiastres: 1500,
      );
      prod1Id = p1.id;

      await catalogRepo.createProduct(
        code: 'VLV-12-BUR',
        name: 'محبس دفن 1/2 بوصة إيطالي',
        category: 'محابس',
        unit: 'قطعة',
        unitPricePiastres: 12000,
      );

      await catalogRepo.createProduct(
        code: 'VLV-12-BAL',
        name: 'محبس بلية 1/2 بوصة فراشة',
        category: 'محابس',
        unit: 'قطعة',
        unitPricePiastres: 9500,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'exact/close match yields verified status with score >= 0.85',
      () async {
        const parsed = ParsedRawLine(
          quantity: 10,
          unit: 'قطعة',
          normalizedSearchTerm: 'كوع 20 مم بولي الشريف',
          originalText: '١٠ كوع ٢٠ مم بولي الشريف',
        );

        final item = await matcher.matchItem(lineNumber: 1, parsedLine: parsed);

        expect(item.reviewStatus, equals(ScanItemStatus.verified));
        expect(item.matchedProduct, isNotNull);
        expect(item.matchedProduct!.productId, equals(prod1Id));
        expect(item.matchedProduct!.matchScore, greaterThanOrEqualTo(0.85));
      },
    );

    test(
      'ambiguous match with close candidates yields needsReview status',
      () async {
        // "محبس 1/2" can match both prod-2 (محبس دفن 1/2) and prod-3 (محبس بلية 1/2)
        const parsed = ParsedRawLine(
          quantity: 2,
          unit: 'قطعة',
          normalizedSearchTerm: 'محبس 1/2 بوصة',
          originalText: 'محبس 1/2 بوصة عدد 2',
        );

        final item = await matcher.matchItem(lineNumber: 2, parsedLine: parsed);

        expect(item.reviewStatus, equals(ScanItemStatus.needsReview));
        expect(item.candidates.length, greaterThanOrEqualTo(2));
      },
    );

    test(
      'unknown item yields unmatched status and defaults to custom item',
      () async {
        const parsed = ParsedRawLine(
          quantity: 1,
          unit: 'قطعة',
          normalizedSearchTerm: 'غسالة ملابس توشيبا',
          originalText: 'غسالة ملابس توشيبا',
        );

        final item = await matcher.matchItem(lineNumber: 3, parsedLine: parsed);

        expect(item.reviewStatus, equals(ScanItemStatus.unmatched));
        expect(item.isCustom, isTrue);
        expect(item.matchedProduct, isNull);
      },
    );
  });
}
