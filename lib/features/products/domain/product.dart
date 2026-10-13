/// Domain entity representing a product in the plumbing materials catalog.
///
/// Pure Dart domain model with zero dependencies on Flutter or Drift.
class Product {
  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.unit,
    required this.unitPricePiastres,
    required this.normalizedSearchText,
    this.barcode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Internal database unique primary key.
  final int id;

  /// Unique product/item code (e.g., "PPR-20-ELB").
  final String code;

  /// Arabic product title/description.
  final String name;

  /// Classification group (e.g., "مواسير بولي بروبلين").
  final String category;

  /// Unit of measure (e.g., "قطعة", "متر", "طقم").
  final String unit;

  /// Unit price in integer minor units (piastres / قروش).
  ///
  /// Strictly non-negative integer. Example: 15.50 EGP is 1550 piastres.
  final int unitPricePiastres;

  /// Pre-computed normalized text for fast Arabic search matching.
  final String normalizedSearchText;

  /// Optional barcode or SKU string.
  final String? barcode;

  /// Optional notes or brand specifications.
  final String? notes;

  /// Creation timestamp in UTC.
  final DateTime createdAt;

  /// Modification timestamp in UTC.
  final DateTime updatedAt;

  /// Decimal price in Egyptian Pounds (EGP) as a formatted string without floating-point drift.
  String get formattedPriceEgp {
    final pounds = unitPricePiastres ~/ 100;
    final piastres = unitPricePiastres % 100;
    return '$pounds.${piastres.toString().padLeft(2, '0')}';
  }

  Product copyWith({
    int? id,
    String? code,
    String? name,
    String? category,
    String? unit,
    int? unitPricePiastres,
    String? normalizedSearchText,
    String? barcode,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      unitPricePiastres: unitPricePiastres ?? this.unitPricePiastres,
      normalizedSearchText: normalizedSearchText ?? this.normalizedSearchText,
      barcode: barcode ?? this.barcode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          name == other.name &&
          category == other.category &&
          unit == other.unit &&
          unitPricePiastres == other.unitPricePiastres &&
          normalizedSearchText == other.normalizedSearchText &&
          barcode == other.barcode &&
          notes == other.notes &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    category,
    unit,
    unitPricePiastres,
    normalizedSearchText,
    barcode,
    notes,
    createdAt,
    updatedAt,
  );

  @override
  String toString() =>
      'Product(id: $id, code: $code, name: $name, category: $category, unit: $unit, price: $formattedPriceEgp EGP)';
}

/// Unpersisted draft of a product used for creation or Excel import.
class ProductDraft {
  const ProductDraft({
    required this.code,
    required this.name,
    required this.category,
    required this.unit,
    required this.unitPricePiastres,
    this.barcode,
    this.notes,
  });

  final String code;
  final String name;
  final String category;
  final String unit;
  final int unitPricePiastres;
  final String? barcode;
  final String? notes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDraft &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          name == other.name &&
          category == other.category &&
          unit == other.unit &&
          unitPricePiastres == other.unitPricePiastres &&
          barcode == other.barcode &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(
    code,
    name,
    category,
    unit,
    unitPricePiastres,
    barcode,
    notes,
  );

  @override
  String toString() =>
      'ProductDraft(code: $code, name: $name, category: $category, unit: $unit, pricePiastres: $unitPricePiastres)';
}
