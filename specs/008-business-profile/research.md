# Research & Architecture Decisions: 008-business-profile

## 1. Storage Strategy: Dedicated Singleton Table vs AppSettings Extension

- **Decision**: Dedicated `business_profiles` table with singleton `id = 1` in SQLite via Drift.
- **Rationale**: 
  - `AppSettings` is strictly scoped to application-level technical configurations (theme mode, locale, revision).
  - Business Profile contains business and legal domain data that logically belongs to commerce entities (quotations, invoices).
  - Isolating it into its own table and repository follows Single Responsibility Principle and avoids triggering unnecessary theme re-renders when business profile details are updated.
- **Alternatives Considered**:
  - Extending `app_settings_table`: Rejected because changing store phone or logo shouldn't dirty theme preferences state.

---

## 2. Logo Storage Strategy: Filesystem Sandbox vs SQLite BLOB

- **Decision**: Store image files in local sandboxed directory (`app_support_dir/profile/store_logo.png`) and persist the relative path in the database.
- **Rationale**:
  - SQLite WAL performance degrades with large binary blobs repeatedly queried on list/detail screens.
  - Image decoding from disk into Flutter's `Image.file` and `pdf.MemoryImage` is straightforward and memory-efficient.
  - Deleting/updating the logo simply replaces or removes the sandboxed file.
- **Alternatives Considered**:
  - SQLite BLOB column: Rejected due to unnecessary database bloat and performance penalties on backup/restore.
  - External photo gallery URI reference: Rejected because external files can be moved, edited, or deleted by users or system cleanup tools. Sandboxing guarantees persistence.

---

## 3. PDF Generator Header Integration

- **Decision**: Update `PdfQuotationGenerator.generatePdf` and `PdfInvoiceGenerator.generatePdf` to accept an optional `BusinessProfile? businessProfile` parameter, defaulting to null/generic fallback if unconfigured.
- **Rationale**:
  - Maintains backward compatibility with existing unit tests.
  - Allows injecting mock profiles during automated PDF rendering tests.
  - If `businessProfile?.logoBytes` is present, `pdf.Image(pdf.MemoryImage(bytes))` is added to the top right of the Arabic document header.
- **Alternatives Considered**:
  - Global service locator in PDF generator: Rejected by project constitution (manual Riverpod DI only).

---

## 4. Egyptian Bidirectional Number Formatting

- **Decision**: Apply `BidiText.wrapLtr()` on all phone numbers, Commercial Register, and Tax Card IDs.
- **Rationale**:
  - In Arabic RTL environments, phone numbers starting with `0` or containing spaces/dashes can suffer from digit inversion if not explicitly isolated with Unicode directional marks (LRE/PDF or LRM).
- **Alternatives Considered**:
  - Plain text strings: Causes inverted phone numbers (e.g. `010` appearing at the right end of the number).
