import 'dart:async';

import 'package:offline_quotes/features/quotations/domain/pricing_calculator.dart';
import 'package:offline_quotes/features/quotations/domain/quotation.dart';
import 'package:offline_quotes/features/quotations/domain/quotation_repository.dart';

/// In-memory fake quotation repository for navigation and widget testing.
class FakeQuotationRepository implements QuotationRepository {
  FakeQuotationRepository([List<Quotation>? initialQuotations])
    : _quotations = List.of(initialQuotations ?? []),
      _streamController = StreamController<List<Quotation>>.broadcast() {
    _nextId = _quotations.length + 1;
    _sequenceCounter = _quotations.length + 1;
  }

  final List<Quotation> _quotations;
  final StreamController<List<Quotation>> _streamController;
  final PricingCalculator _calculator = const PricingCalculator();
  int _nextId = 1;
  int _sequenceCounter = 1;

  void _notify() {
    _streamController.add(List.unmodifiable(_quotations));
  }

  @override
  Stream<List<Quotation>> watchQuotations({QuotationStatus? statusFilter}) {
    // Emit initial immediately on subscription
    Stream<List<Quotation>> stream = _streamController.stream;
    if (statusFilter != null) {
      stream = stream.map(
        (list) => list.where((q) => q.status == statusFilter).toList(),
      );
    }
    // Prepend current state
    final initialList = statusFilter != null
        ? _quotations.where((q) => q.status == statusFilter).toList()
        : List.of(_quotations);
    return Stream.value(initialList).concatWith(stream);
  }

  @override
  Future<Quotation?> getQuotationById(int id) async {
    return _quotations.where((q) => q.id == id).firstOrNull;
  }

  @override
  Future<Quotation?> getQuotationByReference(String referenceNumber) async {
    return _quotations
        .where((q) => q.referenceNumber == referenceNumber)
        .firstOrNull;
  }

  @override
  Future<String> generateNextReferenceNumber() async {
    final year = DateTime.now().year;
    final numStr = (_sequenceCounter++).toString().padLeft(4, '0');
    return 'QT-$year-$numStr';
  }

  @override
  Future<Quotation> createQuotation({
    required String customerName,
    String? customerPhone,
    QuotationStatus status = QuotationStatus.draft,
    DateTime? issueDate,
    DateTime? validUntil,
    String? notes,
    int discountPiastres = 0,
    int taxPiastres = 0,
    required List<QuotationItemDraft> items,
  }) async {
    final id = _nextId++;
    final ref = await generateNextReferenceNumber();
    final now = DateTime.now();

    final quotationItems = <QuotationItem>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final lineTotal = _calculator.calculateLineTotal(
        unitPricePiastres: item.unitPricePiastres,
        quantity: item.quantity,
        lineDiscountPiastres: item.lineDiscountPiastres,
      );
      quotationItems.add(
        QuotationItem(
          id: i + 1,
          quotationId: id,
          productId: item.productId,
          productCode: item.productCode,
          productName: item.productName,
          unit: item.unit,
          unitPricePiastres: item.unitPricePiastres,
          quantity: item.quantity,
          lineDiscountPiastres: item.lineDiscountPiastres,
          lineTotalPiastres: lineTotal,
        ),
      );
    }

    final subtotal = _calculator.calculateSubtotal(
      quotationItems.map((e) => e.lineTotalPiastres).toList(),
    );
    final total = _calculator.calculateGrandTotal(
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );

    final quotation = Quotation(
      id: id,
      referenceNumber: ref,
      customerName: customerName,
      customerPhone: customerPhone,
      status: status,
      issueDate: issueDate ?? now,
      validUntil: validUntil,
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
      grandTotalPiastres: total,
      notes: notes,
      items: quotationItems,
      createdAt: now,
      updatedAt: now,
    );

    _quotations.insert(0, quotation);
    _notify();
    return quotation;
  }

  @override
  Future<Quotation> updateQuotation({
    required int id,
    required String customerName,
    String? customerPhone,
    DateTime? issueDate,
    DateTime? validUntil,
    String? notes,
    int discountPiastres = 0,
    int taxPiastres = 0,
    required List<QuotationItemDraft> items,
  }) async {
    final index = _quotations.indexWhere((q) => q.id == id);
    if (index < 0) {
      throw StateError('Quotation with id $id not found');
    }
    final existing = _quotations[index];

    final quotationItems = <QuotationItem>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final lineTotal = _calculator.calculateLineTotal(
        unitPricePiastres: item.unitPricePiastres,
        quantity: item.quantity,
        lineDiscountPiastres: item.lineDiscountPiastres,
      );
      quotationItems.add(
        QuotationItem(
          id: i + 1,
          quotationId: id,
          productId: item.productId,
          productCode: item.productCode,
          productName: item.productName,
          unit: item.unit,
          unitPricePiastres: item.unitPricePiastres,
          quantity: item.quantity,
          lineDiscountPiastres: item.lineDiscountPiastres,
          lineTotalPiastres: lineTotal,
        ),
      );
    }

    final subtotal = _calculator.calculateSubtotal(
      quotationItems.map((e) => e.lineTotalPiastres).toList(),
    );
    final total = _calculator.calculateGrandTotal(
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );

    final updated = Quotation(
      id: id,
      referenceNumber: existing.referenceNumber,
      customerName: customerName,
      customerPhone: customerPhone,
      status: existing.status,
      issueDate: issueDate ?? existing.issueDate,
      validUntil: validUntil ?? existing.validUntil,
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
      grandTotalPiastres: total,
      notes: notes,
      items: quotationItems,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    _quotations[index] = updated;
    _notify();
    return updated;
  }

  @override
  Future<void> updateStatus(int id, QuotationStatus status) async {
    final index = _quotations.indexWhere((q) => q.id == id);
    if (index >= 0) {
      final existing = _quotations[index];
      _quotations[index] = existing.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      _notify();
    }
  }

  @override
  Future<void> deleteQuotation(int id) async {
    _quotations.removeWhere((q) => q.id == id);
    _notify();
  }

  @override
  Future<Quotation> duplicateQuotation(int id) async {
    final original = await getQuotationById(id);
    if (original == null) {
      throw StateError('Quotation with id $id not found');
    }
    return createQuotation(
      customerName: original.customerName,
      customerPhone: original.customerPhone,
      status: QuotationStatus.draft,
      notes: original.notes,
      discountPiastres: original.discountPiastres,
      taxPiastres: original.taxPiastres,
      items: original.items
          .map(
            (item) => QuotationItemDraft(
              productId: item.productId,
              productCode: item.productCode,
              productName: item.productName,
              unit: item.unit,
              unitPricePiastres: item.unitPricePiastres,
              quantity: item.quantity,
              lineDiscountPiastres: item.lineDiscountPiastres,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<QuotationMetrics> getMetrics() async {
    var draftsCount = 0;
    var acceptedCount = 0;
    var acceptedTotalPiastres = 0;

    for (final q in _quotations) {
      if (q.status == QuotationStatus.draft) {
        draftsCount++;
      } else if (q.status == QuotationStatus.accepted ||
          q.status == QuotationStatus.convertedToInvoice) {
        acceptedCount++;
        acceptedTotalPiastres += q.grandTotalPiastres;
      }
    }

    return QuotationMetrics(
      totalCount: _quotations.length,
      draftsCount: draftsCount,
      acceptedCount: acceptedCount,
      acceptedTotalPiastres: acceptedTotalPiastres,
    );
  }

  void dispose() {
    _streamController.close();
  }
}

extension _StreamConcat<T> on Stream<T> {
  Stream<T> concatWith(Stream<T> other) async* {
    yield* this;
    yield* other;
  }
}
