# Feature Specification: 008-business-profile

**Feature Branch**: `008-business-profile`  
**Created**: 2026-10-14  
**Status**: Draft  
**Input**: User description: "ملف هوية المؤسسة وترويسة الفواتير وعروض الأسعار (008-business-profile): تخصيص اسم المتجر، أرقام التواصل، العنوان، السجل التجاري والضريبي، شعار المحل، والملاحظات الافتراضية المطبوعة على الـ PDF"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Manage Business Profile & Branding (Priority: P1) 🎯 MVP

A plumbing merchant wants to register their trade name and contact information in the app so that their invoices and quotations reflect their real store identity rather than generic placeholder titles.

The merchant navigates to **Settings -> بيانات المنشأة والفواتير** (Business Profile & Invoice Settings) and fills in:
- Store / Business Name (اسم المنشأة / المحل) - e.g., "مؤسسة الأمل لتجارة الأدوات الصحية والسباكة"
- Merchant / Contact Name (اسم المسؤول)
- Primary Phone Number (رقم الهاتف الرئيسي)
- Secondary Phone / WhatsApp (رقم إضافي / واتساب)
- Store Address & City (العنوان والمحافظة) - e.g., "شارع الجمهورية، المنصورة، الدقهلية"
- Commercial Register number (السجل التجاري - اختياري)
- Tax Registration Card number (البطاقة الضريبية - اختياري)
- Optional Store Logo (شعار المحل) picked locally from device gallery and copied to app sandbox storage.

When the merchant taps **"حفظ التغييرات"**, the profile is persisted atomically to the local SQLite database.

**Why this priority**: Without a business profile, generated invoices and quotations lack merchant identification, legal trust, and professional branding required for customer dealings.

**Independent Test**: Can be tested by opening Business Profile in Settings, entering store details, picking a local logo image, saving, and verifying all fields persist across app reloads.

**Acceptance Scenarios**:
1. **Given** an empty business profile, **When** the merchant enters valid store name and phone number and saves, **Then** data is safely stored in local database with a success confirmation.
2. **Given** an existing profile, **When** the merchant updates the phone number or address, **Then** all subsequent quotations and invoices immediately use the updated details.
3. **Given** a selected logo image, **When** saved, **Then** the image is copied to the application's secure sandbox directory and referenced locally without external paths.

---

### User Story 2 - Render Professional Business Header on PDF Quotations (Priority: P1)

A merchant issues a quotation to a plumbing contractor. The generated PDF quotation must prominently display the merchant's business name, contact phones, address, tax numbers, and store logo in an elegant Arabic RTL header layout.

If no logo is set, a clean typographic Arabic header is rendered. If default terms (e.g., "عرض الأسعار سارٍ لمدة ٧ أيام من تاريخه") are configured, they are automatically placed in the footer notes section.

**Why this priority**: Quotations are customer-facing sales proposals. Having merchant identity and validity terms directly on the PDF ensures formal legal and commercial recognition.

**Independent Test**: Generate a PDF quotation for any customer and verify that the business name, logo, phone, address, and quotation validity note are rendered precisely on the PDF canvas.

**Acceptance Scenarios**:
1. **Given** an active business profile with a logo, **When** printing or sharing a PDF quotation, **Then** the PDF includes the logo on the header, store title, phone numbers, and address formatted with proper Arabic shaping and Bidi layout.
2. **Given** no logo is uploaded, **When** generating the PDF quotation, **Then** the layout gracefully adjusts and displays the store title and contact details centered or aligned without empty broken image artifacts.
3. **Given** custom default quotation notes are saved in the profile, **When** a new quotation is created, **Then** those default notes are pre-filled in the quotation notes field.

---

### User Story 3 - Render Business Identity & Legal Footers on PDF Invoices (Priority: P1)

When finalizing an invoice or exporting a sales receipt for a customer, the merchant needs the document to include legal identifiers (Commercial Register, Tax Card) and return/warranty policy terms (e.g., "البضاعة المباعة ترد وتستبدل خلال ١٤ يوماً بموجب أصل الفاتورة").

**Why this priority**: Invoices represent legal receipts of debt and revenue. Clear return policies, tax credentials, and store contact info are essential for consumer compliance and dispute prevention.

**Independent Test**: Generate an invoice PDF and verify that the Commercial Register and Tax numbers appear in the header/sub-header and the default return policy appears in the footer.

**Acceptance Scenarios**:
1. **Given** a business profile with Commercial Register and Tax numbers, **When** exporting an invoice PDF, **Then** both numbers are formatted clearly under the merchant title.
2. **Given** custom invoice footer terms in the profile, **When** rendering the invoice PDF, **Then** the terms are printed in the bottom note box with clear readable typography.

---

### User Story 4 - Live In-App Document Header Preview (Priority: P2)

While editing their business profile in Settings, the merchant wants to see an immediate visual preview of how their header card (Logo, Title, Contacts, Tax credentials) will look on printed documents before saving.

**Why this priority**: Provides instant visual feedback, helping merchants choose the right logo aspect ratio and check for formatting or text length issues.

**Independent Test**: In the Business Profile screen, modifying the store name or selecting a logo immediately updates the embedded live preview card without leaving the screen.

**Acceptance Scenarios**:
1. **Given** the Business Profile editor, **When** typing into the store name field or changing the logo, **Then** the live preview card dynamically reflects the changes.

---

## Edge Cases

- **Large or irregular logo images**: Logos of non-standard dimensions (e.g. extremely wide or tall) must be scaled to fit a bounded header box (e.g., maximum 80x80 dp) preserving aspect ratio without distortion or clipping.
- **Missing or deleted logo file**: If the logo image file is deleted from device storage by an external cleaning tool, the app must fallback gracefully to text-only header without crashing.
- **Extremely long business names**: Business names with > 100 characters must wrap neatly onto multiple lines without pushing financial tables off the first page.
- **Empty optional fields**: When Tax number, CR, or secondary phone are left empty, the PDF generators must omit those lines cleanly without rendering empty labels or awkward spacing.
- **Bidirectional numbers in contacts**: Egyptian phone numbers (e.g., "01012345678") and tax card formats must be wrapped with LTR isolation to prevent digit flipping in Arabic RTL text blocks.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a dedicated Business Profile domain model and SQLite persistence table (`business_profiles`) or extended singleton storing:
  - `businessName` (required string, 2-100 characters)
  - `ownerName` (optional string)
  - `phonePrimary` (required string, valid digits/dashes)
  - `phoneSecondary` (optional string)
  - `address` (optional string)
  - `city` (optional string)
  - `taxNumber` (optional string)
  - `commercialRegister` (optional string)
  - `logoRelativePath` (optional string pointing to app support sandboxed image)
  - `defaultQuotationNotes` (optional string)
  - `defaultInvoiceTerms` (optional string)
- **FR-002**: System MUST provide an intuitive Arabic RTL management screen accessible from Settings (`/settings/business-profile`).
- **FR-003**: System MUST support picking a logo image from local gallery using `FilePicker`, copying the selected image into the local sandboxed application directory (`app_support_dir/profile/logo.png`), and persisting its relative path.
- **FR-004**: System MUST provide the ability to remove the active logo and revert to text-only header branding.
- **FR-005**: `PdfQuotationGenerator` MUST query and integrate the merchant's business profile in the PDF document header and append default quotation notes if present.
- **FR-006**: `PdfInvoiceGenerator` MUST query and integrate the merchant's business profile, tax credentials, and default return/warranty terms in the invoice PDF.
- **FR-007**: System MUST validate that required fields (`businessName`, `phonePrimary`) are non-empty before saving.
- **FR-008**: System MUST operate 100% offline with zero cloud sync, analytics, or external image hosting.

---

## Success Criteria *(mandatory)*

- **SC-001**: A merchant can complete setting up their business name, contact phones, address, and logo in under 60 seconds.
- **SC-002**: 100% of generated quotation and invoice PDFs render the configured business profile with correct Arabic typography, shaping, and logo scaling without visual overlap.
- **SC-003**: App operates completely offline without network permissions, external HTTP requests, or cloud dependencies.
- **SC-004**: Zero regressions across existing 201 automated tests for catalog, quotations, invoices, scan OCR, dashboard, and backup/restore.
