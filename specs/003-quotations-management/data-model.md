# Data Model: Quotations Management (003-quotations-management)

## 1. Domain Entities (Pure Dart)

### `QuotationStatus` (Enum)
```dart
enum QuotationStatus {
  draft('مسودة'),
  sent('تم الإرسال'),
  accepted('مقبول'),
  rejected('مرفوض'),
  convertedToInvoice('تم التحويل لفاتورة');

  const QuotationStatus(this.arabicLabel);
  final String arabicLabel;
}
```

### `QuotationItem` (Entity)
```dart
class QuotationItem {
  final int id;
  final int quotationId;
  final int? productId; // Nullable for custom ad-hoc items
  final String productCode;
  final String productName;
  final String unit;
  final int unitPricePiastres; // 1 EGP = 100 piastres
  final int quantity; // standard count or units
  final int lineDiscountPiastres;
  final int lineTotalPiastres; // (unitPricePiastres * quantity) - lineDiscountPiastres

  String get formattedUnitPriceEgp;
  String get formattedLineTotalEgp;
}
```

### `Quotation` (Aggregate Root)
```dart
class Quotation {
  final int id;
  final String referenceNumber; // e.g. "QT-2026-0001"
  final String customerName;
  final String? customerPhone;
  final QuotationStatus status;
  final DateTime issueDate;
  final DateTime? validUntil;
  final String? notes;
  
  // Financial totals in integer piastres
  final int subtotalPiastres;
  final int discountPiastres; // global discount
  final int taxPiastres;
  final int grandTotalPiastres; // subtotal - discount + tax
  
  final List<QuotationItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isLocked => status == QuotationStatus.accepted || status == QuotationStatus.convertedToInvoice;
  String get formattedSubtotalEgp;
  String get formattedDiscountEgp;
  String get formattedGrandTotalEgp;
}
```

---

## 2. Drift Database Schema v3

### `QuotationsTable` (`lib/core/database/tables/quotations_table.dart`)
- `id`: Int, autoIncrement, primaryKey
- `reference_number`: Text, unique, indexed
- `customer_name`: Text, indexed
- `customer_phone`: Text, nullable
- `status`: Text, default 'draft', indexed
- `issue_date`: DateTime
- `valid_until`: DateTime, nullable
- `notes`: Text, nullable
- `subtotal_piastres`: Int, default 0
- `discount_piastres`: Int, default 0
- `tax_piastres`: Int, default 0
- `grand_total_piastres`: Int, default 0
- `created_at`: DateTime
- `updated_at`: DateTime

### `QuotationItemsTable` (`lib/core/database/tables/quotation_items_table.dart`)
- `id`: Int, autoIncrement, primaryKey
- `quotation_id`: Int, foreignKey -> `QuotationsTable.id` with `ON DELETE CASCADE`
- `product_id`: Int, nullable, foreignKey -> `ProductsTable.id` with `ON DELETE SET NULL`
- `product_code_snapshot`: Text
- `product_name_snapshot`: Text
- `unit_snapshot`: Text
- `unit_price_piastres`: Int
- `quantity`: Int
- `line_discount_piastres`: Int, default 0
- `line_total_piastres`: Int

---

## 3. Database Migration: Schema v2 to Schema v3

- `schemaVersion` increases from 2 to 3.
- In `migration_strategy.dart`:
  ```dart
  if (from < 3) {
    await m.createTable(quotationsTable);
    await m.createTable(quotationItemsTable);
    // Add indices on reference_number, customer_name, and status
  }
  ```
- Dump schema: `drift_schemas/drift_schema_v3.json`.
