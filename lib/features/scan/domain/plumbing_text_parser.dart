/// Pure Dart: zero dependencies on Flutter, Drift, or external packages.
library;

/// Structured outcome of parsing an individual OCR text line.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedRawLine &&
          runtimeType == other.runtimeType &&
          quantity == other.quantity &&
          unit == other.unit &&
          normalizedSearchTerm == other.normalizedSearchTerm &&
          originalText == other.originalText;

  @override
  int get hashCode =>
      Object.hash(quantity, unit, normalizedSearchTerm, originalText);
}

/// Abstract contract for normalizing and parsing Arabic plumbing slip text lines.
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
