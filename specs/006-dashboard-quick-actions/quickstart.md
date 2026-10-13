# Quickstart: Dashboard & Quick Actions

This guide describes how to validate the Dashboard & Quick Actions feature end-to-end.

## Prerequisites

- Local SQLite Drift database initialized.
- Sample catalog items, quotations, and invoices present or added via integration tests.

## Verification Scenarios

### 1. Verification of Metrics Calculation
- Run: `flutter test test/features/home/drift_dashboard_repository_test.dart`
- Expected:
  - Total products count equals the count of items in `products` table.
  - Active quotations count and grand total value equal only non-rejected quotations.
  - Unpaid receivables equal the sum of (`grandTotalPiastres - paidAmountPiastres`) for unpaid/partially paid invoices.
  - Collected revenue equals the sum of `paidAmountPiastres` across all invoices.

### 2. Verification of Quick Action Navigation
- Run: `flutter test test/features/home/home_screen_test.dart`
- Expected:
  - Tapping "مسح كشف طلبية" navigates to `/scan`.
  - Tapping "عرض سعر جديد" navigates to `/quotations/new`.
  - Tapping "فاتورة جديدة" navigates to `/invoices/new`.
  - Tapping "الكتالوج" navigates to `/products`.

### 3. Verification of Empty State & Shop Header
- With an empty database:
  - The dashboard displays 0 for all metrics without errors.
  - An empty state message is displayed in the recent activity section.
  - Shop name defaults or reflects `app_settings`.
