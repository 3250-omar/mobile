# Contract: Catalog Matcher

**Feature**: `005-scan-ocr-handwriting`  
**Layer**: Domain / Data Service  

---

## Interface Definition

```dart
abstract interface class CatalogMatcher {
  /// Matches a parsed line against local SQLite catalog products.
  ///
  /// Returns a [ScannedLineItem] containing:
  /// - The top matched product (if confidence >= 0.85 and unambiguous).
  /// - The list of top candidates (up to 5) sorted by score.
  /// - The assigned [ScanItemStatus] (`verified`, `needsReview`, or `unmatched`).
  Future<ScannedLineItem> matchItem({
    required int lineNumber,
    required ParsedRawLine parsedLine,
  });

  /// Batch matches multiple parsed lines concurrently or sequentially.
  Future<List<ScannedLineItem>> matchAll(List<ParsedRawLine> parsedLines);
}
```

## Guarantees
1. **Confidence Threshold ($0.85$)**: Any match score strictly below `0.85` MUST NOT be marked as `verified`.
2. **Ambiguity Protection**: If the score difference between the top 2 candidates is $< 0.10$, the status MUST be `needsReview` regardless of absolute score.
3. **Transparent Provenance**: Every candidate match includes an explanation (`matchReason`, e.g., `"تطابق تام في نوع الصنف والمقاس"`).
4. **Offline Local SQLite Query**: Operates strictly against the local Drift database.
