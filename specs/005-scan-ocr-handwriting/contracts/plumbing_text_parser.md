# Contract: Plumbing Text Normalizer & Parser

**Feature**: `005-scan-ocr-handwriting`  
**Layer**: Domain Service  

---

## Interface Definition

```dart
class ParsedRawLine {
  final double quantity;
  final String unit;
  final String normalizedSearchTerm;
  final String originalText;

  const ParsedRawLine({
    required this.quantity,
    required this.unit,
    required this.normalizedSearchTerm,
    required this.originalText,
  });
}

abstract interface class PlumbingTextParser {
  /// Normalizes Arabic text, converting Eastern numerals to ASCII,
  /// vulgar fractions to standard fractions, and dialect abbreviations
  /// to canonical plumbing terms.
  String normalizeText(String rawText);

  /// Parses an individual line into quantity, unit, and product search keywords.
  ParsedRawLine parseLine(String lineText);

  /// Batch parses a list of OCR extracted lines, filtering out noise or empty lines.
  List<ParsedRawLine> parseAll(List<String> rawLines);
}
```

## Guarantees
1. **Eastern Arabic Numerals**: `١٢٣٤٥٦٧٨٩٠` are always normalized to `1234567890`.
2. **Fractional Glyphs**: `½`, `¾`, `¼`, `1½` are normalized to standard textual fractions (`1/2`, `3/4`, `1/4`, `1 1/2`).
3. **Colloquial Terms**: Common Egyptian plumbing terms (e.g. `كوع`, `محبس`, `تيز`, `جلبة`, `نيبل`, `بولي`, `شريف`) are recognized and mapped to canonical tokens for search.
4. **Safety Defaults**: If no quantity is specified (e.g. `"محبس بلية 1/2"`), quantity defaults to `1.0` and unit defaults to `"قطعة"`.
