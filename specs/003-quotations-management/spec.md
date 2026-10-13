# Feature Specification: Quotations Management & Deterministic Pricing Engine (003-quotations-management)

**Feature Branch**: `003-quotations-management`  
**Created**: 2026-10-13  
**Status**: Ready for Implementation  
**Input**: Feature 003 — Local draft and finalized quotations with catalog-linked line items, customer details, deterministic integer minor-unit pricing (piastres), and status lifecycle.

---

## Executive Summary

Feature 003 introduces the core business transaction workflow to the Offline Arabic Quotes application: managing customer quotations completely on-device without internet access. Counter salesmen and shop managers can build quotation drafts by picking items directly from the SQLite catalog (Feature 002), adding custom ad-hoc line items, setting quantities, applying item or global discounts, and calculating financial totals with integer-precision arithmetic (piastres / قروش, where 1 EGP = 100 piastres). Finalizing a quotation creates an immutable historical snapshot ensuring that catalog price edits never alter past financial agreements.

---

## User Scenarios & Testing

### User Story 1 — Create Offline Quotation with Catalog Line Items & Deterministic Pricing (Priority: P1) 🎯 MVP

As a plumbing counter salesman,  
I want to create a new quotation for a customer by selecting products from my local catalog, entering quantities, and seeing the exact total calculated instantly,  
So that I can present an accurate, professional price breakdown to the client without paper math or internet connectivity.

**Why this priority**: Creating and calculating quotations is the central economic value of the application; without it, catalog lookup cannot produce transactions.

**Independent Test**:
- Create a quotation with customer "أحمد محمود", pick 2 catalog items (e.g. 5x "كوع 20 مم" @ 12.50 EGP, 2x "محبس 1/2" @ 65.00 EGP), apply 10.00 EGP global discount.
- Verify subtotal is 192.50 EGP (19250 piastres), discount is 10.00 EGP (1000 piastres), total is 182.50 EGP (18250 piastres).
- Verify record persists in SQLite as `draft`.

**Acceptance Scenarios**:
1. **Given** an active product catalog, **When** the user taps "إنشاء عرض سعر جديد" and picks products with quantities, **Then** line totals update reactively using integer arithmetic.
2. **Given** a quotation in progress, **When** the user adds a custom item not in the catalog (specifying title, unit, and price), **Then** the custom line item is accepted and included in the subtotal.
3. **Given** a draft quotation, **When** the user taps "حفظ كمسودة", **Then** the quotation and its line items persist atomically to local SQLite with unique quotation number (e.g. `QT-2026-0001`).

---

### User Story 2 — Quotations List, Filtering & Status Progression (Priority: P1)

As a shop manager,  
I want to review all existing quotations on the quotations screen, filter them by status, and update their lifecycle status,  
So that I can follow up on pending deals and know which offers were accepted or rejected.

**Why this priority**: Salesmen need visibility into active and historical quotations to manage customer follow-ups and avoid duplicate work.

**Independent Test**:
- Open QuotationsScreen with 3 quotations (`draft`, `sent`, `accepted`).
- Filter by `draft`, verify only draft quotations appear.
- Update a quotation status from `draft` to `sent` and verify persistence.

**Acceptance Scenarios**:
1. **Given** persisted quotations, **When** the user navigates to the Quotations tab, **Then** all quotations are listed in reverse chronological order with Arabic customer name, date, item count, status chip, and formatted total.
2. **Given** the quotations list, **When** the user taps status filter chips ("الكل", "مسودة", "تم الإرسال", "مقبول", "مرفوض"), **Then** the list filters instantly.
3. **Given** a quotation card, **When** the user changes its status (e.g. to "تم الإرسال" or "مقبول"), **Then** the new status is saved to SQLite immediately.

---

### User Story 3 — Draft Editing, Item Modification & Finalization Snapshot (Priority: P2)

As a shop manager,  
I want to edit pending drafts and finalize approved quotations into immutable snapshots,  
So that finalized prices and descriptions remain legally and historically intact even if the product catalog prices change later.

**Why this priority**: Fulfills Constitution Principle IV (Data Integrity and Historical Immutability) and prevents price tampering or accidental catalog drift.

**Independent Test**:
- Create quotation with a catalog item @ 50.00 EGP. Finalize quotation.
- Later update catalog price of that item to 75.00 EGP.
- Open the finalized quotation and verify its line item still reflects 50.00 EGP.

**Acceptance Scenarios**:
1. **Given** a quotation in `draft` status, **When** the user edits quantities, line items, or customer details, **Then** changes update the draft in SQLite.
2. **Given** a quotation in `draft` status, **When** the user taps "اعتماد عرض السعر (نهائي)", **Then** the quotation status transitions to `accepted`/`finalized` and editing is locked.
3. **Given** a finalized quotation, **When** catalog items referenced in it are updated or deleted, **Then** the quotation line item retains its frozen product name, unit, code, and unit price snapshot.

---

### User Story 4 — Quotation Duplication & Quick Summary Metrics (Priority: P3)

As a counter salesman,  
I want to quickly duplicate an existing quotation into a new draft and inspect quotation count/value metrics,  
So that I can quote similar plumbing requirements for new clients in seconds.

**Why this priority**: Streamlines high-frequency retail workflows for plumbing contractors who purchase recurring bundles of fittings.

**Independent Test**:
- Tap "نسخ كعرض جديد" on an existing quotation.
- Verify a new draft is created with identical line items and reset creation date and draft status.

**Acceptance Scenarios**:
1. **Given** an existing quotation, **When** the user selects "تكرار العرض", **Then** a new quotation record is created with a new quotation number, current timestamp, and `draft` status.
2. **Given** the quotations screen, **When** viewing the header metrics, **Then** the total quotation count and sum of accepted quotations in EGP are displayed.

---

## Non-Functional Requirements & Constitutional Constraints

1. **100% Offline Core**: Strictly zero external HTTP requests, cloud storage, or external APIs.
2. **Deterministic Minor Units**: All monetary values (`unit_price_piastres`, `discount_piastres`, `tax_piastres`, `total_piastres`) MUST be represented as 64-bit integers. Binary floating-point math (`double` arithmetic for money totals) is strictly prohibited.
3. **Arabic-First Experience**: RTL layout default, Eastern Arabic numeral input normalization, and Noto Sans Arabic typography.
4. **Data Ownership & SQLite Storage**: Relational Drift tables (`quotations` and `quotation_items`) with forward-only migration from v2 to v3.
5. **No Negative Totals**: Discounts cannot exceed the subtotal. Quantities must be positive integers or decimals with minor units.

---

## Edge Cases

- **Zero or negative quantities**: Rejected by validator; minimum quantity is 1.
- **Discount greater than subtotal**: Clamped to subtotal so total cannot be negative.
- **Product deleted from catalog**: Historical quotation preserves product snapshot (`name_snapshot`, `code_snapshot`, `unit_price_piastres_snapshot`).
- **Mixed numeral inputs**: Customer phone and quantities entered with Arabic-Indic numerals (`١٢٣`) are normalized transparently.
- **Empty quotation**: Cannot save a quotation with zero line items.
