# Implementation Tasks: Catalog & Product Management (002-catalog-management)

**Branch**: `002-catalog-management` | **Date**: 2026-10-13 | **Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)

## Phase 1: Setup & Dependencies

**Purpose**: Add approved offline packages and verify dependency tree.

- [x] T001 Add `excel: ^4.0.6` and `file_picker: ^13.1.0` to `pubspec.yaml` and run `flutter pub get`.

---

## Phase 2: Foundational (Database Schema v2 & Core Domain)

**Purpose**: Database schema migration, core entities, and Arabic normalization required by all user stories.

- [x] T002 [P] Create domain entities `Product`, `ProductDraft`, `ImportSummary`, and `ImportRowError` in `lib/features/products/domain/product.dart` and `lib/features/products/domain/import_summary.dart`.
- [x] T003 [P] Define `CatalogRepository` interface in `lib/features/products/domain/catalog_repository.dart`.
- [x] T004 Define Drift `ProductsTable` in `lib/core/database/tables/products_table.dart` with integer piastres and indices on code, category, and normalized search text.
- [x] T005 Update `AppDatabase` (`schemaVersion = 2`) in `lib/core/database/app_database.dart` and migration strategy in `lib/core/database/migrations/migration_strategy.dart` for forward-only migration from v1 to v2.
- [x] T006 Run `build_runner` code generation to update `app_database.g.dart` and dump `drift_schemas/drift_schema_v2.json`.
- [x] T007 Implement Arabic text and numeral normalizer in `lib/features/products/data/arabic_search_normalizer.dart` and unit test in `test/features/products/data/arabic_search_normalizer_test.dart`.
- [x] T008 Create Drift migration test in `test/core/database/migrations/migration_v2_test.dart` verifying migration from v1 preserves `app_settings` and creates `products`.

**Checkpoint**: Database schema v2 is migrated and verified. Domain models and Arabic normalizer are ready.

---

## Phase 3: User Story 1 — Import Plumbing Catalog from Excel (Priority: P1) 🎯 MVP

**Goal**: Shop owners can import `.xlsx` workbooks offline in a background isolate and view a complete import summary report.

**Independent Test**: Run `test/features/products/data/excel_importer_test.dart` and `test/features/products/data/drift_catalog_repository_test.dart` to verify that sample plumbing workbooks are parsed, validated, and persisted into SQLite with exact counts.

- [x] T009 [P] [US1] Write unit tests for background isolate Excel parsing in `test/features/products/data/excel_importer_test.dart`.
- [x] T010 [US1] Implement background isolate Excel parser and validator in `lib/features/products/data/excel_importer.dart`.
- [x] T011 [US1] Implement `DriftCatalogRepository` in `lib/features/products/data/drift_catalog_repository.dart` with transactional batch upserting (200 rows per batch) and write tests in `test/features/products/data/drift_catalog_repository_test.dart`.
- [x] T012 [US1] Implement `ImportController` with progress notification and file picker coordination in `lib/features/products/application/import_controller.dart`.
- [x] T013 [US1] Implement `ImportSummaryDialog` in `lib/features/products/presentation/widgets/import_summary_dialog.dart` showing accepted, updated, and rejected rows with Arabic error details.

**Checkpoint**: User Story 1 is functional: Excel workbooks can be picked, parsed in background isolates, and saved into SQLite with error reporting.

---

## Phase 4: User Story 2 — Instant Arabic Product Search & Filter (Priority: P1)

**Goal**: Counter salesmen can instantly search plumbing materials using Arabic text, pipe dimensions (e.g. 1/2", ١/٢"), and category filters in under 100 ms.

**Independent Test**: Run `test/features/products/presentation/product_search_test.dart` to verify sub-100ms normalized search and category filtering across catalog fixtures.

- [x] T014 [P] [US2] Write unit and widget tests for instant search and filtering in `test/features/products/presentation/product_search_test.dart`.
- [x] T015 [US2] Implement `CatalogController` state notifier managing search query, category filter, and product stream in `lib/features/products/application/catalog_controller.dart`.
- [x] T016 [US2] Implement `ProductCard` in `lib/features/products/presentation/widgets/product_card.dart` displaying code, Arabic title, category, unit, and formatted EGP price.
- [x] T017 [US2] Implement `ProductSearchBar` with instant search input and horizontal category filter chips in `lib/features/products/presentation/widgets/product_search_bar.dart`.
- [x] T018 [US2] Replace placeholder `ProductsScreen` in `lib/features/products/presentation/products_screen.dart` with interactive product catalog list, empty state, and floating actions.

**Checkpoint**: User Story 2 is functional: instant Arabic search, category filtering, and product cards are interactive and testable.

---

## Phase 5: User Story 3 — Manual Product Creation, Editing, and Price Updates (Priority: P2)

**Goal**: Shop managers can manually create, edit, or adjust the price of any plumbing product with inline Arabic validation.

**Independent Test**: Run `test/features/products/presentation/product_form_test.dart` to verify adding, editing, and deleting a product with piastre conversions and validation error handling.

- [x] T019 [P] [US3] Write widget tests for product creation and editing form in `test/features/products/presentation/product_form_test.dart`.
- [x] T020 [US3] Implement `ProductFormDialog` in `lib/features/products/presentation/widgets/product_form_dialog.dart` with input validation (code uniqueness, positive price, required fields).
- [x] T021 [US3] Wire add, edit, and delete flows into `CatalogController` and `ProductsScreen`.

**Checkpoint**: User Story 3 is functional: manual additions and updates persist to SQLite with transactional safety.

---

## Phase 6: User Story 4 — Catalog Export & Audit Inspection (Priority: P3)

**Goal**: Business owners can inspect catalog metrics (total items, category breakdown) and export the active catalog to a local Excel file.

**Independent Test**: Run `test/features/products/data/excel_exporter_test.dart` to verify generating a valid `.xlsx` file from the database.

- [x] T022 [P] [US4] Write unit test for Excel export in `test/features/products/data/excel_exporter_test.dart`.
- [x] T023 [US4] Implement Excel export in `lib/features/products/data/excel_importer.dart` and wire export action button in `ProductsScreen`.

---

## Phase 7: Localization, Quality Gates & Polish

**Purpose**: Centralize Arabic strings, register Riverpod providers, and run comprehensive static and automated gates.

- [x] T024 [P] Add all Arabic strings (labels, categories, errors, units) to `lib/l10n/app_ar.arb` and generate localizations.
- [x] T025 Register `catalogRepositoryProvider`, `catalogControllerProvider`, and `importControllerProvider` in `lib/app/bootstrap/providers.dart`.
- [x] T026 Run static analysis, formatting, and the full test suite (`dart format`, `flutter analyze`, `flutter test`), verifying zero warnings and 100% test pass.

---

## Dependencies & Execution Order

```text
Phase 1 (Setup)
  -> Phase 2 (Foundational: Schema v2, Entities, Normalizer)
      -> Phase 3 (US1: Excel Import Engine) [MVP]
      -> Phase 4 (US2: Arabic Search & Catalog UI)
          -> Phase 5 (US3: Manual Add / Edit Form)
          -> Phase 6 (US4: Excel Export)
              -> Phase 7 (Quality Gates & Polish)
```
