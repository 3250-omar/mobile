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
import 'package:offline_quotes/features/scan/presentation/scan_screen.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

class TestCapture implements ImageCaptureService {
  @override
  Future<String?> captureImageFromCamera() async => '/test/camera.jpg';

  @override
  Future<String?> pickImageFromGallery() async => '/test/gallery.jpg';
}

class TestMatcher implements CatalogMatcher {
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
      reviewStatus: ScanItemStatus.verified,
    );
  }

  @override
  Future<List<ScannedLineItem>> matchAll(
    List<ParsedRawLine> parsedLines,
  ) async {
    return parsedLines
        .map(
          (p) => ScannedLineItem(
            id: 'item-${p.originalText}',
            lineNumber: 1,
            rawText: p.originalText,
            normalizedText: p.normalizedSearchTerm,
            reviewStatus: ScanItemStatus.verified,
          ),
        )
        .toList();
  }
}

void main() {
  testWidgets(
    'renders ScanScreen with offline badge, capture buttons, and starts recognition',
    (tester) async {
      final controller = ScanController(
        imageCaptureService: TestCapture(),
        ocrScanner: FakeOcrScanner(),
        textParser: const DefaultPlumbingLineParser(),
        catalogMatcher: TestMatcher(),
      );

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
            home: ScanScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title & Badges
      expect(find.text('المسح الضوئي وخط اليد'), findsOneWidget);
      expect(
        find.text('التعرف الضوئي يعمل بالكامل على جهازك (100% بدون إنترنت)'),
        findsOneWidget,
      );

      // Verify Action Buttons
      expect(find.text('اختيار من المعرض'), findsOneWidget);
      expect(find.text('التقاط صورة'), findsOneWidget);

      // Tap Pick from Gallery
      await tester.tap(find.text('اختيار من المعرض'));
      await tester.pumpAndSettle();

      // Verify recognition produces items
      expect(controller.state.items.isNotEmpty, isTrue);
      expect(controller.state.status, equals(ScanSessionStatus.review));
    },
  );
}
