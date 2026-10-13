# Feature Specification: 005-scan-ocr-handwriting

**Feature Branch**: `005-scan-ocr-handwriting`  
**Created**: 2026-10-13  
**Status**: Draft  
**Input**: User description: "Offline Arabic OCR & Handwriting Recognition for Plumbing Materials requisition slips and automatic quotation/invoice item drafting"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Image Capture & 100% Offline OCR (Priority: P1)

A plumbing supply merchant receives a handwritten order paper or contractor requisition slip. The merchant taps the prominent Scan button in the bottom navigation, captures a photo using the camera (or picks an existing photo from the device gallery), and the app processes the image completely on-device without internet access to extract Arabic and numeral text lines.

**Why this priority**: Core prerequisite for scanning handwriting. Without offline image capture and raw text extraction, no subsequent parsing or item matching can occur.

**Independent Test**: Can be verified by picking a test image of handwritten text; verify that raw text lines are extracted locally with zero outbound network calls.

**Acceptance Scenarios**:
1. **Given** the merchant is on the Scan tab, **When** they tap "التقاط صورة" (Take Photo) or "اختيار من المعرض" (Pick from Gallery), **Then** the device camera/file picker opens, and the selected image is displayed in a preview container.
2. **Given** an image is loaded, **When** the merchant initiates recognition, **Then** on-device OCR extracts line-by-line Arabic text and numerals within 3 seconds without network connection.
3. **Given** the device is in airplane mode, **When** recognition is performed, **Then** OCR executes successfully and produces text without errors or timeouts.

---

### User Story 2 - Arabic Plumbing Text Normalization & Line Parsing (Priority: P1)

The system automatically parses the raw recognized lines into structured item drafts containing: quantity, unit, and item description. It handles colloquial Egyptian plumbing terms, fractions (½, ¾, 1½, 1/2, 3/4), mixed Eastern Arabic (`١٢٣`) and Western Arabic (`123`) digits, and common abbreviations (e.g. `محبس`, `كوع`, `تيز`, `جلبة`, `بولي`).

**Why this priority**: Raw text from OCR is unstructured. Transforming text into quantities and item keywords is essential to populate quotations and invoices.

**Independent Test**: Provide recognized strings such as `"10 كوع 20 مم بولي"` or `"محبس 3/4 دفن عدد 5"` and verify structured parsing extracts quantity, unit, and product title accurately.

**Acceptance Scenarios**:
1. **Given** raw text line `"10 كوع 20 مم بولي"`, **When** parsed, **Then** quantity is extracted as `10`, unit as `"قطعة"`, and search query as `"كوع 20 مم بولي"`.
2. **Given** raw text containing Arabic numerals `"٥ محبس دفن ٣/٤"`, **When** parsed, **Then** numerals and fractions are normalized to Western digits and standard fractions (`5` pieces, `"محبس دفن 3/4"`).
3. **Given** raw text with missing explicit quantity, **When** parsed, **Then** the system defaults quantity to `1` and marks it for user confirmation.

---

### User Story 3 - Catalog Matching & Confidence Evaluation (Priority: P2)

The system matches each parsed item against the merchant's local SQLite catalog. For each line, it calculates a matching confidence score (0.0 to 1.0). Matches meeting the high-confidence threshold (≥ 0.85) are preselected; ambiguous matches with multiple catalog candidates or low confidence (< 0.85) are clearly flagged with visual warning indicators for human review.

**Why this priority**: Guarantees compliance with Constitution Principle VII (Transparent Matching & Human Approval): prevents incorrect product preselection and price discrepancies.

**Independent Test**: Given a parsed item, compare against database products and verify that exact/close matches have high confidence while ambiguous items display candidate alternatives.

**Acceptance Scenarios**:
1. **Given** an unambiguous parsed line `"كوع 20 مم بولي"`, **When** matched against the catalog, **Then** the catalog product is preselected with confidence ≥ 0.85.
2. **Given** a generic parsed line `"محبس 1/2"`, **When** multiple products match (e.g. محبس بلية vs محبس دفن), **Then** the item is marked as "بحاجة لمراجعة" (Needs Review) and presents the matching candidates for selection.
3. **Given** an item not found in the catalog, **When** processed, **Then** it is marked as a "صنف مخصص" (Custom Item) retaining its original recognized name and quantity.

---

### User Story 4 - Interactive Review, Editing & Direct Conversion (Priority: P2)

The merchant reviews the extracted and matched items on an Arabic review screen. The merchant can review side-by-side or stacked recognition, adjust quantities, change matched products, delete misrecognized lines, or add missing items. With a single tap, the verified items are converted into a new Quotation Draft or Sales Invoice.

**Why this priority**: Delivers the primary business value: turning paper requisition slips into digital quotations and invoices in seconds without manual re-typing.

**Independent Test**: Tap "إنشاء عرض سعر" from the review screen; verify that a Quotation Draft opens with all verified items and financial totals pre-filled.

**Acceptance Scenarios**:
1. **Given** the merchant is on the OCR Review screen, **When** they tap on an item with a warning flag, **Then** a modal opens allowing them to pick the correct catalog product or edit text.
2. **Given** the merchant is satisfied with verified items, **When** they tap "إنشاء عرض سعر" (Create Quotation), **Then** QuotationFormScreen opens populated with these items.
3. **Given** the merchant wants to directly invoice the customer, **When** they tap "إنشاء فاتورة" (Create Invoice), **Then** InvoiceFormScreen opens populated with these items.

---

### Edge Cases

- **Blurry or poor quality image**: System detects low contrast or unrecognizable image, displaying clear Arabic feedback: "تعذر قراءة النص بوضوح، يرجى إعادة التقاط الصورة بإضاءة أفضل".
- **Empty paper / No text found**: Graceful empty state without crash: "لم يتم العثور على أي نصوص في الصورة المحددة".
- **Paper containing non-plumbing text (stray handwriting / headers / dates)**: Lines with no numerical or catalog resemblance are placed in an unclassified section where user can discard them or assign them as notes.
- **Fractional quantities (e.g. 2.5 متر)**: Normalized to appropriate unit quantities and units (e.g. meters or pieces).
- **Multiple items on a single line**: Split delimiters (such as commas, dashes, or bullet points) segment items into distinct line entries.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST perform 100% on-device image acquisition (camera and gallery) and optical character recognition strictly without external API or internet access.
- **FR-002**: System MUST support Arabic script, Arabic-Indic numerals (`٠١٢٣٤٥٦٧٨٩`), Western numerals (`0123456789`), and vulgar fractions (`½`, `¾`, `¼`, `1/2`, `3/4`).
- **FR-003**: System MUST normalize colloquial plumbing abbreviations and synonyms (e.g., `كوع`, `محبس`, `تيز`, `جلبة`, `نيبل`, `بولي`, `شريف`, `باننجر`) to canonical search queries.
- **FR-004**: System MUST parse each recognized line into `quantity`, `unit`, and `rawText` / `searchTerm`.
- **FR-005**: System MUST match search terms against the local SQLite products catalog using weighted token matching and levenshtein/trigram distance.
- **FR-006**: System MUST calculate an explicit confidence score (0.0 to 1.0) for every matched line.
- **FR-007**: System MUST flag any item with confidence < 0.85 or with ambiguous multiple candidates as "بحاجة لمراجعة" (Needs Review).
- **FR-008**: System MUST allow the user to manually re-select the product, edit the quantity, toggle between catalog and custom item, or delete any recognized line.
- **FR-009**: System MUST allow one-tap export of verified items into `QuotationFormScreen` as line item drafts.
- **FR-010**: System MUST allow one-tap export of verified items into `InvoiceFormScreen` as line item drafts.
- **FR-011**: System MUST strictly discard captured image data from temporary cache upon session completion or user exit, preserving user privacy.
- **FR-012**: System MUST render all OCR review interfaces in right-to-left Arabic with Material 3 styling and high contrast.

---

### Key Entities

- **ScannedReceipt**: Represents a scan session, holding original image path, scan timestamp, processing status, and raw extracted lines.
- **ParsedLineItem**: Extracted structured item containing: line number, raw text, normalized text, extracted quantity, extracted unit, confidence score, and review status (`verified`, `needsReview`, `unmatched`).
- **CatalogCandidateMatch**: A potential matching catalog product for a line item, including `productId`, `productCode`, `productName`, `unitPricePiastres`, and `matchScore`.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: On-device OCR processing completes in less than 3.5 seconds on mid-range Android devices (API 26+).
- **SC-002**: At least 85% of standard handwritten plumbing slips with legible handwriting are successfully parsed into quantities and item terms.
- **SC-003**: 100% of ambiguous or sub-threshold items (< 0.85 confidence) are flagged to require human review before quotation/invoice creation.
- **SC-004**: Users can review, correct, and convert a 10-item handwritten list into an official Quotation Draft in under 60 seconds (compared to 3-5 minutes of manual retyping).
- **SC-005**: Zero network traffic is generated during camera capture, OCR processing, catalog matching, and document conversion.

---

## Assumptions

- OCR engine runs embedded on-device (e.g. Google ML Kit Digital Ink / Text Recognition on-device bundles or pure local model assets).
- Camera permission is requested at runtime with descriptive Arabic explanation of local-only usage.
- Catalog already contains products loaded from Excel or manual entry (Feature 002).
- Users write requisition slips primarily in Arabic or Arabic mixed with English numbers/dimensions.
