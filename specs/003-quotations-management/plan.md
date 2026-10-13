# Implementation Plan: Quotations Management & Deterministic Pricing Engine (003)

## Technical Architecture

- **Domain Layer (`features/quotations/domain`)**:
  - `Quotation`, `QuotationItem`, `QuotationStatus`, `QuotationDraft`, `QuotationItemDraft`.
  - `QuotationRepository` interface.
  - `PricingCalculator`: Pure arithmetic logic for line totals, subtotal, and grand total in integer piastres.
  - Zero external package dependencies.

- **Data Layer (`features/quotations/data`)**:
  - Drift tables: `QuotationsTable` and `QuotationItemsTable` in `lib/core/database/tables/`.
  - Drift database schema migration from v2 to v3 in `lib/core/database/migrations/migration_strategy.dart`.
  - `DriftQuotationRepository`: Transactional database queries, cascade deletes, yearly sequential reference generator (`QT-YYYY-####`).

- **Application Layer (`features/quotations/application`)**:
  - `QuotationsController`: StateNotifier managing quotations stream, status filter, and metrics.
  - `QuotationFormController`: StateNotifier managing in-progress quotation creation/editing, line item mutations, catalog picker coordination, and live total recalculation.

- **Presentation Layer (`features/quotations/presentation`)**:
  - `QuotationsScreen`: Displays quotation list, metrics header, status filter chips, and new quotation FAB.
  - `QuotationCard`: Displays quotation reference, customer name, date, items summary, status badge, and total in EGP.
  - `QuotationFormScreen`: Full-screen RTL quotation builder with customer inputs, line items table/list, catalog product selector dialog, line discount, global discount, and live price summary card.
  - `QuotationDetailScreen`: Read-only view for finalized quotations with status advancement actions.

---

## Phase Breakdown

1. **Phase 1: Setup & Domain Foundations**
   - Pure domain models (`Quotation`, `QuotationItem`, `QuotationStatus`).
   - Pure `PricingCalculator` with comprehensive unit tests for integer rounding and clamping.
2. **Phase 2: Database Schema v3 & Migration**
   - Define `QuotationsTable` and `QuotationItemsTable`.
   - Update `AppDatabase` to `schemaVersion = 3` and add forward-only migration.
   - Run `build_runner` and dump `drift_schema_v3.json`.
   - Write Drift migration test `migration_v3_test.dart`.
3. **Phase 3: User Story 1 — Quotation Creation & Pricing (MVP)**
   - Implement `DriftQuotationRepository` (transactional create, reference generation).
   - Implement `QuotationFormController`.
   - Implement `QuotationFormScreen` with catalog product picker and line items table.
   - Unit & widget tests.
4. **Phase 4: User Story 2 — Quotations List & Status Lifecycle**
   - Implement `QuotationsController` and `QuotationCard`.
   - Wire interactive `QuotationsScreen` replacing the placeholder.
   - Widget tests for listing, status chip filtering, and status advancement.
5. **Phase 5: User Story 3 — Draft Editing & Finalization Snapshot**
   - Support loading existing draft into `QuotationFormScreen`.
   - Implement finalization locking and verify product deletion/editing does not mutate snapshot.
6. **Phase 6: User Story 4 — Quotation Duplication & Summary Metrics**
   - Implement `duplicateQuotation` and metrics calculation.
   - Wire duplication action and header metrics in `QuotationsScreen`.
7. **Phase 7: Localization, Quality Gates & Polish**
   - Add all Arabic quotation strings to `app_ar.arb`.
   - Register Riverpod providers in `providers.dart`.
   - Run quality gates (`dart format`, `flutter analyze`, `flutter test`).
