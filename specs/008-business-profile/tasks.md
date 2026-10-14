# Tasks: 008-business-profile

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Module structure and table definition for business profile management

- [x] T001 Define `business_profiles` SQLite table schema in `lib/core/database/tables/business_profile_table.dart`
- [x] T002 Register `BusinessProfilesTable` in `lib/core/database/app_database.dart` and increment schema version

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core domain entity and repository interface that MUST be complete before user stories

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 [P] Implement `BusinessProfile` pure Dart domain entity in `lib/features/settings/domain/business_profile.dart`
- [x] T004 [P] Implement `BusinessProfileRepository` abstract interface in `lib/features/settings/domain/business_profile_repository.dart`
- [x] T005 [P] Create `FakeBusinessProfileRepository` in `test/support/fake_business_profile_repository.dart`
- [x] T006 Implement `DriftBusinessProfileRepository` in `lib/features/settings/data/drift_business_profile_repository.dart`
- [x] T007 Unit tests for `DriftBusinessProfileRepository` in `test/features/settings/business_profile_repository_test.dart`

**Checkpoint**: Foundation ready - repository persists and queries business profile.

---

## Phase 3: User Story 1 - Manage Business Profile & Branding (Priority: P1) 🎯 MVP

**Goal**: Merchants can configure store name, contact numbers, address, tax info, and pick local logo.

**Independent Test**: Save profile via settings and verify it persists across reloads.

### Implementation for User Story 1

- [x] T008 [US1] Implement `BusinessProfileController` StateNotifier in `lib/features/settings/application/business_profile_controller.dart`
- [x] T009 [P] [US1] Register `businessProfileRepositoryProvider` and `businessProfileControllerProvider` in `lib/app/bootstrap/providers.dart`
- [x] T010 [P] [US1] Unit tests for `BusinessProfileController` in `test/features/settings/business_profile_controller_test.dart`
- [x] T011 [US1] Implement `BusinessProfileScreen` editor in `lib/features/settings/presentation/business_profile_screen.dart`
- [x] T012 [P] [US1] Add route `/settings/business-profile` in `lib/app/navigation/route_names.dart` and `lib/app/navigation/app_router.dart`
- [x] T013 [P] [US1] Add Business Profile navigation tile in `lib/features/settings/presentation/settings_screen.dart`

**Checkpoint**: User Story 1 fully functional and testable independently.

---

## Phase 4: User Story 2 - Render Business Header on PDF Quotations (Priority: P1)

**Goal**: Render merchant store name, phones, address, logo, and quotation validity notes on quotation PDFs.

**Independent Test**: Generate a quotation PDF and verify business header and notes are present.

### Implementation for User Story 2

- [x] T014 [US2] Update `PdfQuotationGenerator` interface and `DefaultPdfQuotationGenerator` in `lib/features/quotations/data/default_pdf_quotation_generator.dart` to render `BusinessProfile` header and logo
- [x] T015 [P] [US2] Unit test for PDF quotation header rendering with profile in `test/features/quotations/pdf_quotation_profile_test.dart`

**Checkpoint**: User Stories 1 and 2 work independently.

---

## Phase 5: User Story 3 - Render Business Identity & Legal Footers on PDF Invoices (Priority: P1)

**Goal**: Render store name, phones, Commercial Register, Tax Card, logo, and return policy on invoice PDFs.

**Independent Test**: Generate an invoice PDF and verify tax credentials and return policy appear.

### Implementation for User Story 3

- [x] T016 [US3] Update `PdfInvoiceGenerator` interface and `DefaultPdfInvoiceGenerator` in `lib/features/invoices/data/default_pdf_invoice_generator.dart` to render `BusinessProfile` legal credentials and footer terms
- [x] T017 [P] [US3] Unit test for PDF invoice legal header rendering in `test/features/invoices/pdf_invoice_profile_test.dart`

**Checkpoint**: User Stories 1, 2, and 3 work independently.

---

## Phase 6: User Story 4 - Live In-App Document Header Preview (Priority: P2)

**Goal**: Live preview of the store header card inside the profile editor.

**Independent Test**: Editing store name dynamically updates the visual header preview.

### Implementation for User Story 4

- [x] T018 [P] [US4] Implement `BusinessHeaderPreviewCard` widget in `lib/features/settings/presentation/widgets/business_header_preview_card.dart`
- [x] T019 [US4] Embed `BusinessHeaderPreviewCard` into `BusinessProfileScreen` in `lib/features/settings/presentation/business_profile_screen.dart`
- [x] T020 [P] [US4] Widget test for `BusinessProfileScreen` in `test/features/settings/business_profile_screen_test.dart`

**Checkpoint**: Full feature completed.

---

## Phase 7: Polish & Quality Gates

**Purpose**: Verification and quality gates

- [x] T021 Run `dart format --output=none --set-exit-if-changed lib test`
- [x] T022 Run `flutter analyze lib test`
- [x] T023 Run full automated test suite `flutter test`
- [x] T024 Verify architecture compliance in `test/architecture/dependency_direction_test.dart`

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** -> **Phase 2 (Foundational)** -> **Phase 3 (US1)** -> **Phase 4 (US2)** -> **Phase 5 (US3)** -> **Phase 6 (US4)** -> **Phase 7 (Polish)**
