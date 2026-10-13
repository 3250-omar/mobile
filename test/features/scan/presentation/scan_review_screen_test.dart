import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/scan/application/scan_controller.dart';
import 'package:offline_quotes/features/scan/data/fake_ocr_scanner.dart';
import 'package:offline_quotes/features/scan/data/image_capture_service.dart';
import 'package:offline_quotes/features/scan/domain/catalog_matcher.dart';
import 'package:offline_quotes/features/scan/domain/plumbing_line_parser.dart';
import 'package:offline_quotes/features/scan/domain/plumbing_text_parser.dart';
import 'package:offline_quotes/features/scan/domain/scanned_line_item.dart';
import 'package:offline_quotes/features/scan/presentation/scan_review_screen.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

class FakeCapture implements ImageCaptureService {
  @override
  Future<String?> captureImageFromCamera() async => null;
  @override
  Future<String?> pickImageFromGallery() async => null;
}

class FakeMatcher implements CatalogMatcher {
  @override
  Future<ScannedLineItem> matchItem({
    required int lineNumber,
    required ParsedRawLine parsedLine,
  }) async {
    return ScannedLineItem(
      id: 'item-$lineNumber',
      lineNumber: lineNumber,
      rawText: parsedLine.originalText,
      normalizedText: parsedLine.normalizedSearchTerm,
    );
  }

  @override
  Future<List<ScannedLineItem>> matchAll(
    List<ParsedRawLine> parsedLines,
  ) async => [];
}

void main() {
  testWidgets(
    'renders scan review screen with items, metrics, and conversion actions',
    (tester) async {
      const item1 = ScannedLineItem(
        id: 'i1',
        lineNumber: 1,
        rawText: '١٠ كوع ٢٠ مم بولي',
        normalizedText: 'كوع 20 مم بولي',
        extractedQuantity: 10,
        extractedUnit: 'قطعة',
        matchedProduct: CatalogCandidateMatch(
          productId: 1,
          productCode: 'ELB-20',
          productName: 'كوع 20 مم بولي الشريف',
          unitPricePiastres: 1500,
          matchScore: 0.95,
          matchReason: 'تطابق تام',
        ),
        reviewStatus: ScanItemStatus.verified,
      );

      const item2 = ScannedLineItem(
        id: 'i2',
        lineNumber: 2,
        rawText: 'محبس 1/2',
        normalizedText: 'محبس 1/2',
        extractedQuantity: 2,
        extractedUnit: 'قطعة',
        matchedProduct: CatalogCandidateMatch(
          productId: 2,
          productCode: 'VLV-12',
          productName: 'محبس دفن 1/2',
          unitPricePiastres: 12000,
          matchScore: 0.80,
          matchReason: 'تطابق جزئي',
        ),
        reviewStatus: ScanItemStatus.needsReview,
      );

      final controller = ScanController(
        imageCaptureService: FakeCapture(),
        ocrScanner: FakeOcrScanner(),
        textParser: const DefaultPlumbingLineParser(),
        catalogMatcher: FakeMatcher(),
      );
      controller.addItem(item1);
      controller.addItem(item2);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [scanControllerProvider.overrideWith((ref) => controller)],
          child: const MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('ar')],
            home: ScanReviewScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title & Metrics
      expect(find.text('مراجعة الأصناف المستخرجة'), findsOneWidget);
      expect(find.text('إجمالي الأصناف: 2'), findsOneWidget);
      expect(find.text('بحاجة لمراجعة: 1'), findsOneWidget);

      // Verify items
      expect(find.text('كوع 20 مم بولي الشريف'), findsOneWidget);
      expect(find.text('محبس دفن 1/2'), findsOneWidget);
      expect(find.text('بحاجة لمراجعة'), findsWidgets);

      // Verify conversion action buttons
      expect(find.text('إنشاء عرض سعر'), findsOneWidget);
      expect(find.text('إنشاء فاتورة'), findsOneWidget);
    },
  );
}
