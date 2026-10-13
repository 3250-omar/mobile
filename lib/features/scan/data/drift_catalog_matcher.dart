import 'dart:math';

import 'package:offline_quotes/core/database/app_database.dart';

import '../domain/catalog_matcher.dart';
import '../domain/plumbing_text_parser.dart';
import '../domain/scanned_line_item.dart';

/// Local SQLite Drift catalog matcher with token-weighted similarity and ambiguity protection.
class DriftCatalogMatcher implements CatalogMatcher {
  final AppDatabase _db;

  const DriftCatalogMatcher(this._db);

  static const List<String> _productTypes = [
    'كوع',
    'محبس',
    'تي',
    'جلبة',
    'نيبل',
    'بوش',
    'لاكور',
    'ماسورة',
    'سيفون',
    'خلاط',
    'شطاف',
    'مسلوب',
    'شريط',
    'طبة',
  ];

  @override
  Future<ScannedLineItem> matchItem({
    required int lineNumber,
    required ParsedRawLine parsedLine,
  }) async {
    final query = parsedLine.normalizedSearchTerm.trim().toLowerCase();
    final allProducts = await _db.select(_db.productsTable).get();

    final candidates = <CatalogCandidateMatch>[];

    for (final prod in allProducts) {
      final prodName = prod.name.trim().toLowerCase();
      final score = _calculateSimilarity(query, prodName, prod.category);

      if (score >= 0.30) {
        String reason = 'تطابق جزئي';
        if (score >= 0.95) {
          reason = 'تطابق تام في الصنف والمواصفات';
        } else if (score >= 0.85) {
          reason = 'تطابق عالي في نوع الصنف والمقاس';
        } else if (score >= 0.60) {
          reason = 'تشابه في مواصفات أو مقاسات الصنف';
        }

        candidates.add(
          CatalogCandidateMatch(
            productId: prod.id,
            productCode: prod.code,
            productName: prod.name,
            unitPricePiastres: prod.unitPricePiastres,
            matchScore: double.parse(score.toStringAsFixed(2)),
            matchReason: reason,
          ),
        );
      }
    }

    // Sort descending by score
    candidates.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    final topCandidates = candidates.take(5).toList();

    // Determine review status and preselection based on Constitutional thresholds
    if (topCandidates.isEmpty || topCandidates.first.matchScore < 0.40) {
      return ScannedLineItem(
        id: 'scan-item-$lineNumber-${DateTime.now().millisecondsSinceEpoch}',
        lineNumber: lineNumber,
        rawText: parsedLine.originalText,
        normalizedText: parsedLine.normalizedSearchTerm,
        extractedQuantity: parsedLine.quantity,
        extractedUnit: parsedLine.unit,
        matchedProduct: null,
        candidates: const [],
        isCustom: true,
        customUnitPricePiastres: 0,
        reviewStatus: ScanItemStatus.unmatched,
      );
    }

    final topMatch = topCandidates.first;
    ScanItemStatus status;

    if (topMatch.matchScore >= 0.85) {
      // Check ambiguity: if runner-up candidate is within 0.10 score
      if (topCandidates.length >= 2 &&
          (topMatch.matchScore - topCandidates[1].matchScore) < 0.10) {
        status = ScanItemStatus.needsReview;
      } else {
        status = ScanItemStatus.verified;
      }
    } else {
      status = ScanItemStatus.needsReview;
    }

    return ScannedLineItem(
      id: 'scan-item-$lineNumber-${DateTime.now().millisecondsSinceEpoch}',
      lineNumber: lineNumber,
      rawText: parsedLine.originalText,
      normalizedText: parsedLine.normalizedSearchTerm,
      extractedQuantity: parsedLine.quantity,
      extractedUnit: parsedLine.unit,
      matchedProduct: topMatch,
      candidates: topCandidates,
      isCustom: false,
      customUnitPricePiastres: topMatch.unitPricePiastres,
      reviewStatus: status,
    );
  }

  @override
  Future<List<ScannedLineItem>> matchAll(
    List<ParsedRawLine> parsedLines,
  ) async {
    final results = <ScannedLineItem>[];
    for (var i = 0; i < parsedLines.length; i++) {
      final item = await matchItem(
        lineNumber: i + 1,
        parsedLine: parsedLines[i],
      );
      results.add(item);
    }
    return results;
  }

  double _calculateSimilarity(String query, String target, String? category) {
    if (query == target) return 1.0;

    final qTokens = query
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toSet();
    final tTokens = target
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toSet();

    if (qTokens.isEmpty || tTokens.isEmpty) return 0.0;

    // Detect base product type for query and target
    String? qType;
    for (final type in _productTypes) {
      if (qTokens.contains(type)) {
        qType = type;
        break;
      }
    }

    String? tType;
    for (final type in _productTypes) {
      if (tTokens.contains(type)) {
        tType = type;
        break;
      }
    }

    // Heavy penalty if both have a distinct base type and they don't match (e.g. كوع vs محبس)
    if (qType != null && tType != null && qType != tType) {
      return 0.15;
    }

    // Dimension / size matching
    final dimensions = [
      '1/2',
      '3/4',
      '1/4',
      '1',
      '20',
      '25',
      '32',
      '40',
      '50',
      '63',
      '75',
      '90',
      '110',
    ];
    final qDims = qTokens.intersection(dimensions.toSet());
    final tDims = tTokens.intersection(dimensions.toSet());

    double score = 0.0;

    // Type match weight (40%)
    if (qType != null && qType == tType) {
      score += 0.40;
    } else if (qType == null) {
      score += 0.20;
    }

    // Dimension match weight (35%)
    if (qDims.isNotEmpty && tDims.isNotEmpty) {
      if (qDims.intersection(tDims).isNotEmpty) {
        score += 0.35;
      } else {
        // Conflicting dimensions (e.g. 20mm vs 25mm)
        score -= 0.15;
      }
    } else if (qDims.isEmpty) {
      score += 0.15;
    }

    // General token overlap (25%)
    final intersection = qTokens.intersection(tTokens).length;
    final union = qTokens.union(tTokens).length;
    final jaccard = union > 0 ? intersection / union : 0.0;
    score += jaccard * 0.25;

    // Boost if query is substring
    if (target.contains(query)) {
      score = max(score, 0.90);
    }

    return score.clamp(0.0, 1.0);
  }
}
