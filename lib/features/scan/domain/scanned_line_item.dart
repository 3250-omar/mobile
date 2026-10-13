/// Pure Dart domain models for scanned plumbing lines.
library;

/// Review status for a scanned line item.
enum ScanItemStatus {
  /// Match score >= 0.85 and unambiguous; product is verified and preselected.
  verified,

  /// Match score < 0.85 or competing multiple candidates; requires human review.
  needsReview,

  /// No catalog candidates with acceptable confidence; treated as a custom line item.
  unmatched,
}

/// Lifecycle status for an OCR scan session.
enum ScanSessionStatus {
  idle,
  capturing,
  processingOcr,
  matching,
  review,
  converted,
}

/// A matched candidate from the local SQLite catalog.
class CatalogCandidateMatch {
  final int productId;
  final String productCode;
  final String productName;
  final int unitPricePiastres;
  final double matchScore;
  final String matchReason;

  const CatalogCandidateMatch({
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.unitPricePiastres,
    required this.matchScore,
    required this.matchReason,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogCandidateMatch &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          productCode == other.productCode &&
          productName == other.productName &&
          unitPricePiastres == other.unitPricePiastres &&
          matchScore == other.matchScore;

  @override
  int get hashCode => Object.hash(
    productId,
    productCode,
    productName,
    unitPricePiastres,
    matchScore,
  );
}

/// Represents an extracted, parsed, and catalog-matched line from a handwritten slip.
class ScannedLineItem {
  final String id;
  final int lineNumber;
  final String rawText;
  final String normalizedText;
  final double extractedQuantity;
  final String extractedUnit;
  final CatalogCandidateMatch? matchedProduct;
  final List<CatalogCandidateMatch> candidates;
  final bool isCustom;
  final int customUnitPricePiastres;
  final ScanItemStatus reviewStatus;

  const ScannedLineItem({
    required this.id,
    required this.lineNumber,
    required this.rawText,
    required this.normalizedText,
    this.extractedQuantity = 1.0,
    this.extractedUnit = 'قطعة',
    this.matchedProduct,
    this.candidates = const [],
    this.isCustom = false,
    this.customUnitPricePiastres = 0,
    this.reviewStatus = ScanItemStatus.needsReview,
  });

  ScannedLineItem copyWith({
    String? id,
    int? lineNumber,
    String? rawText,
    String? normalizedText,
    double? extractedQuantity,
    String? extractedUnit,
    CatalogCandidateMatch? matchedProduct,
    bool clearMatchedProduct = false,
    List<CatalogCandidateMatch>? candidates,
    bool? isCustom,
    int? customUnitPricePiastres,
    ScanItemStatus? reviewStatus,
  }) {
    return ScannedLineItem(
      id: id ?? this.id,
      lineNumber: lineNumber ?? this.lineNumber,
      rawText: rawText ?? this.rawText,
      normalizedText: normalizedText ?? this.normalizedText,
      extractedQuantity: extractedQuantity ?? this.extractedQuantity,
      extractedUnit: extractedUnit ?? this.extractedUnit,
      matchedProduct: clearMatchedProduct
          ? null
          : (matchedProduct ?? this.matchedProduct),
      candidates: candidates ?? this.candidates,
      isCustom: isCustom ?? this.isCustom,
      customUnitPricePiastres:
          customUnitPricePiastres ?? this.customUnitPricePiastres,
      reviewStatus: reviewStatus ?? this.reviewStatus,
    );
  }

  /// Helper to return effective unit price in piastres.
  int get effectiveUnitPricePiastres {
    if (isCustom) {
      return customUnitPricePiastres;
    }
    return matchedProduct?.unitPricePiastres ?? customUnitPricePiastres;
  }

  /// Helper to return effective display title.
  String get effectiveTitle {
    if (isCustom || matchedProduct == null) {
      return normalizedText.isNotEmpty ? normalizedText : rawText;
    }
    return matchedProduct!.productName;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedLineItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lineNumber == other.lineNumber &&
          rawText == other.rawText &&
          normalizedText == other.normalizedText &&
          extractedQuantity == other.extractedQuantity &&
          extractedUnit == other.extractedUnit &&
          matchedProduct == other.matchedProduct &&
          isCustom == other.isCustom &&
          customUnitPricePiastres == other.customUnitPricePiastres &&
          reviewStatus == other.reviewStatus &&
          _listEquals(candidates, other.candidates);

  @override
  int get hashCode => Object.hash(
    id,
    lineNumber,
    rawText,
    normalizedText,
    extractedQuantity,
    extractedUnit,
    matchedProduct,
    isCustom,
    customUnitPricePiastres,
    reviewStatus,
    Object.hashAll(candidates),
  );
}

/// Represents a full OCR requisition scan session.
class ScanSession {
  final String sessionId;
  final String? imagePath;
  final DateTime scannedAt;
  final List<ScannedLineItem> items;
  final ScanSessionStatus status;

  const ScanSession({
    required this.sessionId,
    this.imagePath,
    required this.scannedAt,
    this.items = const [],
    this.status = ScanSessionStatus.idle,
  });

  ScanSession copyWith({
    String? sessionId,
    String? imagePath,
    DateTime? scannedAt,
    List<ScannedLineItem>? items,
    ScanSessionStatus? status,
  }) {
    return ScanSession(
      sessionId: sessionId ?? this.sessionId,
      imagePath: imagePath ?? this.imagePath,
      scannedAt: scannedAt ?? this.scannedAt,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
