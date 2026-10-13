# Implementation Plan: 004-invoices-management

## Architecture & Principles Compliance
- **Constitution Principle I (100% Offline)**: All data stored in Drift SQLite. Zero external cloud or API calls.
- **Constitution Principle IV (Forward-Only Migrations)**: Safe upgrade from schema v3 to v4.
- **Constitution Principle V (Minor-Unit Currency)**: Strictly integer piastres (`1 EGP = 100 piastres`). Zero floating-point money calculations.
- **Constitution Principle VI (Clean Architecture & Manual Riverpod DI)**:
  - Domain layer: Zero framework dependencies.
  - Data layer: `DriftInvoiceRepository`.
  - Application layer: `InvoicesController`, `InvoiceFormController`.
  - Presentation layer: RTL Arabic UI with Material 3.

---

## Phase Breakdown

### Phase 1: Domain Entities & Repository Interface
- Define `Invoice`, `InvoiceItem`, `InvoicePayment`, `InvoiceStatus`, `PaymentMethod`, `InvoiceMetrics`, `InvoiceDraft`, and `PaymentDraft`.
- Define `InvoiceRepository` contract in `lib/features/invoices/domain/invoice_repository.dart`.
- Define `PdfInvoiceGenerator` contract in `lib/features/invoices/domain/pdf_invoice_generator.dart`.

### Phase 2: Schema v4 & Database Migration
- Create `lib/core/database/tables/invoices_table.dart` (`InvoicesTable`, `InvoiceItemsTable`, `InvoicePaymentsTable`).
- Bump `schemaVersion = 4` in `lib/core/database/app_database.dart`.
- Update `migration_strategy.dart` for v3 -> v4 forward migration.
- Generate `app_database.g.dart` and export `drift_schema_v4.json`.
- Write migration test in `test/core/database/migrations/migration_v4_test.dart`.

### Phase 3: Repository & Quotation Conversion (US1 & US2)
- Implement `DriftInvoiceRepository` with sequential reference number (`INV-YYYY-####`), transactional persistence, conversion from quotation, payments calculation, and dashboard metrics.
- Write unit/integration tests in `test/features/invoices/data/drift_invoice_repository_test.dart`.

### Phase 4: Payment Installments Recording (US3)
- Implement payment recording in repository: updates `paidAmountPiastres` and auto-transitions `status` (`unpaid` -> `partiallyPaid` -> `paid`).
- Add payment recording dialog/modal in presentation.

### Phase 5: 100% Offline Arabic PDF Generation (US4)
- Implement `DefaultPdfInvoiceGenerator` in `lib/features/invoices/data/pdf_invoice_generator.dart` using bundled Noto Sans Arabic fonts, QR code encoding offline metadata, itemized table, and payment breakdown.
- Write unit tests verifying PDF bytes generation in `test/features/invoices/data/pdf_invoice_generator_test.dart`.

### Phase 6: Interactive Presentation & UI (US1, US2, US3, US4)
- Implement `InvoicesController` in `lib/features/invoices/application/invoices_controller.dart`.
- Implement `InvoiceFormController` and `InvoiceFormScreen` in `lib/features/invoices/presentation/invoice_form_screen.dart`.
- Implement `InvoiceCard` in `lib/features/invoices/presentation/widgets/invoice_card.dart`.
- Replace placeholder `InvoicesScreen` in `lib/features/invoices/presentation/invoices_screen.dart` with interactive list, filter chips, summary metrics, and quick actions.
- Wire "تحويل إلى فاتورة" (Convert to Invoice) action inside Quotations screen/card!
- Write widget tests in `test/features/invoices/presentation/invoices_list_test.dart` and `invoice_form_test.dart`.

### Phase 7: Localization, Quality Gates & Verification
- Add all invoice Arabic strings to `lib/l10n/app_ar.arb` and generate localizations.
- Register all providers in `lib/app/bootstrap/providers.dart` and wire routes in `app_router.dart`.
- Run formatting, analysis, and complete test suite: verify 100% test pass.
