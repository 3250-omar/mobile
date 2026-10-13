import 'dart:async';

import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/invoices/domain/invoice.dart';
import 'package:offline_quotes/features/invoices/domain/invoice_pricing_calculator.dart';
import 'package:offline_quotes/features/invoices/domain/invoice_repository.dart';

/// In-memory fake invoice repository for navigation and widget testing.
class FakeInvoiceRepository implements InvoiceRepository {
  FakeInvoiceRepository([List<Invoice>? initialInvoices])
    : _invoices = List.of(initialInvoices ?? []),
      _streamController = StreamController<List<Invoice>>.broadcast() {
    _nextId = _invoices.length + 1;
    _sequenceCounter = _invoices.length + 1;
  }

  final List<Invoice> _invoices;
  final StreamController<List<Invoice>> _streamController;
  final InvoicePricingCalculator _calculator = const InvoicePricingCalculator();
  int _nextId = 1;
  int _sequenceCounter = 1;

  void _notify() {
    _streamController.add(List.unmodifiable(_invoices));
  }

  @override
  Stream<List<Invoice>> watchInvoices({InvoiceStatus? statusFilter}) {
    Stream<List<Invoice>> stream = _streamController.stream;
    if (statusFilter != null) {
      stream = stream.map(
        (list) => list.where((inv) => inv.status == statusFilter).toList(),
      );
    }
    final initialList = statusFilter != null
        ? _invoices.where((inv) => inv.status == statusFilter).toList()
        : List.of(_invoices);
    return Stream.value(initialList).concatWith(stream);
  }

  @override
  Future<Invoice?> getInvoiceById(int id) async {
    return _invoices.where((inv) => inv.id == id).firstOrNull;
  }

  @override
  Future<Invoice?> getInvoiceByReference(String referenceNumber) async {
    return _invoices
        .where((inv) => inv.referenceNumber == referenceNumber)
        .firstOrNull;
  }

  @override
  Future<String> generateNextReferenceNumber() async {
    final year = DateTime.now().year;
    final numStr = (_sequenceCounter++).toString().padLeft(4, '0');
    return 'INV-$year-$numStr';
  }

  @override
  Future<Invoice> createInvoice({
    required String customerName,
    String? customerPhone,
    DateTime? issueDate,
    DateTime? dueDate,
    String? notes,
    int discountPiastres = 0,
    int taxPiastres = 0,
    required List<InvoiceItemDraft> items,
  }) async {
    if (items.isEmpty) {
      throw const AppFailure(
        code: 'EMPTY_INVOICE_ITEMS',
        messageKey: 'error_empty_invoice_items',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final id = _nextId++;
    final ref = await generateNextReferenceNumber();
    final now = DateTime.now();

    final invoiceItems = <InvoiceItem>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final lineTotal = _calculator.calculateLineTotal(
        unitPricePiastres: item.unitPricePiastres,
        quantity: item.quantity,
        lineDiscountPiastres: item.lineDiscountPiastres,
      );
      invoiceItems.add(
        InvoiceItem(
          id: i + 1,
          invoiceId: id,
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
      invoiceItems.map((e) => e.lineTotalPiastres).toList(),
    );
    final total = _calculator.calculateGrandTotal(
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );

    final invoice = Invoice(
      id: id,
      referenceNumber: ref,
      customerName: customerName,
      customerPhone: customerPhone,
      status: InvoiceStatus.unpaid,
      issueDate: issueDate ?? now,
      dueDate: dueDate,
      notes: notes,
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
      grandTotalPiastres: total,
      paidAmountPiastres: 0,
      items: invoiceItems,
      payments: const [],
      createdAt: now,
      updatedAt: now,
    );

    _invoices.insert(0, invoice);
    _notify();
    return invoice;
  }

  @override
  Future<Invoice> convertQuotationToInvoice(int quotationId) async {
    final id = _nextId++;
    final ref = await generateNextReferenceNumber();
    final now = DateTime.now();

    final invoice = Invoice(
      id: id,
      referenceNumber: ref,
      quotationId: quotationId,
      customerName: 'عميل العرض $quotationId',
      customerPhone: '01012345678',
      status: InvoiceStatus.unpaid,
      issueDate: now,
      notes: null,
      subtotalPiastres: 10000,
      discountPiastres: 0,
      taxPiastres: 0,
      grandTotalPiastres: 10000,
      paidAmountPiastres: 0,
      items: [
        InvoiceItem(
          id: 1,
          invoiceId: id,
          productCode: 'PRD-01',
          productName: 'منتج تجريبي',
          unit: 'قطعة',
          unitPricePiastres: 10000,
          quantity: 1,
          lineTotalPiastres: 10000,
        ),
      ],
      payments: const [],
      createdAt: now,
      updatedAt: now,
    );

    _invoices.insert(0, invoice);
    _notify();
    return invoice;
  }

  @override
  Future<Invoice> recordPayment({
    required int invoiceId,
    required int amountPiastres,
    required PaymentMethod paymentMethod,
    DateTime? paymentDate,
    String? notes,
  }) async {
    final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
    if (index < 0) {
      throw const AppFailure(
        code: 'INVOICE_NOT_FOUND',
        messageKey: 'error_invoice_not_found',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }
    final existing = _invoices[index];
    final now = DateTime.now();
    final payment = InvoicePayment(
      id: existing.payments.length + 1,
      invoiceId: invoiceId,
      amountPiastres: amountPiastres,
      paymentMethod: paymentMethod,
      paymentDate: paymentDate ?? now,
      notes: notes,
      createdAt: now,
    );

    final newPaid = existing.paidAmountPiastres + amountPiastres;
    final newStatus = _calculator.resolveStatus(
      grandTotalPiastres: existing.grandTotalPiastres,
      paidAmountPiastres: newPaid,
      currentStatus: existing.status.name,
    );

    final updated = existing.copyWith(
      paidAmountPiastres: newPaid,
      status: InvoiceStatus.fromString(newStatus),
      payments: [...existing.payments, payment],
      updatedAt: now,
    );

    _invoices[index] = updated;
    _notify();
    return updated;
  }

  @override
  Future<void> cancelInvoice(int id) async {
    final index = _invoices.indexWhere((inv) => inv.id == id);
    if (index >= 0) {
      final existing = _invoices[index];
      _invoices[index] = existing.copyWith(
        status: InvoiceStatus.cancelled,
        updatedAt: DateTime.now(),
      );
      _notify();
    }
  }

  @override
  Future<void> deleteInvoice(int id) async {
    _invoices.removeWhere((inv) => inv.id == id);
    _notify();
  }

  @override
  Future<InvoiceMetrics> getMetrics() async {
    var unpaidCount = 0;
    var partiallyPaidCount = 0;
    var paidCount = 0;
    var totalReceivables = 0;
    var totalPaid = 0;

    for (final inv in _invoices) {
      if (inv.status == InvoiceStatus.cancelled) continue;
      totalPaid += inv.paidAmountPiastres;
      final remaining = inv.grandTotalPiastres - inv.paidAmountPiastres;
      if (remaining > 0) {
        totalReceivables += remaining;
      }

      if (inv.status == InvoiceStatus.paid) {
        paidCount++;
      } else if (inv.status == InvoiceStatus.partiallyPaid) {
        partiallyPaidCount++;
      } else {
        unpaidCount++;
      }
    }

    return InvoiceMetrics(
      totalCount: unpaidCount + partiallyPaidCount + paidCount,
      unpaidCount: unpaidCount,
      partiallyPaidCount: partiallyPaidCount,
      paidCount: paidCount,
      totalReceivablesPiastres: totalReceivables,
      totalPaidPiastres: totalPaid,
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
