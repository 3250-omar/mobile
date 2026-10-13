# Implementation Tasks: Quotations Management & Pricing Engine (003-quotations-management)

**Branch**: `003-quotations-management` | **Date**: 2026-10-13 | **Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)

---

## Phase 1: Domain Foundations & Deterministic Pricing Engine

**Purpose**: Pure Dart domain models, status enum, and financial pricing calculator with integer arithmetic.

- [x] T001 [P] Create pure domain entities `Quotation`, `QuotationItem`, `QuotationStatus`, `QuotationItemDraft` in `lib/features/quotations/domain/quotation.dart`.
- [x] T002 [P] Implement pure `PricingCalculator` in `lib/features/quotations/domain/pricing_calculator.dart` and unit test in `test/features/quotations/domain/pricing_calculator_test.dart`.
- [x] T003 Define `QuotationRepository` interface contract in `lib/features/quotations/domain/quotation_repository.dart`.

---

## Phase 2: Database Schema v3 & Migration

**Purpose**: Relational SQLite storage for quotations and line items with snapshot support and migration from v2.

- [x] T004 Define Drift tables `QuotationsTable` and `QuotationItemsTable` in `lib/core/database/tables/quotations_table.dart`.
- [x] T005 Update `AppDatabase` (`schemaVersion = 3`) and `migration_strategy.dart` with forward-only migration from v2 to v3.
- [x] T006 Run `build_runner` to update `app_database.g.dart` and dump `drift_schemas/drift_schema_v3.json`.
- [x] T007 Write database migration test `test/core/database/migrations/migration_v3_test.dart` verifying that v2 products and settings are preserved.

---

## Phase 3: User Story 1 — Quotation Creation & Line Items (MVP) 🎯

**Goal**: Counter salesmen can create an offline quotation draft with customer details, pick items from the catalog, enter quantities, and save to SQLite.

- [x] T008 [P] [US1] Implement `DriftQuotationRepository` in `lib/features/quotations/data/drift_quotation_repository.dart` with transactional create, line items insertion, and sequential reference generation (`QT-YYYY-####`).
- [x] T009 [US1] Write unit and integration tests for repository in `test/features/quotations/data/drift_quotation_repository_test.dart`.
- [x] T010 [US1] Implement `QuotationFormController` state notifier managing draft building and line items in `lib/features/quotations/application/quotation_form_controller.dart`.
- [x] T011 [US1] Implement `QuotationFormScreen` in `lib/features/quotations/presentation/quotation_form_screen.dart` with customer input, catalog item picker, custom items, and totals summary card.
- [x] T012 [US1] Write widget tests for quotation creation in `test/features/quotations/presentation/quotation_form_test.dart`.

---

## Phase 4: User Story 2 — Quotations List & Status Lifecycle

**Goal**: Shop managers can browse saved quotations, filter by status, and advance status chips.

- [x] T013 [P] [US2] Implement `QuotationsController` managing list streaming and filter state in `lib/features/quotations/application/quotations_controller.dart`.
- [x] T014 [US2] Implement `QuotationCard` displaying quotation reference, customer, date, status chip, and EGP total in `lib/features/quotations/presentation/widgets/quotation_card.dart`.
- [x] T015 [US2] Replace placeholder `QuotationsScreen` in `lib/features/quotations/presentation/quotations_screen.dart` with interactive list, filter chips, and new quotation FAB.
- [x] T016 [US2] Write widget tests for listing and status updates in `test/features/quotations/presentation/quotations_list_test.dart`.

---

## Phase 5: User Story 3 — Draft Editing & Finalization Snapshot

**Goal**: Salesmen can edit drafts, lock approved quotations, and verify that catalog price changes never alter historical snapshots.

- [x] T017 [US3] Add edit mode to `QuotationFormScreen` and wire edit navigation from quotation cards.
- [x] T018 [US3] Implement quotation finalization locking (transition to `accepted`) and test snapshot immutability in `test/features/quotations/domain/snapshot_immutability_test.dart`.

---

## Phase 6: User Story 4 — Duplication & Summary Metrics

**Goal**: Quickly duplicate any quotation into a new draft and inspect summary metrics on the quotations screen.

- [x] T019 [US4] Implement `duplicateQuotation` and `getMetrics` in `DriftQuotationRepository`.
- [x] T020 [US4] Wire duplication action in `QuotationCard` and metrics summary bar in `QuotationsScreen`.

---

## Phase 7: Localization, Quality Gates & Polish

**Purpose**: Arabic localization strings, Riverpod providers registration, and complete verification across all static and automated gates.

- [x] T021 Add all quotation-related Arabic strings to `lib/l10n/app_ar.arb` and generate localizations (`flutter gen-l10n`).
- [x] T022 Register quotation repository, controllers, and router routes in `lib/app/bootstrap/providers.dart` and `lib/app/navigation/app_router.dart`.
- [x] T023 Run static analysis, formatting, and the complete test suite (`dart format`, `flutter analyze`, `flutter test`), verifying zero warnings and 100% test pass.
