# Data Model: Catalog & Product Management (002-catalog-management)

**Date**: 2026-10-13
**Feature**: [spec.md](./spec.md)

## Domain Entities

### 1. `Product`

Represents an individual sellable item in the plumbing supplies catalog.

| Attribute | Type | Nullable | Description | Validation / Constraints |
|---|---|---|---|---|
| `id` | `int` | No | Internal database primary key | Positive integer, auto-generated |
| `code` | `String` | No | Shop/supplier item code | 1–64 characters, unique, non-empty, trimmed |
| `name` | `String` | No | Full Arabic product description | 1–255 characters, non-empty, trimmed |
| `category` | `String` | No | Classification category name | 1–100 characters, non-empty |
| `unit` | `String` | No | Unit of measure (قطعة, متر, ...) | 1–32 characters, non-empty |
| `unitPricePiastres` | `int` | No | Unit price in integer piastres | Non-negative integer (`>= 0`) |
| `normalizedSearchText` | `String` | No | Pre-computed normalized search string | Normalized combining code, name, category, barcode |
| `barcode` | `String?` | Yes | Optional EAN/UPC barcode | Alphanumeric string |
| `notes` | `String?` | Yes | Additional notes / supplier info | Max 1000 characters |
| `createdAt` | `DateTime` | No | Timestamp of creation | Utc timestamp |
| `updatedAt` | `DateTime` | No | Timestamp of last modification | Utc timestamp |

---

### 2. `ImportSummary`

Summary record produced after an Excel workbook import run.

| Attribute | Type | Nullable | Description |
|---|---|---|---|
| `totalRows` | `int` | No | Total data rows parsed from workbook |
| `insertedCount` | `int` | No | Number of newly added products |
| `updatedCount` | `int` | No | Number of existing products updated |
| `rejectedCount` | `int` | No | Number of skipped or invalid rows |
| `errors` | `List<ImportRowError>` | No | Row-level validation failure details |
| `importedAt` | `DateTime` | No | Timestamp when the import completed |
| `durationMs` | `int` | No | Execution elapsed time in milliseconds |

---

### 3. `ImportRowError`

Error item recording a row that could not be imported.

| Attribute | Type | Nullable | Description |
|---|---|---|---|
| `rowNumber` | `int` | No | 1-based row index in the Excel spreadsheet |
| `rawCode` | `String?` | Yes | Value in the code column (if any) |
| `rawName` | `String?` | Yes | Value in the name column (if any) |
| `rawPrice` | `String?` | Yes | Value in the price column (if any) |
| `reason` | `String` | No | Localized failure reason (e.g., missing name, negative price) |

---

## SQLite / Drift Schema Definition

### Schema Version: 2

```sql
CREATE TABLE products (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    unit TEXT NOT NULL,
    unit_price_piastres INTEGER NOT NULL CHECK (unit_price_piastres >= 0),
    normalized_search_text TEXT NOT NULL,
    barcode TEXT,
    notes TEXT,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
);

CREATE UNIQUE INDEX idx_products_code ON products(code);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_search ON products(normalized_search_text);
```

### Constraints & Invariants
- `code` must be unique across all active products.
- `unit_price_piastres` is non-negative (`CHECK (unit_price_piastres >= 0)`).
- When a product is updated, `updated_at` must be set to the current UTC timestamp, and `normalized_search_text` must be recalculated.
