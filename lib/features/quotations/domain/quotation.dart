/// Domain entities representing quotations, line items, and lifecycle states.
/// Pure Dart: zero dependencies on Flutter, Drift, or external packages.
library;

/// Lifecycle states of an offline quotation.
enum QuotationStatus {
  draft('مسودة'),
  sent('تم الإرسال'),
  accepted('مقبول'),
  rejected('مرفوض'),
  convertedToInvoice('تم التحويل لفاتورة');

  const QuotationStatus(this.arabicLabel);
  final String arabicLabel;

  static QuotationStatus fromString(String val) {
    return QuotationStatus.values.firstWhere(
      (e) => e.name == val,
      orElse: () => QuotationStatus.draft,
    );
  }
}

/// Draft line item before persistence.
class QuotationItemDraft {
  const QuotationItemDraft({
    this.productId,
    required this.productCode,
    required this.productName,
    required this.unit,
    required this.unitPricePiastres,
    required this.quantity,
    this.lineDiscountPiastres = 0,
  });

  final int? productId;
  final String productCode;
  final String productName;
  final String unit;
  final int unitPricePiastres;
  final int quantity;
  final int lineDiscountPiastres;

  int get lineTotalPiastres {
    final raw = (unitPricePiastres * quantity) - lineDiscountPiastres;
    return raw > 0 ? raw : 0;
  }
}

/// Persisted line item inside a quotation with historical snapshot fields.
class QuotationItem {
  const QuotationItem({
    required this.id,
    required this.quotationId,
    this.productId,
    required this.productCode,
    required this.productName,
    required this.unit,
    required this.unitPricePiastres,
    required this.quantity,
    this.lineDiscountPiastres = 0,
    required this.lineTotalPiastres,
  });

  final int id;
  final int quotationId;
  final int? productId;
  final String productCode;
  final String productName;
  final String unit;
  final int unitPricePiastres;
  final int quantity;
  final int lineDiscountPiastres;
  final int lineTotalPiastres;

  String get formattedUnitPriceEgp {
    final pounds = unitPricePiastres ~/ 100;
    final piastres = (unitPricePiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedLineTotalEgp {
    final pounds = lineTotalPiastres ~/ 100;
    final piastres = (lineTotalPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }
}

/// Quotation aggregate root.
class Quotation {
  const Quotation({
    required this.id,
    required this.referenceNumber,
    required this.customerName,
    this.customerPhone,
    required this.status,
    required this.issueDate,
    this.validUntil,
    this.notes,
    required this.subtotalPiastres,
    this.discountPiastres = 0,
    this.taxPiastres = 0,
    required this.grandTotalPiastres,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String referenceNumber;
  final String customerName;
  final String? customerPhone;
  final QuotationStatus status;
  final DateTime issueDate;
  final DateTime? validUntil;
  final String? notes;
  final int subtotalPiastres;
  final int discountPiastres;
  final int taxPiastres;
  final int grandTotalPiastres;
  final List<QuotationItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isLocked =>
      status == QuotationStatus.accepted ||
      status == QuotationStatus.convertedToInvoice;

  int get totalItemCount => items.fold(0, (acc, item) => acc + item.quantity);

  String get formattedSubtotalEgp {
    final pounds = subtotalPiastres ~/ 100;
    final piastres = (subtotalPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedDiscountEgp {
    final pounds = discountPiastres ~/ 100;
    final piastres = (discountPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedTaxEgp {
    final pounds = taxPiastres ~/ 100;
    final piastres = (taxPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedGrandTotalEgp {
    final pounds = grandTotalPiastres ~/ 100;
    final piastres = (grandTotalPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }

  Quotation copyWith({
    int? id,
    String? referenceNumber,
    String? customerName,
    String? customerPhone,
    QuotationStatus? status,
    DateTime? issueDate,
    DateTime? validUntil,
    String? notes,
    int? subtotalPiastres,
    int? discountPiastres,
    int? taxPiastres,
    int? grandTotalPiastres,
    List<QuotationItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quotation(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      validUntil: validUntil ?? this.validUntil,
      notes: notes ?? this.notes,
      subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Aggregated metrics for shop management summary.
class QuotationMetrics {
  const QuotationMetrics({
    required this.totalCount,
    required this.draftsCount,
    required this.acceptedCount,
    required this.acceptedTotalPiastres,
  });

  final int totalCount;
  final int draftsCount;
  final int acceptedCount;
  final int acceptedTotalPiastres;

  String get formattedAcceptedTotalEgp {
    final pounds = acceptedTotalPiastres ~/ 100;
    final piastres = (acceptedTotalPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }
}
