import 'plumbing_text_normalizer.dart';
import 'plumbing_text_parser.dart';

/// Default rule-based implementation of [PlumbingTextParser] for Egyptian plumbing requisitions.
class DefaultPlumbingLineParser implements PlumbingTextParser {
  final PlumbingTextNormalizer normalizer;

  const DefaultPlumbingLineParser({
    this.normalizer = const PlumbingTextNormalizer(),
  });

  @override
  String normalizeText(String rawText) => normalizer.normalize(rawText);

  @override
  ParsedRawLine parseLine(String lineText) {
    final original = lineText.trim();
    final normalized = normalizeText(original);

    if (normalized.isEmpty) {
      return ParsedRawLine(
        quantity: 1.0,
        unit: 'قطعة',
        normalizedSearchTerm: '',
        originalText: original,
      );
    }

    double quantity = 1.0;
    String unit = 'قطعة';
    String searchTerm = normalized;

    // Pattern 1: Leading quantity (e.g. "10 كوع 20 مم بولي", "2.5 م ماسورة")
    final leadingMatch = RegExp(
      r'^([0-9]+(?:\.[0-9]+)?)\s*(م|متر|قطعة|حبة|لفة)?\s+(.+)$',
    ).firstMatch(normalized);

    if (leadingMatch != null) {
      final qtyStr = leadingMatch.group(1);
      final unitStr = leadingMatch.group(2);
      final termStr = leadingMatch.group(3);

      if (qtyStr != null) {
        quantity = double.tryParse(qtyStr) ?? 1.0;
      }
      if (unitStr != null) {
        unit = _standardizeUnit(unitStr);
      } else if (termStr != null && termStr.contains('ماسورة')) {
        unit = 'متر';
      }
      searchTerm = termStr ?? normalized;
    } else {
      // Pattern 2: Suffix quantity with or without "عدد" (e.g. "محبس دفن 3/4 عدد 5")
      final suffixMatch = RegExp(
        r'^(.+?)\s+(?:عدد\s+)?([0-9]+(?:\.[0-9]+)?)\s*(م|متر|قطعة|حبة|لفة)?$',
      ).firstMatch(normalized);

      if (suffixMatch != null) {
        final termStr = suffixMatch.group(1);
        final qtyStr = suffixMatch.group(2);
        final unitStr = suffixMatch.group(3);

        if (qtyStr != null) {
          quantity = double.tryParse(qtyStr) ?? 1.0;
        }
        if (unitStr != null) {
          unit = _standardizeUnit(unitStr);
        } else if (termStr != null && termStr.contains('ماسورة')) {
          unit = 'متر';
        }
        searchTerm = termStr ?? normalized;
      }
    }

    // Clean up search term
    searchTerm = searchTerm
        .replaceAll(RegExp(r'\b(عدد|قطعة|حبة)\b'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return ParsedRawLine(
      quantity: quantity,
      unit: unit,
      normalizedSearchTerm: searchTerm.isNotEmpty ? searchTerm : normalized,
      originalText: original,
    );
  }

  @override
  List<ParsedRawLine> parseAll(List<String> rawLines) {
    final results = <ParsedRawLine>[];

    for (final line in rawLines) {
      final trimmed = line.trim();
      // Skip empty, noise, or pure symbol lines
      if (trimmed.isEmpty ||
          RegExp(r'^[\-\_\=\*\#\.\,\:\;\s]+$').hasMatch(trimmed)) {
        continue;
      }

      final parsed = parseLine(trimmed);
      if (parsed.normalizedSearchTerm.isNotEmpty) {
        results.add(parsed);
      }
    }

    return results;
  }

  String _standardizeUnit(String rawUnit) {
    if (rawUnit == 'م' || rawUnit == 'متر') {
      return 'متر';
    }
    if (rawUnit == 'لفة') {
      return 'لفة';
    }
    return 'قطعة';
  }
}
