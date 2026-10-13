# Implementation Plan: Catalog & Product Management

**Branch**: `002-catalog-management` | **Date**: 2026-10-13 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/002-catalog-management/spec.md`

## Summary

Implement 100% offline plumbing products catalog management for the offline quotation app. Upgrade Drift database schema from version 1 to 2 by adding an indexed `products` table with deterministic integer piastres pricing and pre-computed normalized Arabic search text. Introduce a background-isolate Excel parsing engine using `excel: ^4.0.6` that validates workbook rows, handles batch upserts, and generates detailed row-level error reports. Replace the placeholder screen in `lib/features/products/presentation/products_screen.dart` with an accessible RTL Arabic product list, instant sub-100ms search/filtering, product creation/editing dialogs, and native file import/export via `file_picker`.

## Technical Context

**Language/Version**: Dart 3.13.4 with Flutter 3.47.5 stable

**Primary Dependencies**: `flutter_riverpod` ^3.4.3, `drift` ^2.35.2, `drift_flutter` ^0.3.1, `excel` ^4.0.6, `file_picker` ^13.1.0, `path_provider` ^2.1.6, `path` ^1.9.1, `intl` ^0.20.3

**Development Dependencies**: `drift_dev` ^2.35.1, `build_runner` ^2.16.2, `flutter_test`, `flutter_lints` ^6.0.0

**Storage**: SQLite through Drift; versioned forward-only migration from schema v1 to v2; transactional batch insertion (200 items per chunk); indexed by code, category, and normalized search text.

**Testing**: Unit tests (parsers, normalizer, repository), Drift migration tests (v1 -> v2), widget tests (products list, search bar, add/edit form, import modal), and performance benchmarks (1k rows import, 5k rows search).

**Target Platform**: Android 8+ (API 26+) and iOS 15+

**Project Type**: Mobile application

**Performance Goals**:
- Import 1,000 plumbing items in under 3 seconds on reference device.
- Instant search response in under 100 ms across 5,000 items.
- UI maintains 60 fps during background isolate Excel parsing.

**Constraints**:
- 100% Offline (no network access, telemetry, or remote converters).
- Arabic-first RTL baseline.
- Deterministic integer minor units (piastres / قروش, `unit_price_piastres >= 0`).
- No silent data loss during import; unparseable rows surfaced in summary report.

**Scale/Scope**: Catalogs up to 10,000 items per shop.

## Constitution Check

### Pre-design gate

| Principle | Planned evidence | Result |
|---|---|---|
| I. 100% Offline | `excel` is pure Dart; `file_picker` uses platform file picker intents; zero HTTP endpoints | PASS |
| II. Cross-Platform | Shared Flutter code; tested on standard Android and iOS platform abstractions | PASS |
| III. Local Data Ownership | Excel files imported into local SQLite; catalog exportable back to device `.xlsx` | PASS |
| IV. Data Integrity | Schema migration v1 -> v2 with rollback protection; batch transactions; import errors surfaced | PASS |
| V. Deterministic Finance | Stored as integer piastres; display formatting strictly decimal without floating-point math | PASS |
| VI. AI Reliability | N/A (no AI or OCR in this feature) | PASS |
| VII. Human-in-the-Loop | User triggers file import; reviewable summary report before and after import | PASS |
| VIII. Arabic-First Experience | RTL layout, Arabic-first plumbing search, Tashkeel/Alef/numeral normalization | PASS |
| IX. Modular Architecture | `features/products` domain/data/application/presentation strictly decoupled; no cross-feature imports | PASS |
| X. Comprehensive Verification | Migration tests, parser tests, widget tests, search normalizer tests | PASS |
| XI. Security & Privacy | No telemetry; imported files remain in protected local sandbox; logs redacted | PASS |
| XII. Spec-Driven Development | Spec, plan, contracts, data model preceding code | PASS |
| XIII. Maintainable Simplicity | Drift and Riverpod existing patterns reused; no extra code generation frameworks | PASS |
| XIV. Living Project Documentation | System docs and quickstart updated | PASS |
| XV. Incremental Delivery | Catalog feature isolated; quotations and OCR deferred to future features | PASS |

### Post-design gate

All design contracts (`catalog_repository.md`, `excel_importer.md`, `data-model.md`) satisfy the constitutional principles. All gates remain **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/002-catalog-management/
├── plan.md
├── spec.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── catalog_repository.md
│   └── excel_importer.md
└── checklists/requirements.md
```

### Source Code

```text
lib/
├── core/database/
│   ├── app_database.dart                 # Updated with Products table & schemaVersion = 2
│   ├── migrations/
│   │   └── migration_strategy.dart       # Migration step from v1 to v2
│   └── tables/
│       └── products_table.dart           # Drift Products table definition
├── features/products/
│   ├── domain/
│   │   ├── product.dart                  # Immutable domain entity
│   │   ├── import_summary.dart           # Import result and error types
│   │   └── catalog_repository.dart       # Domain repository interface
│   ├── data/
│   │   ├── drift_catalog_repository.dart # Drift implementation with batch transactions
│   │   ├── excel_importer.dart           # Background isolate Excel parser & exporter
│   │   └── arabic_search_normalizer.dart # Arabic orthographic & numeral normalizer
│   ├── application/
│   │   ├── catalog_controller.dart       # Riverpod state notifier for product list & filters
│   │   └── import_controller.dart        # Controller managing file picking & import progress
│   └── presentation/
│       ├── products_screen.dart          # Main products catalog screen (replaces placeholder)
│       └── widgets/
│           ├── product_card.dart         # Arabic product item tile
│           ├── product_search_bar.dart   # Instant search field with category chips
│           ├── product_form_dialog.dart  # Add/edit product modal
│           └── import_summary_dialog.dart# Import result & error report modal
└── l10n/
    └── app_ar.arb                        # Arabic strings for products, import, and search
```

## Architecture Decisions

1. **Background Isolate Excel Parsing**: Using `Isolate.run()` to unzip and traverse Excel sheets prevents any frame stutter on the main UI thread during 5,000+ row workbook processing.
2. **Normalized Search Text Column**: Storing a pre-normalized string on each product row enables fast, indexed SQLite `LIKE` queries with identical matching for Arabic variations (`أ/ا`, `ة/ه`, `١/٢` vs `1/2`).
3. **Integer Piastres Currency**: Unit prices are strictly integers representing piastres (`EGP * 100`). Formatting utilities handle decimal rendering for display.
4. **Drift Schema Forward Migration**: Migrating from schema version 1 to 2 creates the `products` table and indices transactionally without affecting `app_settings`.

## Complexity Tracking

No constitutional violations. All patterns follow established architecture from `001-project-foundation`.
