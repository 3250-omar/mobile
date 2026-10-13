# Quickstart: Feature 005 - Offline Arabic OCR & Plumbing Requisition Parsing

**Feature**: `005-scan-ocr-handwriting`  
**Date**: 2026-10-13  
**Status**: Completed  

---

## Prerequisites
- Android Studio / VS Code with Flutter SDK >= 3.47.5
- Android emulator or physical device with Android API 26+ (or local host test runner)
- Local SQLite catalog populated with sample plumbing products (from Feature 002 test fixtures or Excel import)

---

## Verification Scenarios

### 1. Verification of Plumbing Text Normalizer & Parser (Unit Tests)
Execute deterministic tests on Egyptian plumbing requisition phrases:
```bash
flutter test test/features/scan/domain/plumbing_text_parser_test.dart
```
**Expected Outcome**:
- `١٠ كوع ٢٠ مم بولي` parses to `10.0`, `"قطعة"`, `"كوع 20 مم بولي"`.
- `محبس 3/4 دفن عدد 5` parses to `5.0`, `"قطعة"`, `"محبس 3/4 دفن"`.
- `2.5 م ماسورة بولي 25` parses to `2.5`, `"متر"`, `"ماسورة بولي 25"`.

### 2. Verification of Catalog Matcher & Confidence Thresholds (Unit / Integration Tests)
Execute tests validating scoring and ambiguous candidate detection:
```bash
flutter test test/features/scan/domain/catalog_matcher_test.dart
```
**Expected Outcome**:
- Exact matches score $\ge 0.85$ and obtain `ScanItemStatus.verified`.
- Ambiguous terms (e.g. `"محبس 1/2"`) yield multiple candidates and receive `ScanItemStatus.needsReview`.
- Unrecognized terms receive `ScanItemStatus.unmatched` and default to custom items.

### 3. Verification of OCR Capture & Review UI Flow (Widget Tests)
Execute widget tests validating image selection, state transitions, candidate picker dialog, and conversion to quotation/invoice:
```bash
flutter test test/features/scan/presentation/scan_screen_test.dart
flutter test test/features/scan/presentation/scan_review_screen_test.dart
```
**Expected Outcome**:
- Scan tab displays image acquisition buttons in RTL Arabic.
- Loading indicator displayed while OCR and matching are simulated.
- Review screen lists items with clear confidence badges.
- Tapping "إنشاء عرض سعر" pre-populates `QuotationFormScreen` with extracted items.
- Tapping "إنشاء فاتورة" pre-populates `InvoiceFormScreen` with extracted items.

### 4. Full Quality Gate Verification
```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze lib test
flutter test
```
