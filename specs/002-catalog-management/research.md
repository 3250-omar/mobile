# Research: Catalog & Product Management (002-catalog-management)

**Date**: 2026-10-13
**Feature**: [spec.md](./spec.md)

## Summary of Decisions

This research resolves the technical decisions for offline plumbing catalog management, Excel parsing, local SQLite schema migration (v1 -> v2), background isolate processing, and Arabic search normalization.

---

### Decision 1: Excel Parsing Library & Isolation

- **Choice**: `excel: ^4.0.6`
- **Rationale**:
  - Pure Dart implementation with zero native dependencies and zero network calls.
  - Compatible with Flutter 3.47.5 / Dart 3.13.4.
  - Parses OpenXML `.xlsx` files quickly and reliably.
  - MIT license, fully compliant with Constitution Principle XI & XIII.
- **Isolate Architecture**:
  - Parsing a 1,000–10,000 row spreadsheet involves unzipping XML files and building row matrices, which can take 500–2,000 ms.
  - To maintain 60 fps on low-end hardware (e.g., Pixel 2 API 26), parsing is dispatched to a background isolate using `Isolate.run()`.
  - The isolate accepts the file bytes/path and column mapping configuration, extracts rows, cleans/normalizes values, and returns a lightweight `RawCatalogData` object (list of raw row maps) to the main thread.

---

### Decision 2: Database Schema & Migration Strategy (Schema v1 -> v2)

- **Choice**: Drift forward-only migration from schema v1 to v2.
- **Schema Details**:
  - Table: `products`
    - `id`: integer, auto-incrementing primary key.
    - `code`: text, unique, indexed (`idx_products_code`).
    - `name`: text, not null.
    - `category`: text, not null, indexed (`idx_products_category`).
    - `unit`: text, not null.
    - `unit_price_piastres`: integer, not null, CHECK constraint `unit_price_piastres >= 0`.
    - `normalized_search_text`: text, not null, indexed (`idx_products_search`).
    - `barcode`: text, nullable.
    - `notes`: text, nullable.
    - `created_at`: integer (unix timestamp ms), not null.
    - `updated_at`: integer (unix timestamp ms), not null.
- **Migration Execution**:
  - In `MigrationStrategy`:
    - Version increases from 1 to 2.
    - `onUpgrade`: when `from == 1`, call `await m.createTable(products);` and create indices.
  - Schema snapshot: export `drift_schema_v2.json` into `drift_schemas/` and test migration from v1 snapshot.

---

### Decision 3: Arabic Search & Numeral Normalization

- **Problem**: SQLite standard `LIKE` operator does not perform Unicode case-folding or Arabic letter normalization (e.g., `أ` does not match `ا`, and `١/٢` does not match `1/2`). SQLite ICU extensions cannot be assumed on all Android OEM distributions and iOS versions.
- **Choice**: Dual-layer normalization with indexed `normalized_search_text` column.
- **Algorithm**:
  - When saving or importing a product, generate `normalized_search_text` combining `name`, `code`, `category`, and `barcode`.
  - Normalization steps:
    1. Strip Tashkeel (Arabic diacritics: `[\u064B-\u065F\u0670]`).
    2. Normalize Alef forms: `[أإآٱ]` -> `ا`.
    3. Normalize Taa Marbouta: `ة` -> `ه`.
    4. Normalize Yaa / Alef Maksura: `ى` -> `ي`.
    5. Normalize Eastern Arabic numerals: `[٠-٩]` -> `0-9`.
    6. Normalize fractions and pipe symbols: `١/٢` -> `1/2`, `٣/٤` -> `3/4`, `بوصة` -> `بوصة`.
    7. Convert Latin characters to lowercase.
  - When the user searches: apply the exact same normalization function to the query string.
  - Query: `SELECT * FROM products WHERE normalized_search_text LIKE ?` (with wildcards `%query%`).
  - Result: instant sub-50ms matching regardless of diacritics, numeral styles, or letter spellings.

---

### Decision 4: Batch Import & Transaction Safety

- **Batch Size**: 200 rows per transaction.
- **Behavior**:
  - If a code matches an existing product in SQLite, it executes an `INSERT OR REPLACE` (upsert) or update query, incrementing `updatedCount`.
  - If a code does not exist, it inserts a new row, incrementing `insertedCount`.
  - If a row has an unparseable price, missing name, or negative value, it is skipped and logged to `rejectedRows` with the exact Excel row number and failure description.
  - After all batches complete, an `ImportSummary` is returned and presented to the user in a non-dismissible Arabic dialog.

---

### Decision 5: File Picking on Mobile

- **Choice**: `file_picker: ^13.1.0`
- **Capabilities**:
  - Strictly local file picking (`FileType.custom`, allowed extensions: `['xlsx', 'xls']`).
  - No network access, no background upload, no cloud tracking.
  - Uses native Android `ACTION_OPEN_DOCUMENT` and iOS `UIDocumentPickerViewController`.
  - Graceful fallback if user cancels.

---

### Decision 6: Deterministic Financial Representation

- **Choice**: Integer minor units (Piastres / قروش).
- **Rule**:
  - 1 EGP (جنيه مصري) = 100 Piastres (قروش).
  - Stored in database as integer `unit_price_piastres`.
  - Conversions:
    - User types `15.50` -> parsed to `1550`.
    - Database `1550` -> formatted to `15.50 ج.م` (or localized Arabic numerals `١٥٫٥٠ ج.م` based on preference).
  - Floating point `double` is never used for persistence, arithmetic, or financial accumulation.
