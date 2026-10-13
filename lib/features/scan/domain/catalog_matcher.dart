import 'plumbing_text_parser.dart';
import 'scanned_line_item.dart';

/// Abstract contract for matching parsed OCR requisition items against the local product catalog.
abstract interface class CatalogMatcher {
  /// Matches an individual parsed line against local products in SQLite.
  ///
  /// Guarantees:
  /// - If match score >= 0.85 and unambiguous, marks status as [ScanItemStatus.verified].
  /// - If match score < 0.85 or runner-up score is within 0.10, marks status as [ScanItemStatus.needsReview].
  /// - If no candidate meets minimum threshold (0.40), marks status as [ScanItemStatus.unmatched].
  Future<ScannedLineItem> matchItem({
    required int lineNumber,
    required ParsedRawLine parsedLine,
  });

  /// Batch matches all parsed items against the catalog.
  Future<List<ScannedLineItem>> matchAll(List<ParsedRawLine> parsedLines);
}
