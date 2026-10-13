# Feature Specification: 004-invoices-management

## Title
Invoices Management, Quotation Conversion & Offline Arabic PDF Export

## Problem Statement
In Egyptian plumbing and sanitary supply stores, sales transactions culminate in sales invoices. Currently, counter salesmen either write paper receipts by hand or lack an integrated offline workflow to convert approved quotations into binding sales invoices. Furthermore, salesmen need to track partial customer payments (آجل / دفعات نقدية) and immediately provide an itemized Arabic PDF receipt/invoice that can be printed on thermal receipt printers or shared via Bluetooth/messaging without requiring any internet connection.

## Scope & Target Audience
- **Target Persona**: Counter salesmen and sanitary ware shop owners operating in offline environments.
- **In-Scope**:
  1. Offline sales invoice lifecycle (`unpaid`, `partiallyPaid`, `paid`, `cancelled`).
  2. One-click conversion from accepted quotations (`QuotationStatus.accepted`) to sales invoices.
  3. Direct invoice creation with customer information, catalog picker, and custom items.
  4. Multi-payment recording (installment date, amount in piastres, payment method e.g. نقدي/تحويل).
  5. 100% offline Arabic PDF receipt and invoice generation using bundled Noto Sans Arabic fonts with verification QR code.
  6. Schema version 4 forward-only SQLite migration with Drift.
- **Out-of-Scope**:
  - Cloud synchronization, cloud payment gateways, or webhooks (strict 100% offline isolation).
  - OCR handwriting recognition (deferred to Feature 005).

## User Stories

### User Story 1: Invoices Dashboard & Lifecycle Tracking (P1)
**As a** shop owner,  
**I want to** browse saved sales invoices, see total receivables and paid amounts, and filter by payment status (`unpaid`, `partiallyPaid`, `paid`),  
**So that** I have immediate visibility over my shop's cash flow and customer debts without an internet connection.

### User Story 2: Quotation Conversion & Direct Invoice Creation (P1)
**As a** counter salesman,  
**I want to** convert an accepted quotation into an official invoice with one click or create a direct invoice from scratch,  
**So that** items, prices, and discounts carry over seamlessly without re-typing.

### User Story 3: Recording Payments & Installments (P1)
**As a** counter salesman,  
**I want to** record customer cash or bank transfer payments against an invoice,  
**So that** the remaining balance due is automatically updated and the invoice transitions from `unpaid` to `partiallyPaid` or `paid`.

### User Story 4: Offline Arabic PDF Invoice & Thermal Receipt Generation (P1)
**As a** shop salesman,  
**I want to** generate and preview an itemized Arabic PDF invoice/receipt with our shop branding, item table, payment breakdown, and offline verification QR code,  
**So that** I can print it on a thermal receipt printer or share it directly with the customer completely offline.

## Success Criteria
1. Sequential invoice reference numbering (`INV-YYYY-####`) resets yearly.
2. Minor-unit integer arithmetic: 100% of money amounts calculated in piastres.
3. Quotation conversion marks source quotation as `convertedToInvoice` and links `quotationId`.
4. PDF generation runs 100% on-device with zero network requests using bundled `assets/fonts/NotoSansArabic-*.ttf`.
5. Zero lint warnings, clean formatting, and 100% test pass rate across all automated quality gates.
