# Feature Specification: Catalog & Product Management (002-catalog-management)

**Feature Branch**: `002-catalog-management`

**Created**: 2026-10-13

**Status**: Draft

**Input**: User description: "Catalog & Product Management: offline Excel workbook import, normalized SQLite product storage, Arabic-first search and filtering, and product maintenance for plumbing and sanitary supply supplies."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Import Plumbing Catalog from Excel (Priority: P1)

As a plumbing supplies shop owner, I want to import my product catalog from an Excel file on my device into the app, so that all my items, units, and prices are available locally and 100% offline without manual typing.

**Why this priority**: Without an active product catalog, neither product search nor future quotation line-item matching can function. Offline manual Excel import is the foundational data entry mechanism mandated by the constitution.

**Independent Test**: Can be independently verified by selecting a sample plumbing catalog Excel sheet (.xlsx/.xls) in airplane mode, executing import, and confirming all valid products appear in SQLite with an import summary dialog showing counts for accepted, updated, and rejected items.

**Acceptance Scenarios**:

1. **Given** an offline mobile device and an Excel sheet with plumbing items (columns: Code, Arabic Name, Category, Unit, Price in EGP), **When** the user taps "Import Excel" and selects the file, **Then** the app parses the workbook transactionally, inserts valid products into local SQLite, and shows an Arabic summary modal with counts of newly added, updated, and skipped/rejected rows.
2. **Given** an Excel file containing duplicate product codes or unparseable price rows, **When** the import processes the file, **Then** valid rows are preserved, existing codes are updated without duplicate key violation, invalid rows are reported with line numbers and reasons in an error log, and the database remains consistent.
3. **Given** an empty, password-protected, or corrupted Excel file, **When** the user attempts import, **Then** the app aborts without corrupting existing catalog data, shows a clear localized Arabic error message, and logs diagnostic details safely without sensitive data.

---

### User Story 2 - Instant Arabic Product Search & Filter (Priority: P1)

As a counter salesman, I want to quickly search products while typing using colloquial Arabic terms, fractional pipe sizes (e.g., 1/2", 3/4", ١/٢"), and category filters, so that I can look up plumbing materials in seconds during customer inquiries.

**Why this priority**: Plumbing stores stock thousands of similar fittings (elbows, tees, adapters, valves) with subtle size distinctions. Rapid, resilient Arabic search is essential for day-to-day usability.

**Independent Test**: Can be tested by searching for products with varied Arabic spelling, mixed Latin/Arabic dimensions (e.g., "كوع 1/2", "كوع ١/٢", "PPR"), and filtering by category (e.g., "تغذية", "صرف", "محابس"), verifying that matching items appear within 100 ms with highlighted matches.

**Acceptance Scenarios**:

1. **Given** a catalog containing plumbing items, **When** the user enters search queries containing Arabic-Indic digits (e.g., "ماسورة ١ بوصة") or Western digits ("ماسورة 1 بوصة"), **Then** the search normalizes numerals and returns matching items interchangeably.
2. **Given** common Arabic orthographic variations (e.g., أ / إ / ا, ة / ه, ى / ي), **When** the user types without exact diacritics or letter normalization, **Then** search results match resiliently.
3. **Given** a selected category filter (e.g., "لوازم بولي بروبلين"), **When** the user applies the filter, **Then** only products within that category are displayed, sorted alphabetically or by code.

---

### User Story 3 - Manual Product Creation, Editing, and Price Updates (Priority: P2)

As a shop manager, I want to manually add a new product or adjust the price/unit of an existing product directly in the app, so that I can quickly reflect price changes or add unlisted items without re-importing the entire Excel spreadsheet.

**Why this priority**: Prices in the building and plumbing materials market fluctuate frequently. Counter staff must be able to update individual item prices on the fly.

**Independent Test**: Can be tested by adding a single new item through the product form, editing its price, and verifying that the updated values persist across app restarts and database queries.

**Acceptance Scenarios**:

1. **Given** the products list screen, **When** the user taps the "Add Product" button, enters required fields (Code, Arabic Name, Category, Unit, Unit Price), and saves, **Then** the product is validated, stored in SQLite with integer minor units (piastres), and immediately reflected in the catalog list.
2. **Given** an existing product, **When** the user edits the unit price or name and saves, **Then** the updated values are committed transactionally, with the last modified timestamp updated.
3. **Given** an invalid input (e.g., negative price, empty name, or duplicate product code), **When** the user attempts to save, **Then** inline Arabic validation errors appear and the database is not modified.

---

### User Story 4 - Catalog Export & Audit Inspection (Priority: P3)

As a business owner, I want to view catalog statistics (total items, categories count, last import date) and export the active catalog to a clean spreadsheet file on the device, so that I have a local backup of my updated price list.

**Why this priority**: Provides transparency and data portability for the user, reinforcing the local data ownership principle.

**Independent Test**: Can be tested by navigating to catalog management settings/audit, viewing aggregate counts, and exporting to a local file, confirming file validity offline.

**Acceptance Scenarios**:

1. **Given** an populated catalog, **When** the user accesses catalog info, **Then** total product count, active categories, and timestamp of the last import/modification are displayed.
2. **Given** an active catalog, **When** the user chooses "Export Catalog", **Then** a standardized Excel file is written to device storage without any external network dependency.

---

### Edge Cases

- **Massive Spreadsheet**: What happens when an Excel file has over 10,000 rows?
  - The import process runs in a background isolate or batched chunks (e.g., 200 rows per transaction chunk) with an Arabic progress indicator (percentage + row count) without freezing the UI thread or exceeding memory limits.
- **Header Mismatch**: What happens if the Excel file headers do not exactly match "كود", "الاسم", "السعر"?
  - The parser scans for common synonyms (e.g., "الكود" / "رقم الصنف" / "Code", "اسم الصنف" / "الوصف" / "Name", "السعر" / "سعر الوحدة" / "Price") or provides a simple column-mapping confirmation step before execution.
- **Fractional / Non-numeric Prices**: How are prices like "15.5", "15,50", or "15 ج.م" handled?
  - Price strings are cleaned, commas converted to decimal points, and parsed to integer piastres (e.g., 15.50 -> 1550 piastres). If a price is completely unparseable or blank, the row is flagged as rejected with a clear explanation.
- **Duplicate Codes in Same Sheet**: What if row 50 and row 120 share the same item code?
  - The last encountered row updates the previous one, and the import report logs that a duplicate code was resolved with the later values.
- **Zero or Negative Prices**: Can products have price = 0?
  - Price = 0 is permitted (e.g., for custom items priced upon request), but negative prices are strictly rejected.
- **Device Interruption / Crash during Import**: What happens if the user leaves the app or the battery dies mid-import?
  - Each chunk is committed transactionally. A failed or interrupted import leaves previously committed batches intact and does not corrupt SQLite integrity.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide an offline Excel parser supporting `.xlsx` (OpenXML) and `.xls` (BIFF8) files from local device storage without cloud converters or network access.
- **FR-002**: System MUST persist products in a dedicated, indexed Drift/SQLite table (`products` and optional `categories`) within the existing encrypted/private local database.
- **FR-003**: System MUST store monetary values (unit prices) as deterministic integer minor units (piastres / قروش, where 1 EGP = 100 piastres) to prevent floating-point calculation errors.
- **FR-004**: System MUST record the following attributes for every product: unique product code (string), Arabic name (string), category (string), unit of measure (e.g., قطعة, متر, كيس, لفة, طقم), unit price in piastres (integer), barcode/SKU (optional string), notes (optional string), and last updated timestamp (ISO-8601).
- **FR-005**: System MUST perform Excel imports transactionally in batches, reporting exact counts of: total rows, accepted new rows, updated existing rows, and rejected rows.
- **FR-006**: System MUST generate an import audit summary surfacing any rejected rows with row number and failure reason (e.g., missing name, negative price).
- **FR-007**: System MUST provide a fast, responsive search interface returning filtered product results in ≤100 ms on a catalog of up to 10,000 items.
- **FR-008**: System MUST normalize Arabic search queries to match regardless of diacritics, Alef variants (أ / إ / آ / ا), Taa Marbouta (ة / ه), Yaa (ي / ى), and numerals (Eastern Arabic ١٢٣ vs Western Arabic 123).
- **FR-009**: System MUST allow filtering products by category and sorting by name, price, or recently modified.
- **FR-010**: System MUST provide forms for manual creation, updating, and deletion of individual products with full Arabic validation rules.
- **FR-011**: System MUST enforce unique product codes; attempting to create an item with an existing code MUST fail with a clear validation error.
- **FR-012**: System MUST replace the current unavailable placeholder screen (`features/products/presentation/products_screen.dart`) with the fully functional Arabic catalog management UI.
- **FR-013**: System MUST allow exporting the local SQLite catalog to an Excel file (`.xlsx`) saved to local device documents or shared via platform sheet.
- **FR-014**: System MUST perform all heavy file parsing and batch insertions in a background worker isolate to ensure 60fps UI responsiveness.

### Key Entities

- **Product**:
  - `id`: Auto-incrementing primary key (integer).
  - `code`: Unique business identifier or shop code (string, e.g., "PPR-20-ELB").
  - `name`: Arabic product title/description (string, e.g., "كوع لحام 20 مم زاوية 90 درجة").
  - `category`: Classification group (string, e.g., "مواسير ولوازم بولي", "خلاطات ومحابس", "صرف صحي").
  - `unit`: Unit of sale (string, e.g., "قطعة", "متر", "طقم", "لفة").
  - `unitPricePiastres`: Price per unit in integer piastres (integer, non-negative).
  - `barcode`: Optional barcode/EAN string.
  - `notes`: Optional description or brand notes (string).
  - `createdAt`: Creation timestamp.
  - `updatedAt`: Last modification timestamp.
- **ImportSummary**:
  - `totalRows`: Number of data rows processed.
  - `insertedCount`: Number of new products added.
  - `updatedCount`: Number of existing products updated.
  - `rejectedCount`: Number of invalid/skipped rows.
  - `errors`: List of row-level error details (row number, raw value, error reason).
  - `importedAt`: Timestamp of the import run.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An Excel spreadsheet containing 1,000 plumbing items is parsed, validated, and persisted into local SQLite in under 3 seconds on reference hardware.
- **SC-002**: Product search queries on a 5,000-item catalog return filtered results to the UI in under 100 milliseconds.
- **SC-003**: 100% of price values in database and UI match exact integer minor unit conversions with zero floating-point drift (e.g., 25.50 EGP is exactly 2550 piastres).
- **SC-004**: Arabic search queries with mixed numerals (e.g., "كوع ١/٢" and "كوع 1/2") or alternate letter forms return identical expected match sets.
- **SC-005**: 100% of operations function completely offline with zero network permissions or external calls.
- **SC-006**: During Excel import of any size, the UI remains responsive (60 fps, zero ANR or frame freeze > 16 ms) via isolate offloading.

---

## Assumptions

- Users have Excel files stored locally on device (Internal Storage, Downloads, or SD Card) accessible via native file picker.
- Catalog spreadsheets contain at minimum: product name and unit price. Product code can be auto-generated if omitted in the source spreadsheet.
- The standard currency for the initial domain is Egyptian Pound (EGP / ج.م), represented in piastres (1 EGP = 100 piastres).
- A catalog size for typical plumbing retail shops ranges from 500 to 10,000 active items.
- Excel file parsing is handled using an offline Dart package (e.g., `excel`) verified against licensing and offline rules.
