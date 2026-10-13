# Research: Offline Arabic OCR & Plumbing Requisition Parsing

**Feature**: `005-scan-ocr-handwriting`  
**Date**: 2026-10-13  
**Status**: Completed  

---

## 1. On-Device Arabic Optical Character Recognition (OCR)

### Decision
Use an abstract interface `OcrScanner` in the domain layer, with two concrete implementations:
1. `MlKitOcrScanner`: Leverages `google_mlkit_text_recognition` configured with `TextRecognitionScript.arabic`. Runs 100% on-device on Android (API 26+) and iOS (15+).
2. `FakeOcrScanner`: In-memory test engine pre-loaded with realistic handwritten Arabic plumbing slips for fast, deterministic unit, widget, and integration testing without requiring hardware cameras or native ML Kit binaries.

### Rationale
- **100% Offline (Constitution Principle I)**: Google ML Kit runs on-device neural networks without transmitting image pixels or tokens to external servers.
- **Architectural Isolation (Constitution Principle IX)**: Abstracting OCR behind `OcrScanner` allows replacing the underlying OCR engine (e.g. custom TFLite model, Tesseract, or OS-native Vision framework) without altering parsing, catalog matching, or UI layers.
- **Host Testing Compatibility (Constitution Principle X)**: Native ML Kit C++ binaries cannot execute in headless host test runners (`flutter test` on Windows/Linux). `FakeOcrScanner` allows 100% test coverage of all downstream parsing, matching, confidence scoring, and UI flows.

### Alternatives Considered
- **Cloud Vision APIs (Google Cloud Vision, Azure Cognitive Services)**: Rejected due to violation of Constitution Principle I (Strictly Zero Network Calls).
- **Tesseract OCR (`flutter_tesseract_ocr`)**: Requires bundling bulky language data assets (~15-25MB `ara.traineddata`), lower accuracy on Arabic cursive handwriting without extensive pre-processing.
- **Custom TFLite model**: High training and maintenance burden for generic handwriting before baseline validation.

---

## 2. Arabic Plumbing Text Normalization & Line Parsing

### Decision
Implement a deterministic rule-based tokenizer and normalizer in `PlumbingTextNormalizer` and `PlumbingLineParser`:
1. **Numeral Normalization**: Convert Eastern Arabic-Indic digits (`٠١٢٣٤٥٦٧٨٩`) to standard ASCII digits (`0123456789`).
2. **Fraction Normalization**: Convert vulgar fraction glyphs (`½`, `¼`, `¾`, `⅛`, `⅜`, `⅝`, `⅞`) and textual fractional representations (`1/2`, `3/4`, `نص`, `ربع`, `ثلاثة ارباع`) into standardized canonical representation (e.g., `1/2`, `3/4`).
3. **Plumbing Term Synonyms & Abbreviations**:
   - `كوع`, `اكواع` -> `كوع`
   - `محبس`, `محابس` -> `محبس`
   - `تيز`, `تي` -> `تي`
   - `جلبة`, `جلب` -> `جلبة`
   - `نيبل`, `نياكل`, `نيبلز` -> `نيبل`
   - `بوش`, `بوشات` -> `بوش`
   - `مسلوب` -> `مسلوب`
   - `لاكور`, `لاكورا` -> `لاكور`
   - `بولي`, `بروبلين`, `ppr` -> `بولي`
   - `شريف`, `الشريف` -> `الشريف`
   - `باننجر`, `باننجير` -> `باننجر`
4. **Quantity and Unit Extraction**:
   - Extract prefix/suffix counts (e.g. `"10 كوع"`, `"كوع 10"`, `"عدد 5 محبس"`, `"5 م ماسورة"`).
   - Infer units: `"متر"` / `"م"` for pipes, `"قطعة"` / `"حبة"` for fittings/valves, `"لفة"` for rolls. Default to `"قطعة"` and `1` if omitted.

### Rationale
Plumbing requisition slips written by plumbers in Egypt have highly predictable grammatical and lexical structures: `[Quantity] [Product Base] [Dimension/Spec] [Brand/Type]`. Rule-based regex tokenization is instantaneous (< 5ms), 100% deterministic, and requires no external ML inference.

---

## 3. Local Catalog Fuzzy Matching & Confidence Scoring

### Decision
Implement `CatalogMatcher` operating over the local SQLite catalog (from Feature 002):
1. **Token Overlap & Weighting**:
   - Base type token (e.g. `كوع`, `محبس`): 40% weight.
   - Dimension/Size token (e.g. `20`, `1/2`, `3/4`, `25`, `1 بوصة`): 40% weight.
   - Brand/Material token (e.g. `بولي`, `شريف`, `دفن`, `زاوية`): 20% weight.
2. **Levenshtein / Bigram Distance**:
   - Applied to individual tokens to accommodate OCR character typos (e.g., `مجس` for `محبس`).
3. **Confidence Threshold & Safety Gates (Constitution Principle VII)**:
   - Composite Score $\ge 0.85$: Status `verified`. The top catalog product is preselected.
   - Composite Score $< 0.85$ OR Ambiguous Top Candidates (score difference between rank 1 and rank 2 $< 0.10$): Status `needsReview`. Flagged with a warning badge; the user must pick the product from top candidates or accept as custom item.
   - No Candidate Matching $\ge 0.40$: Status `unmatched`. Defaulted to custom item with recognized description.

### Rationale
Ensures zero unintended false matches, strictly adhering to Constitutional Principle VII (Human-in-the-Loop Control) and preventing erroneous pricing in subsequent documents.

---

## 4. Integration with Quotations and Invoices (Features 003 & 004)

### Decision
From the OCR Review Screen:
- **"إنشاء عرض سعر" (Create Quotation)**: Packages verified line items (`productId`, `description`, `quantity`, `unit`, `unitPricePiastres`) and navigates to `QuotationFormScreen` via `GoRouter.pushNamed(RouteNames.quotationNew, extra: initialItems)`.
- **"إنشاء فاتورة" (Create Invoice)**: Packages verified line items and navigates to `InvoiceFormScreen` via `GoRouter.pushNamed(RouteNames.invoiceNew, extra: initialItems)`.

### Rationale
Reuses existing form controllers and screens without code duplication. The merchant can review customer details, apply additional discounts, and finalize the document through the standard tested pipelines.
