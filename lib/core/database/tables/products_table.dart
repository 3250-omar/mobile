import 'package:drift/drift.dart';

/// Drift table definition for the plumbing catalog items.
@TableIndex(name: 'idx_products_code', columns: {#code}, unique: true)
@TableIndex(name: 'idx_products_category', columns: {#category})
@TableIndex(name: 'idx_products_search', columns: {#normalizedSearchText})
@DataClassName('ProductEntry', companion: 'ProductCompanion')
class ProductsTable extends Table {
  @override
  String get tableName => 'products';

  /// Primary key autoincrement integer ID.
  IntColumn get id => integer().autoIncrement()();

  /// Unique shop/supplier product code.
  TextColumn get code => text().customConstraint('NOT NULL UNIQUE')();

  /// Full Arabic product name and dimensions.
  TextColumn get name => text()();

  /// Material/domain category (e.g., مواسير, محابس, لوازم).
  TextColumn get category => text()();

  /// Unit of measure (e.g., قطعة, متر, طقم).
  TextColumn get unit => text()();

  /// Unit price in integer minor units (piastres / قروش).
  /// Strictly non-negative.
  IntColumn get unitPricePiastres =>
      integer().customConstraint('NOT NULL CHECK (unit_price_piastres >= 0)')();

  /// Pre-normalized search index string for resilient Arabic matching.
  TextColumn get normalizedSearchText => text()();

  /// Optional barcode or SKU.
  TextColumn get barcode => text().nullable()();

  /// Optional notes.
  TextColumn get notes => text().nullable()();

  /// Creation timestamp as milliseconds since epoch.
  IntColumn get createdAt => integer()();

  /// Modification timestamp as milliseconds since epoch.
  IntColumn get updatedAt => integer()();
}
