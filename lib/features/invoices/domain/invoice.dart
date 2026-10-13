/// Domain entities representing sales invoices, line items, payments, and metrics.
/// Pure Dart: zero dependencies on Flutter, Drift, or external packages.
library;

/// Lifecycle and payment status of a sales invoice.
enum InvoiceStatus {
  unpaid('غير مسدد'),
  partiallyPaid('مسدد جزئياً'),
  paid('مسدد بالكامل'),
  cancelled('ملغي');

  const InvoiceStatus(this.arabicLabel);
  final String arabicLabel;

  static InvoiceStatus fromString(String val) {
    return InvoiceStatus.values.firstWhere(
      (e) => e.name == val,
      orElse: () => InvoiceStatus.unpaid,
    );
  }
}

/// Accepted payment methods for customer installments.
enum PaymentMethod {
  cash('نقدي'),
  bankTransfer('تحويل بنكي'),
  cheque('شيك'),
  other('أخرى');

  const PaymentMethod(this.arabicLabel);
  final String arabicLabel;

  static PaymentMethod fromString(String val) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == val,
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// In-memory draft for an invoice line item.
class InvoiceItemDraft {
  const InvoiceItemDraft({
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

/// In-memory draft for recording a customer payment.
class PaymentDraft {
  const PaymentDraft({
    required this.amountPiastres,
    required this.paymentMethod,
    this.paymentDate,
    this.notes,
  });

  final int amountPiastres;
  final PaymentMethod paymentMethod;
  final DateTime? paymentDate;
  final String? notes;
}

/// Persisted line item inside an invoice.
class InvoiceItem {
  const InvoiceItem({
    required this.id,
    required this.invoiceId,
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
  final int invoiceId;
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

/// Persisted payment transaction.
class InvoicePayment {
  const InvoicePayment({
    required this.id,
    required this.invoiceId,
    required this.amountPiastres,
    required this.paymentMethod,
    required this.paymentDate,
    this.notes,
    required this.createdAt,
  });

  final int id;
  final int invoiceId;
  final int amountPiastres;
  final PaymentMethod paymentMethod;
  final DateTime paymentDate;
  final String? notes;
  final DateTime createdAt;

  String get formattedAmountEgp {
    final pounds = amountPiastres ~/ 100;
    final piastres = (amountPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }
}

/// Sales Invoice aggregate root.
class Invoice {
  const Invoice({
    required this.id,
    required this.referenceNumber,
    this.quotationId,
    required this.customerName,
    this.customerPhone,
    required this.status,
    required this.issueDate,
    this.dueDate,
    this.notes,
    required this.subtotalPiastres,
    this.discountPiastres = 0,
    this.taxPiastres = 0,
    required this.grandTotalPiastres,
    this.paidAmountPiastres = 0,
    this.items = const [],
    this.payments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String referenceNumber;
  final int? quotationId;
  final String customerName;
  final String? customerPhone;
  final InvoiceStatus status;
  final DateTime issueDate;
  final DateTime? dueDate;
  final String? notes;
  final int subtotalPiastres;
  final int discountPiastres;
  final int taxPiastres;
  final int grandTotalPiastres;
  final int paidAmountPiastres;
  final List<InvoiceItem> items;
  final List<InvoicePayment> payments;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get remainingBalancePiastres {
    final diff = grandTotalPiastres - paidAmountPiastres;
    return diff > 0 ? diff : 0;
  }

  bool get isFullyPaid => remainingBalancePiastres == 0;

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

  String get formattedGrandTotalEgp {
    final pounds = grandTotalPiastres ~/ 100;
    final piastres = (grandTotalPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }

  String get formattedPaidAmountEgp {
    final pounds = paidAmountPiastres ~/ 100;
    final piastres = (paidAmountPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }

  String get formattedRemainingBalanceEgp {
    final pounds = remainingBalancePiastres ~/ 100;
    final piastres = (remainingBalancePiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }

  Invoice copyWith({
    int? id,
    String? referenceNumber,
    int? quotationId,
    String? customerName,
    String? customerPhone,
    InvoiceStatus? status,
    DateTime? issueDate,
    DateTime? dueDate,
    String? notes,
    int? subtotalPiastres,
    int? discountPiastres,
    int? taxPiastres,
    int? grandTotalPiastres,
    int? paidAmountPiastres,
    List<InvoiceItem>? items,
    List<InvoicePayment>? payments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      quotationId: quotationId ?? this.quotationId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
      paidAmountPiastres: paidAmountPiastres ?? this.paidAmountPiastres,
      items: items ?? this.items,
      payments: payments ?? this.payments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Aggregated dashboard metrics for invoices.
class InvoiceMetrics {
  const InvoiceMetrics({
    required this.totalCount,
    required this.unpaidCount,
    required this.partiallyPaidCount,
    required this.paidCount,
    required this.totalReceivablesPiastres,
    required this.totalPaidPiastres,
  });

  final int totalCount;
  final int unpaidCount;
  final int partiallyPaidCount;
  final int paidCount;
  final int totalReceivablesPiastres;
  final int totalPaidPiastres;

  String get formattedTotalReceivablesEgp {
    final pounds = totalReceivablesPiastres ~/ 100;
    final piastres = (totalReceivablesPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }

  String get formattedTotalPaidEgp {
    final pounds = totalPaidPiastres ~/ 100;
    final piastres = (totalPaidPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }
}
