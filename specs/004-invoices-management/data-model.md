# Data Model: Invoices & Payments (Schema v4)

## Entities & Tables

### 1. `InvoicesTable` (`invoices`)
Represents the invoice header and financial aggregation.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | `IntColumn` | PK, AutoIncrement | Unique internal invoice ID |
| `reference_number` | `TextColumn` | NOT NULL, UNIQUE | Sequential yearly reference (`INV-YYYY-####`) |
| `quotation_id` | `IntColumn` | Nullable, FK `quotations(id)` ON DELETE SET NULL | Link to original quotation if converted |
| `customer_name` | `TextColumn` | NOT NULL | Customer or contractor name |
| `customer_phone` | `TextColumn` | Nullable | Optional phone number |
| `status` | `TextColumn` | NOT NULL | `unpaid`, `partiallyPaid`, `paid`, `cancelled` |
| `issue_date` | `IntColumn` | NOT NULL | Issue timestamp (ms) |
| `due_date` | `IntColumn` | Nullable | Payment due timestamp (ms) |
| `subtotal_piastres` | `IntColumn` | NOT NULL | Gross sum of items before invoice discount |
| `discount_piastres` | `IntColumn` | NOT NULL, default 0 | Extra invoice discount in piastres |
| `tax_piastres` | `IntColumn` | NOT NULL, default 0 | Tax amount in piastres |
| `grand_total_piastres` | `IntColumn` | NOT NULL | Final invoice total payable |
| `paid_amount_piastres` | `IntColumn` | NOT NULL, default 0 | Sum of recorded payments in piastres |
| `notes` | `TextColumn` | Nullable | Invoice notes or payment conditions |
| `created_at` | `IntColumn` | NOT NULL | Creation timestamp (ms) |
| `updated_at` | `IntColumn` | NOT NULL | Last update timestamp (ms) |

### 2. `InvoiceItemsTable` (`invoice_items`)
Line items stored as immutable historical snapshots.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | `IntColumn` | PK, AutoIncrement | Unique line item ID |
| `invoice_id` | `IntColumn` | NOT NULL, FK `invoices(id)` ON DELETE CASCADE | Parent invoice |
| `product_id` | `IntColumn` | Nullable, FK `products(id)` ON DELETE SET NULL | Optional link to catalog product |
| `product_code` | `TextColumn` | NOT NULL | Frozen code snapshot |
| `product_name` | `TextColumn` | NOT NULL | Frozen Arabic name snapshot |
| `unit` | `TextColumn` | NOT NULL | Unit of measure snapshot (e.g. قطعة, متر) |
| `unit_price_piastres` | `IntColumn` | NOT NULL | Frozen unit price in piastres |
| `quantity` | `IntColumn` | NOT NULL | Quantity (> 0) |
| `line_discount_piastres` | `IntColumn` | NOT NULL, default 0 | Item-level discount |
| `line_total_piastres` | `IntColumn` | NOT NULL | `(unitPrice * quantity) - discount` |

### 3. `InvoicePaymentsTable` (`invoice_payments`)
Payment transactions and installments.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | `IntColumn` | PK, AutoIncrement | Unique payment record ID |
| `invoice_id` | `IntColumn` | NOT NULL, FK `invoices(id)` ON DELETE CASCADE | Parent invoice |
| `amount_piastres` | `IntColumn` | NOT NULL | Payment amount (> 0) in piastres |
| `payment_method` | `TextColumn` | NOT NULL | `cash`, `bankTransfer`, `cheque`, `other` |
| `payment_date` | `IntColumn` | NOT NULL | Timestamp when payment occurred |
| `notes` | `TextColumn` | Nullable | Payment receipt ref / check number |
| `created_at` | `IntColumn` | NOT NULL | Creation timestamp (ms) |

---

## Domain Enums

```dart
enum InvoiceStatus {
  unpaid('غير مسدد'),
  partiallyPaid('مسدد جزئياً'),
  paid('مسدد بالكامل'),
  cancelled('ملغي');

  const InvoiceStatus(this.arabicLabel);
  final String arabicLabel;
}

enum PaymentMethod {
  cash('نقدي'),
  bankTransfer('تحويل بنكي'),
  cheque('شيك'),
  other('أخرى');

  const PaymentMethod(this.arabicLabel);
  final String arabicLabel;
}
```
