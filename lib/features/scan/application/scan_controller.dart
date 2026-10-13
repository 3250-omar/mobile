import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

import '../data/image_capture_service.dart';
import '../domain/catalog_matcher.dart';
import '../domain/ocr_scanner.dart';
import '../domain/plumbing_text_parser.dart';
import '../domain/scanned_line_item.dart';
import 'scan_state.dart';

/// StateNotifier orchestrating image acquisition, on-device OCR,
/// Arabic text normalization, catalog fuzzy matching, and human review.
class ScanController extends StateNotifier<ScanState> {
  final ImageCaptureService imageCaptureService;
  final OcrScanner ocrScanner;
  final PlumbingTextParser textParser;
  final CatalogMatcher catalogMatcher;

  ScanController({
    required this.imageCaptureService,
    required this.ocrScanner,
    required this.textParser,
    required this.catalogMatcher,
  }) : super(const ScanState());

  /// Captures an image from camera or gallery and initiates offline OCR.
  Future<void> pickImageAndProcess({bool fromCamera = false}) async {
    state = state.copyWith(status: ScanSessionStatus.capturing);

    try {
      final imagePath = fromCamera
          ? await imageCaptureService.captureImageFromCamera()
          : await imageCaptureService.pickImageFromGallery();

      if (imagePath == null) {
        state = state.copyWith(status: ScanSessionStatus.idle);
        return;
      }

      await processImagePath(imagePath);
    } catch (e) {
      state = state.copyWith(
        status: ScanSessionStatus.idle,
        errorMessage: 'حدث خطأ أثناء التقاط الصورة: $e',
      );
    }
  }

  /// Processes a local image file path through OCR, parsing, and catalog matching.
  Future<void> processImagePath(String imagePath) async {
    state = state.copyWith(
      imagePath: imagePath,
      status: ScanSessionStatus.processingOcr,
      clearErrorMessage: true,
    );

    try {
      // 1. On-device Optical Character Recognition
      final rawLines = await ocrScanner.extractLines(imagePath);

      if (rawLines.isEmpty) {
        state = state.copyWith(
          status: ScanSessionStatus.idle,
          rawLines: const [],
          items: const [],
          errorMessage: 'لم يتم العثور على أي نصوص واضحة في الصورة المحددة.',
        );
        return;
      }

      // 2. Arabic Plumbing Normalization & Token Parsing
      state = state.copyWith(
        status: ScanSessionStatus.matching,
        rawLines: rawLines,
      );
      final parsedLines = textParser.parseAll(rawLines);

      // 3. Local SQLite Catalog Matching & Confidence Scoring
      final matchedItems = await catalogMatcher.matchAll(parsedLines);

      state = state.copyWith(
        status: ScanSessionStatus.review,
        items: matchedItems,
      );
    } catch (e) {
      state = state.copyWith(
        status: ScanSessionStatus.idle,
        errorMessage: 'تعذر إتمام التعرف الضوئي على الصورة: $e',
      );
    }
  }

  /// Updates a line item after user edits (e.g. quantity or price change).
  void updateItem(ScannedLineItem updatedItem) {
    final updatedList = state.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    state = state.copyWith(items: updatedList);
  }

  /// Confirms a catalog candidate match for a specific line item.
  void selectCandidate(String itemId, CatalogCandidateMatch candidate) {
    final updatedList = state.items.map((item) {
      if (item.id != itemId) return item;
      return item.copyWith(
        matchedProduct: candidate,
        isCustom: false,
        reviewStatus: ScanItemStatus.verified,
      );
    }).toList();

    state = state.copyWith(items: updatedList);
  }

  /// Marks an item as custom with optional name and price.
  void setCustomItem(
    String itemId, {
    String? customName,
    int? customPricePiastres,
  }) {
    final updatedList = state.items.map((item) {
      if (item.id != itemId) return item;
      return item.copyWith(
        isCustom: true,
        clearMatchedProduct: true,
        normalizedText: customName ?? item.normalizedText,
        customUnitPricePiastres:
            customPricePiastres ?? item.customUnitPricePiastres,
        reviewStatus: ScanItemStatus.verified,
      );
    }).toList();

    state = state.copyWith(items: updatedList);
  }

  /// Deletes a line item from the review list.
  void deleteItem(String itemId) {
    final updatedList = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedList);
  }

  /// Manually appends a new item to the active review session.
  void addItem(ScannedLineItem newItem) {
    state = state.copyWith(items: [...state.items, newItem]);
  }

  /// Cleans up any cached image file and resets state to idle.
  void reset() {
    final path = state.imagePath;
    if (path != null) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (_) {
        // Discard silently on cleanup
      }
    }
    state = const ScanState();
  }
}
