# Tasks: 005-scan-ocr-handwriting

**Branch**: `005-scan-ocr-handwriting` | **Spec**: [specs/005-scan-ocr-handwriting/spec.md](file:///e:/freelancing/mobile/specs/005-scan-ocr-handwriting/spec.md) | **Plan**: [specs/005-scan-ocr-handwriting/plan.md](file:///e:/freelancing/mobile/specs/005-scan-ocr-handwriting/plan.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Set up domain contracts, data structures, and localized string keys for offline scan and recognition.

- [x] T001 [P] Add Arabic localization strings for scan, OCR processing, confidence warnings, and candidate matching in lib/l10n/app_ar.arb
- [x] T002 [P] Create domain entities `ScannedLineItem`, `CatalogCandidateMatch`, `ScanSession`, and status enums in lib/features/scan/domain/scanned_line_item.dart
- [x] T003 [P] Create `OcrScanner` interface and `OcrException` contract in lib/features/scan/domain/ocr_scanner.dart
- [x] T004 [P] Create `PlumbingTextParser` interface and `ParsedRawLine` value object in lib/features/scan/domain/plumbing_text_parser.dart
- [x] T005 [P] Create `CatalogMatcher` interface contract in lib/features/scan/domain/catalog_matcher.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core OCR mock and image capture service that all scan workflows depend on.

- [x] T006 [P] Create `ImageCaptureService` interface and file-picker-based local image capture implementation in lib/features/scan/data/image_capture_service.dart
- [x] T007 [P] Create `FakeOcrScanner` with representative Egyptian plumbing requisition test slips in lib/features/scan/data/fake_ocr_scanner.dart
- [x] T008 Unit test `FakeOcrScanner` ensuring deterministic multi-line Arabic slip extraction in test/features/scan/data/fake_ocr_scanner_test.dart

**Checkpoint**: Core domain models, contracts, and test fixtures ready. User story implementation can begin.

---

## Phase 3: User Story 1 - Image Capture & 100% Offline OCR (Priority: P1) 🎯 MVP

**Goal**: Capture photo or pick image from gallery and extract raw Arabic text lines 100% on-device without internet access.

**Independent Test**: Load a test image file and verify raw Arabic text lines are extracted within 3 seconds with zero network calls.

### Tests for User Story 1
- [x] T009 [P] [US1] Unit test for image acquisition and OCR extraction in test/features/scan/data/image_capture_service_test.dart

### Implementation for User Story 1
- [x] T010 [P] [US1] Create `MlKitOcrScanner` implementation wrapping on-device Arabic text recognizer in lib/features/scan/data/mlkit_ocr_scanner.dart
- [x] T011 [US1] Register `ocrScannerProvider` and `imageCaptureServiceProvider` in lib/app/bootstrap/providers.dart
- [x] T012 [US1] Create `ScanState` immutable model (idle, capturing, recognizing, parsed, error) in lib/features/scan/application/scan_state.dart
- [x] T013 [US1] Implement `ScanController` to manage image picking and raw line extraction in lib/features/scan/application/scan_controller.dart
- [x] T014 [US1] Update `ScanScreen` to provide camera/gallery capture buttons, image preview container, and recognition status in lib/features/scan/presentation/scan_screen.dart

**Checkpoint**: Image acquisition and on-device text line extraction is fully operational and testable.

---

## Phase 4: User Story 2 - Arabic Plumbing Text Normalization & Line Parsing (Priority: P1)

**Goal**: Transform unstructured Arabic text lines into structured line items with normalized quantities, units, and canonical plumbing search queries.

**Independent Test**: Pass strings such as `"١٠ كوع ٢٠ مم بولي"` and `"محبس دفن 3/4 عدد 5"` and verify extraction of quantity, unit, and normalized search query.

### Tests for User Story 2
- [x] T015 [P] [US2] Unit tests for `PlumbingTextNormalizer` (Eastern digits, fractions ½/¾, plumbing synonyms) in test/features/scan/domain/plumbing_text_normalizer_test.dart
- [x] T016 [P] [US2] Unit tests for `PlumbingLineParser` (quantity extraction, unit inference, item name extraction) in test/features/scan/domain/plumbing_line_parser_test.dart

### Implementation for User Story 2
- [x] T017 [P] [US2] Implement `PlumbingTextNormalizer` handling Eastern-to-Western digits, vulgar fractions, and Egyptian plumbing synonyms in lib/features/scan/domain/plumbing_text_normalizer.dart
- [x] T018 [US2] Implement `DefaultPlumbingLineParser` extracting quantities, units, and cleaned product queries in lib/features/scan/domain/plumbing_line_parser.dart
- [x] T019 [US2] Integrate line parsing into `ScanController` to produce initial structured draft items in lib/features/scan/application/scan_controller.dart

**Checkpoint**: Raw OCR lines automatically parse into structured items with verified quantities and units.

---

## Phase 5: User Story 3 - Catalog Matching & Confidence Evaluation (Priority: P2)

**Goal**: Match parsed items against local Drift SQLite catalog, calculating confidence scores and enforcing the $\ge 0.85$ safety threshold.

**Independent Test**: Compare parsed items against test catalog; verify exact matches yield $\ge 0.85$ (`verified`), ambiguous items yield multiple candidates with `< 0.85` (`needsReview`), and unknown items become custom items (`unmatched`).

### Tests for User Story 3
- [x] T020 [P] [US3] Unit and integration tests for `CatalogMatcher` with confidence scoring and ambiguity detection in test/features/scan/domain/catalog_matcher_test.dart

### Implementation for User Story 3
- [x] T021 [US3] Implement `DriftCatalogMatcher` with token-weighted matching, Levenshtein distance, candidate ranking, and confidence scoring in lib/features/scan/data/drift_catalog_matcher.dart
- [x] T022 [US3] Register `catalogMatcherProvider` in lib/app/bootstrap/providers.dart
- [x] T023 [US3] Connect catalog matching into `ScanController` to populate candidates, scores, and review statuses in lib/features/scan/application/scan_controller.dart

**Checkpoint**: Parsed items are matched against the local catalog with transparent scores and human-in-the-loop flags.

---

## Phase 6: User Story 4 - Interactive Review, Editing & Direct Conversion (Priority: P2)

**Goal**: Provide an Arabic Material 3 review screen where merchants can inspect items, resolve warnings, adjust quantities/prices, and convert items directly into a new Quotation or Invoice.

**Independent Test**: Tap "إنشاء عرض سعر" or "إنشاء فاتورة" from the review screen and verify that `QuotationFormScreen` or `InvoiceFormScreen` opens populated with the verified items.

### Tests for User Story 4
- [x] T024 [P] [US4] Widget tests for `CandidateSelectorDialog` and candidate selection in test/features/scan/presentation/candidate_selector_dialog_test.dart
- [x] T025 [P] [US4] Widget tests for `ScanReviewScreen` (list, badges, quantity edit, conversion buttons) in test/features/scan/presentation/scan_review_screen_test.dart

### Implementation for User Story 4
- [x] T026 [P] [US4] Create `LineItemReviewTile` showing confidence badge, warning icon for <0.85, quantity controls, and candidate button in lib/features/scan/presentation/widgets/line_item_review_tile.dart
- [x] T027 [P] [US4] Create `CandidateSelectorDialog` allowing merchant to pick from matched catalog candidates or enter custom product in lib/features/scan/presentation/widgets/candidate_selector_dialog.dart
- [x] T028 [P] [US4] Create `ManualItemDialog` for adding a new item to the scanned list in lib/features/scan/presentation/widgets/manual_item_dialog.dart
- [x] T029 [US4] Implement `ScanReviewScreen` displaying original image preview thumbnail, parsed items list, summary statistics, and conversion actions in lib/features/scan/presentation/scan_review_screen.dart
- [x] T030 [US4] Update `QuotationFormScreen` and `InvoiceFormScreen` to accept initial items list passed via `GoRouterState.extra` in lib/features/quotations/presentation/quotation_form_screen.dart and lib/features/invoices/presentation/invoice_form_screen.dart
- [x] T031 [US4] Configure Scan navigation routes in lib/app/navigation/app_router.dart and lib/app/navigation/route_names.dart

**Checkpoint**: End-to-end scanning, parsing, matching, human review, and document creation is complete.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Architecture verification, test coverage, code formatting, and analyzer cleanliness.

- [x] T032 [P] Clean up temporary image cache files on session completion or exit in lib/features/scan/application/scan_controller.dart
- [x] T033 Update fake repository overrides in test/app/navigation/app_router_test.dart to support scan providers
- [x] T034 Run full test suite, analyzer, and code formatting across the repository

---

## Dependencies & Execution Order

### Phase Dependencies
- **Phase 1 (Setup)**: No dependencies.
- **Phase 2 (Foundational)**: Depends on Phase 1 completion.
- **Phase 3 (User Story 1 - OCR)**: Depends on Phase 2.
- **Phase 4 (User Story 2 - Normalization & Parsing)**: Depends on Phase 2 & 3.
- **Phase 5 (User Story 3 - Catalog Matching)**: Depends on Phase 4.
- **Phase 6 (User Story 4 - Review & Conversion)**: Depends on Phase 5.
- **Phase 7 (Polish)**: Depends on Phase 6.

### Parallel Opportunities
- T001, T002, T003, T004, T005 can all execute in parallel.
- T006 and T007 can execute in parallel.
- T015 and T016 can execute in parallel.
- T024, T025, T026, T027, T028 can execute in parallel.

---

## Implementation Strategy

### MVP First (Phases 1, 2, and 3)
1. Complete Setup and Foundational contracts.
2. Complete User Story 1 (Image Capture & OCR Extraction).
3. Validate OCR extraction independently.

### Incremental Delivery
1. Add User Story 2 (Plumbing Text Normalization & Line Parsing) -> Test parsing independently.
2. Add User Story 3 (Catalog Matching & Confidence Scoring) -> Test local SQLite matching independently.
3. Add User Story 4 (Review UI & One-Tap Conversion to Quotation/Invoice) -> Test end-to-end user journey.
4. Polish, memory cleanup, quality gate validation.
