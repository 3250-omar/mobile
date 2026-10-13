# Feature Specification: 006-dashboard-quick-actions

**Feature Branch**: `006-dashboard-quick-actions`  
**Created**: 2026-10-14  
**Status**: Draft  
**Input**: User description: "لوحة التحكم الرئيسية (Dashboard & Quick Actions) لربط إحصائيات المنتجات وعروض الأسعار والفواتير والوصول السريع للمسح الضوئي"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Business & Catalog Metrics Overview (Priority: P1)

A plumbing supply merchant opens the app and lands immediately on the Home screen. Instead of a static placeholder, they see clear summary cards presenting live business metrics computed from their local SQLite database:
1. إجمالي الأصناف بالكتالوج (Total catalog items).
2. عروض الأسعار النشطة (Active quotations count and total estimated value).
3. مستحقات وفواتير معلقة (Unpaid invoice receivables sum).
4. إجمالي الإيراد المحصل (Total collected revenue from paid/partially paid invoices).

All monetary metrics are strictly calculated from minor integer units (piastres / قروش) and formatted to standard Egyptian Pounds (EGP) with Arabic numerals formatting.

**Why this priority**: Merchant needs an immediate operational snapshot of their plumbing supply business upon launch without navigating between individual screens.

**Independent Test**: Can be tested by inserting sample products, quotations, and invoices into the local database and verifying that the dashboard metric cards display the exact aggregated counts and sums.

**Acceptance Scenarios**:
1. **Given** a database with 150 products, 4 quotations totaling 45,000 EGP (2 draft, 2 sent), and 3 invoices (1 paid of 10,000 EGP, 2 unpaid totaling 25,000 EGP), **When** the merchant opens the Home screen, **Then** the metrics cards display:
   - الأصناف: 150 صنف
   - عروض الأسعار: 4 عروض بقيمة 45,000.00 ج.م
   - المستحقات المعلقة: 25,000.00 ج.م
   - إجمالي المحصل: 10,000.00 ج.م
2. **Given** an empty initial installation, **When** the merchant opens the Home screen, **Then** all metrics display zero (`0`) without crashing or showing error indicators, alongside a welcoming empty state guiding them to start.
3. **Given** a new invoice is added or marked paid in another tab, **When** the merchant returns to the Home screen, **Then** the metrics update reactively without requiring an app restart.

---

### User Story 2 - Prominent Quick Action Shortcuts (Priority: P1)

The merchant can quickly execute their most frequent daily operations directly from the dashboard with one tap:
- **مسح كشف طلبية (Scan Order Slip)**: Navigates immediately to the camera/OCR capture screen (`/scan`).
- **عرض سعر جديد (New Quotation)**: Navigates immediately to quotation builder (`/quotations/new`).
- **فاتورة مبيعات جديدة (New Invoice)**: Navigates immediately to invoice builder (`/invoices/new`).
- **استيراد / كتالوج الأصناف (Catalog & Import)**: Navigates to product catalog (`/products`).

**Why this priority**: In a busy plumbing counter environment, saving taps for repetitive actions (scanning requisition papers, issuing new quotes) drastically speeds up customer checkout.

**Independent Test**: Tapping each quick action tile launches the designated feature route directly.

**Acceptance Scenarios**:
1. **Given** the merchant is on the dashboard, **When** they tap "مسح كشف طلبية", **Then** the app navigates to `/scan`.
2. **Given** the merchant is on the dashboard, **When** they tap "عرض سعر جديد", **Then** the app navigates to `/quotations/new`.
3. **Given** the merchant is on the dashboard, **When** they tap "فاتورة جديدة", **Then** the app navigates to `/invoices/new`.
4. **Given** the merchant is on the dashboard, **When** they tap "الكتالوج", **Then** the app switches to the products tab.

---

### User Story 3 - Recent Activity Stream (Priority: P2)

Beneath the metrics and quick actions, the dashboard displays a "النشاط الأخير" (Recent Activity) section listing the latest 5 commercial documents (quotations and invoices combined or categorized), ordered chronologically by modification date. Each item shows:
- Document type icon and Arabic reference number (e.g., `QT-2026-0001` or `INV-2026-0001`).
- Customer name.
- Status badge (مسودة / مرسل / معتمد / مدفوعة / غير مدفوعة / مدفوعة جزئياً) with distinct Material 3 color tones.
- Total amount formatted in EGP.
- Relative or formatted Arabic date.

Tapping any recent activity item opens the document details or edit screen.

**Why this priority**: Allows merchants to swiftly resume working on drafts or follow up on recent transactions without digging through search filters.

**Independent Test**: Verify that recently saved or edited quotations and invoices show up at the top of the activity list, and tapping navigates to the item.

**Acceptance Scenarios**:
1. **Given** existing quotations and invoices, **When** viewing recent activity, **Then** up to 5 of the most recently updated items are listed chronologically.
2. **Given** a listed quotation, **When** the merchant taps its card, **Then** the app navigates to the quotation details/editor screen.
3. **Given** a listed invoice, **When** the merchant taps its card, **Then** the app navigates to the invoice details/payment screen.
4. **Given** no documents exist yet, **When** viewing the section, **Then** a friendly empty state message is shown: "لا توجد معاملات أخيرة بعد".

---

### User Story 4 - Offline Status & Shop Header (Priority: P3)

The dashboard header displays the merchant's configured shop name (from `app_settings`), today's Arabic date, and a prominent badge confirming "100% دون إنترنت" (100% Offline Secured).

**Why this priority**: Reassures the merchant that their customer and pricing records are strictly localized on-device and provides personalized shop branding.

**Independent Test**: Update the shop name in Settings and verify the dashboard header reflects the new name.

**Acceptance Scenarios**:
1. **Given** shop name "مؤسسة الأمل للسباكة الحديثة" in settings, **When** the dashboard opens, **Then** the header displays "مؤسسة الأمل للسباكة الحديثة".
2. **Given** default settings, **When** the dashboard opens, **Then** a localized fallback title "مرحباً بك في تسعيرة" is displayed.

---

### Edge Cases

- **Zero-data initial launch**: All queries return 0 or empty lists; dashboard must display clean empty state placeholders rather than null errors or infinite loading spinners.
- **Large catalog or large transaction volume**: Metrics aggregation queries must execute using SQLite `COUNT()` and `SUM()` indexed queries rather than loading all entity objects into Dart memory.
- **Device theme / orientation**: Cards and quick action buttons must wrap cleanly in both portrait and landscape, supporting dark and light themes seamlessly.
- **Deleted records**: Cascading deletions or status updates must automatically refresh reactive dashboard streams.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Dashboard MUST display total active products in catalog.
- **FR-002**: Dashboard MUST display total quotations count and grand total value of pending/active quotations in integer piastres.
- **FR-003**: Dashboard MUST display unpaid invoices balance (receivables) and total collected revenue in integer piastres.
- **FR-004**: System MUST aggregate all financial metrics directly via SQLite queries (`SUM`, `COUNT`) to maintain instantaneous performance and minimal memory usage.
- **FR-005**: Dashboard MUST provide quick action shortcuts to:
  - OCR Scan Screen (`/scan`)
  - New Quotation Form (`/quotations/new`)
  - New Invoice Form (`/invoices/new`)
  - Products Catalog (`/products`)
- **FR-006**: Dashboard MUST display the latest 5 quotations or invoices in a unified recent activity feed, sorted descending by modification time.
- **FR-007**: Tapping an item in the recent activity feed MUST navigate directly to that document's route.
- **FR-008**: All currency values MUST be formatted using standard 2-decimal Egyptian Pound (EGP) format with Arabic number localization.
- **FR-009**: The entire dashboard MUST operate 100% offline with zero outbound network calls, telemetry, or external service dependencies.
- **FR-010**: The dashboard MUST reactively refresh metrics when database changes occur in products, quotations, or invoices.

### Key Entities *(include if feature involves data)*

- **DashboardMetrics**: Value object containing:
  - `totalProductsCount`: int
  - `totalQuotationsCount`: int
  - `activeQuotationsValuePiastres`: int
  - `totalInvoicesCount`: int
  - `unpaidReceivablesPiastres`: int
  - `collectedRevenuePiastres`: int
- **RecentActivityItem**: Model representing recent commercial activity:
  - `id`: int
  - `type`: ActivityType (`quotation`, `invoice`)
  - `referenceNumber`: String
  - `customerName`: String
  - `amountPiastres`: int
  - `status`: String
  - `date`: DateTime

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Dashboard initial load and metric computation time is under 150 milliseconds on local SQLite database with 5,000+ products.
- **SC-002**: 100% of quick actions navigate to their respective functional screens in a single tap without intermediary confirmation prompts.
- **SC-003**: Zero network traffic or cloud telemetry packets transmitted at any time.
- **SC-004**: Aggregated financial metrics match the exact sum of individual underlying records to the exact piastre (zero rounding discrepancy).

---

## Assumptions

- Product, quotation, and invoice tables from features 002, 003, and 004 are already established in the Drift schema.
- The user is using an RTL Arabic device interface with Cairo/Noto Sans Arabic typography.
- Quick action navigation targets use the existing `GoRouter` configuration paths.
