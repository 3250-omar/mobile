import 'package:drift/drift.dart';

import 'products_table.dart';

/// Drift table definition for quotation headers.
@TableIndex(
  name: 'idx_quotations_ref',
  columns: {#referenceNumber},
  unique: true,
)
@TableIndex(name: 'idx_quotations_customer', columns: {#customerName})
@TableIndex(name: 'idx_quotations_status', columns: {#status})
@DataClassName('QuotationEntry', companion: 'QuotationCompanion')
class QuotationsTable extends Table {
  @override
  String get tableName => 'quotations';

  /// Primary key autoincrement ID.
  IntColumn get id => integer().autoIncrement()();

  /// Human-readable sequential reference number (e.g. QT-2026-0001).
  TextColumn get referenceNumber =>
      text().customConstraint('NOT NULL UNIQUE')();

  /// Customer or company name.
  TextColumn get customerName => text()();

  /// Optional contact phone number.
  TextColumn get customerPhone => text().nullable()();

  /// Quotation lifecycle status: draft, sent, accepted, rejected, convertedToInvoice.
  TextColumn get status => text().withDefault(const Constant('draft'))();

  /// Issue date timestamp in milliseconds since epoch.
  IntColumn get issueDate => integer()();

  /// Optional validity expiration date timestamp in milliseconds since epoch.
  IntColumn get validUntil => integer().nullable()();

  /// Optional internal notes or payment terms.
  TextColumn get notes => text().nullable()();

  /// Sum of line totals in integer piastres.
  IntColumn get subtotalPiastres => integer().customConstraint(
    'NOT NULL DEFAULT 0 CHECK (subtotal_piastres >= 0)',
  )();

  /// Global order discount in integer piastres.
  IntColumn get discountPiastres => integer().customConstraint(
    'NOT NULL DEFAULT 0 CHECK (discount_piastres >= 0)',
  )();

  /// Tax amount in integer piastres.
  IntColumn get taxPiastres => integer().customConstraint(
    'NOT NULL DEFAULT 0 CHECK (tax_piastres >= 0)',
  )();

  /// Grand total: subtotal - discount + tax in integer piastres.
  IntColumn get grandTotalPiastres => integer().customConstraint(
    'NOT NULL DEFAULT 0 CHECK (grand_total_piastres >= 0)',
  )();

  /// Creation timestamp as milliseconds since epoch.
  IntColumn get createdAt => integer()();

  /// Modification timestamp as milliseconds since epoch.
  IntColumn get updatedAt => integer()();
}

/// Drift table definition for individual line items in a quotation.
@TableIndex(name: 'idx_quotation_items_quotation_id', columns: {#quotationId})
@DataClassName('QuotationItemEntry', companion: 'QuotationItemCompanion')
class QuotationItemsTable extends Table {
  @override
  String get tableName => 'quotation_items';

  /// Primary key autoincrement ID.
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key referencing the parent quotation.
  IntColumn get quotationId => integer().customConstraint(
    'NOT NULL REFERENCES quotations(id) ON DELETE CASCADE',
  )();

  /// Optional foreign key to catalog product (null for custom line items).
  IntColumn get productId => integer().nullable().references(
    ProductsTable,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Snapshot of product code at quotation creation time.
  TextColumn get productCode => text()();

  /// Snapshot of Arabic product name at quotation creation time.
  TextColumn get productName => text()();

  /// Snapshot of unit of measure (e.g. قطعة, متر).
  TextColumn get unit => text()();

  /// Snapshot of unit price in integer piastres (1 EGP = 100 piastres).
  IntColumn get unitPricePiastres =>
      integer().customConstraint('NOT NULL CHECK (unit_price_piastres >= 0)')();

  /// Quantity ordered (positive integer).
  IntColumn get quantity =>
      integer().customConstraint('NOT NULL CHECK (quantity > 0)')();

  /// Line-level discount in integer piastres.
  IntColumn get lineDiscountPiastres => integer().customConstraint(
    'NOT NULL DEFAULT 0 CHECK (line_discount_piastres >= 0)',
  )();

  /// Calculated line total: (unitPrice * quantity) - lineDiscount.
  IntColumn get lineTotalPiastres =>
      integer().customConstraint('NOT NULL CHECK (line_total_piastres >= 0)')();
}
