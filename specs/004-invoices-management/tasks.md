# Tasks: 004-invoices-management

## Phase 1: Domain Entities & Contracts
- [x] T001 [P] Create domain entities (`Invoice`, `InvoiceItem`, `InvoicePayment`, `InvoiceStatus`, `PaymentMethod`, `InvoiceMetrics`) in `lib/features/invoices/domain/invoice.dart`.
- [x] T002 [P] Create `InvoiceRepository` contract in `lib/features/invoices/domain/invoice_repository.dart`.
- [x] T003 [P] Create `PdfInvoiceGenerator` contract in `lib/features/invoices/domain/pdf_invoice_generator.dart`.

## Phase 2: Schema v4 & Database Migration
- [x] T004 [P] Create Drift tables `InvoicesTable`, `InvoiceItemsTable`, `InvoicePaymentsTable` in `lib/core/database/tables/invoices_table.dart`.
- [x] T005 Update `AppDatabase` to schema version 4 and register tables.
- [x] T006 Update `MigrationStrategy` for forward-only migration v3 -> v4 and dump `drift_schema_v4.json`.
- [x] T007 Write schema v4 migration test in `test/core/database/migrations/migration_v4_test.dart`.

## Phase 3: Repository & Quotation Conversion (US1 & US2)
- [x] T008 [P] Implement `DriftInvoiceRepository` in `lib/features/invoices/data/drift_invoice_repository.dart` with sequential reference numbering (`INV-YYYY-####`), transactional persistence, and metrics.
- [x] T009 Implement quotation conversion: copies items, links `quotationId`, and marks quotation `convertedToInvoice`.
- [x] T010 Write unit/integration tests for `DriftInvoiceRepository` in `test/features/invoices/data/drift_invoice_repository_test.dart`.

## Phase 4: Payment Installments Recording (US3)
- [x] T011 Implement `recordPayment` in `DriftInvoiceRepository` with automatic status transition (`unpaid` -> `partiallyPaid` -> `paid`).
- [x] T012 Write tests for payment recording and balance due calculations in repository tests.

## Phase 5: 100% Offline Arabic PDF Generation (US4)
- [x] T013 [P] Implement `DefaultPdfInvoiceGenerator` in `lib/features/invoices/data/pdf_invoice_generator.dart` using bundled Noto Sans Arabic fonts, itemized table, totals, payments, and offline QR code.
- [x] T014 Write unit test for PDF generator in `test/features/invoices/data/pdf_invoice_generator_test.dart`.

## Phase 6: Presentation & User Interface (US1, US2, US3, US4)
- [x] T015 [P] Create `InvoicesController` managing reactive list, status filtering, and metrics in `lib/features/invoices/application/invoices_controller.dart`.
- [x] T016 Create `InvoiceFormController` and `InvoiceFormScreen` in `lib/features/invoices/presentation/invoice_form_screen.dart`.
- [x] T017 Create `InvoiceCard` in `lib/features/invoices/presentation/widgets/invoice_card.dart`.
- [x] T018 Create `RecordPaymentDialog` in `lib/features/invoices/presentation/widgets/record_payment_dialog.dart`.
- [x] T019 Replace placeholder `InvoicesScreen` in `lib/features/invoices/presentation/invoices_screen.dart` with interactive list, filter chips, summary metrics, and PDF preview/share action.
- [x] T020 Wire "تحويل لفاتورة" (Convert to invoice) from Quotations screen and card.
- [x] T021 Write widget tests for invoice creation and payment in `test/features/invoices/presentation/invoice_form_test.dart`.
- [x] T022 Write widget tests for invoices list and filters in `test/features/invoices/presentation/invoices_list_test.dart`.

## Phase 7: Localization, Quality Gates & Polish
- [x] T023 Add all invoice Arabic strings to `lib/l10n/app_ar.arb` and generate localizations (`flutter gen-l10n`).
- [x] T024 Register invoice providers in `lib/app/bootstrap/providers.dart`, wire navigation routes in `app_router.dart`, and run quality gates (`dart format`, `flutter analyze`, `flutter test`).
