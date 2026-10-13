import 'package:flutter/foundation.dart';

import '../domain/scanned_line_item.dart';

/// Immutable UI state for the OCR scanning and review workflow.
@immutable
class ScanState {
  final String? imagePath;
  final ScanSessionStatus status;
  final List<String> rawLines;
  final List<ScannedLineItem> items;
  final String? errorMessage;

  const ScanState({
    this.imagePath,
    this.status = ScanSessionStatus.idle,
    this.rawLines = const [],
    this.items = const [],
    this.errorMessage,
  });

  bool get isLoading =>
      status == ScanSessionStatus.capturing ||
      status == ScanSessionStatus.processingOcr ||
      status == ScanSessionStatus.matching;

  bool get hasItems => items.isNotEmpty;

  int get verifiedCount =>
      items.where((i) => i.reviewStatus == ScanItemStatus.verified).length;

  int get needsReviewCount =>
      items.where((i) => i.reviewStatus == ScanItemStatus.needsReview).length;

  int get unmatchedCount =>
      items.where((i) => i.reviewStatus == ScanItemStatus.unmatched).length;

  ScanState copyWith({
    String? imagePath,
    bool clearImagePath = false,
    ScanSessionStatus? status,
    List<String>? rawLines,
    List<ScannedLineItem>? items,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ScanState(
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      status: status ?? this.status,
      rawLines: rawLines ?? this.rawLines,
      items: items ?? this.items,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanState &&
          runtimeType == other.runtimeType &&
          imagePath == other.imagePath &&
          status == other.status &&
          errorMessage == other.errorMessage &&
          listEquals(rawLines, other.rawLines) &&
          listEquals(items, other.items);

  @override
  int get hashCode => Object.hash(
    imagePath,
    status,
    errorMessage,
    Object.hashAll(rawLines),
    Object.hashAll(items),
  );
}
