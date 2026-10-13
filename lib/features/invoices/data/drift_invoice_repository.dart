import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/invoice.dart';
import '../domain/invoice_pricing_calculator.dart';
import '../domain/invoice_repository.dart';

/// Drift-backed implementation of [InvoiceRepository] using transactional SQLite operations.
class DriftInvoiceRepository implements InvoiceRepository {
  DriftInvoiceRepository(
    this._db, {
    this.calculator = const InvoicePricingCalculator(),
  });

  final AppDatabase _db;
  final InvoicePricingCalculator calculator;

  @override
  Stream<List<Invoice>> watchInvoices({InvoiceStatus? statusFilter}) {
    final query = _db.select(_db.invoicesTable);
    if (statusFilter != null) {
      query.where((t) => t.status.equals(statusFilter.name));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.issueDate, mode: OrderingMode.desc),
    ]);

    return query.watch().asyncMap((rows) async {
      final invoices = <Invoice>[];
      for (final row in rows) {
        final items = await _loadItemsForInvoice(row.id);
        final payments = await _loadPaymentsForInvoice(row.id);
        invoices.add(_mapToInvoice(row, items, payments));
      }
      return invoices;
    });
  }

  @override
  Future<Invoice?> getInvoiceById(int id) async {
    final query = _db.select(_db.invoicesTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final items = await _loadItemsForInvoice(row.id);
    final payments = await _loadPaymentsForInvoice(row.id);
    return _mapToInvoice(row, items, payments);
  }

  @override
  Future<Invoice?> getInvoiceByReference(String referenceNumber) async {
    final query = _db.select(_db.invoicesTable)
      ..where((t) => t.referenceNumber.equals(referenceNumber));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final items = await _loadItemsForInvoice(row.id);
    final payments = await _loadPaymentsForInvoice(row.id);
    return _mapToInvoice(row, items, payments);
  }

  @override
  Future<String> generateNextReferenceNumber() async {
    final year = DateTime.now().year;
    final prefix = 'INV-$year-';

    final query = _db.select(_db.invoicesTable)
      ..where((t) => t.referenceNumber.like('$prefix%'))
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ])
      ..limit(1);

    final last = await query.getSingleOrNull();
    int nextSeq = 1;

    if (last != null) {
      final suffix = last.referenceNumber.replaceFirst(prefix, '');
      final parsed = int.tryParse(suffix);
      if (parsed != null) {
        nextSeq = parsed + 1;
      }
    }

    final seqStr = nextSeq.toString().padLeft(4, '0');
    return '$prefix$seqStr';
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

    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final issueDateMs = (issueDate ?? now).millisecondsSinceEpoch;
    final dueDateMs = dueDate?.millisecondsSinceEpoch;

    final lineTotals = items.map((i) => i.lineTotalPiastres).toList();
    final subtotal = calculator.calculateSubtotal(lineTotals);
    final grandTotal = calculator.calculateGrandTotal(
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );

    final referenceNumber = await generateNextReferenceNumber();

    return _db.transaction(() async {
      final invoiceId = await _db
          .into(_db.invoicesTable)
          .insert(
            InvoiceCompanion.insert(
              referenceNumber: referenceNumber,
              customerName: customerName.trim(),
              customerPhone: Value(customerPhone?.trim()),
              status: const Value('unpaid'),
              issueDate: issueDateMs,
              dueDate: Value(dueDateMs),
              notes: Value(notes?.trim()),
              subtotalPiastres: Value(subtotal),
              discountPiastres: Value(discountPiastres),
              taxPiastres: Value(taxPiastres),
              grandTotalPiastres: Value(grandTotal),
              paidAmountPiastres: const Value(0),
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      final insertedItems = <InvoiceItem>[];
      for (final item in items) {
        final itemId = await _db
            .into(_db.invoiceItemsTable)
            .insert(
              InvoiceItemCompanion.insert(
                invoiceId: invoiceId,
                productId: Value(item.productId),
                productCode: item.productCode,
                productName: item.productName,
                unit: item.unit,
                unitPricePiastres: item.unitPricePiastres,
                quantity: item.quantity,
                lineDiscountPiastres: Value(item.lineDiscountPiastres),
                lineTotalPiastres: item.lineTotalPiastres,
              ),
            );

        insertedItems.add(
          InvoiceItem(
            id: itemId,
            invoiceId: invoiceId,
            productId: item.productId,
            productCode: item.productCode,
            productName: item.productName,
            unit: item.unit,
            unitPricePiastres: item.unitPricePiastres,
            quantity: item.quantity,
            lineDiscountPiastres: item.lineDiscountPiastres,
            lineTotalPiastres: item.lineTotalPiastres,
          ),
        );
      }

      return Invoice(
        id: invoiceId,
        referenceNumber: referenceNumber,
        customerName: customerName.trim(),
        customerPhone: customerPhone?.trim(),
        status: InvoiceStatus.unpaid,
        issueDate: DateTime.fromMillisecondsSinceEpoch(issueDateMs),
        dueDate: dueDateMs != null
            ? DateTime.fromMillisecondsSinceEpoch(dueDateMs)
            : null,
        notes: notes?.trim(),
        subtotalPiastres: subtotal,
        discountPiastres: discountPiastres,
        taxPiastres: taxPiastres,
        grandTotalPiastres: grandTotal,
        paidAmountPiastres: 0,
        items: insertedItems,
        payments: const [],
        createdAt: now,
        updatedAt: now,
      );
    });
  }

  @override
  Future<Invoice> convertQuotationToInvoice(int quotationId) async {
    return _db.transaction(() async {
      final quotationQuery = _db.select(_db.quotationsTable)
        ..where((t) => t.id.equals(quotationId));
      final quotation = await quotationQuery.getSingleOrNull();

      if (quotation == null) {
        throw const AppFailure(
          code: 'QUOTATION_NOT_FOUND',
          messageKey: 'error_quotation_not_found',
          category: AppFailureCategory.validation,
          retryable: false,
        );
      }

      if (quotation.status == 'convertedToInvoice') {
        throw const AppFailure(
          code: 'QUOTATION_ALREADY_CONVERTED',
          messageKey: 'error_quotation_already_converted',
          category: AppFailureCategory.validation,
          retryable: false,
        );
      }

      final itemsQuery = _db.select(_db.quotationItemsTable)
        ..where((t) => t.quotationId.equals(quotationId));
      final quotationItems = await itemsQuery.get();

      if (quotationItems.isEmpty) {
        throw const AppFailure(
          code: 'EMPTY_QUOTATION_ITEMS',
          messageKey: 'error_empty_quotation_items',
          category: AppFailureCategory.validation,
          retryable: false,
        );
      }

      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;
      final referenceNumber = await generateNextReferenceNumber();

      final invoiceId = await _db
          .into(_db.invoicesTable)
          .insert(
            InvoiceCompanion.insert(
              referenceNumber: referenceNumber,
              quotationId: Value(quotationId),
              customerName: quotation.customerName,
              customerPhone: Value(quotation.customerPhone),
              status: const Value('unpaid'),
              issueDate: nowMs,
              notes: Value(quotation.notes),
              subtotalPiastres: Value(quotation.subtotalPiastres),
              discountPiastres: Value(quotation.discountPiastres),
              taxPiastres: Value(quotation.taxPiastres),
              grandTotalPiastres: Value(quotation.grandTotalPiastres),
              paidAmountPiastres: const Value(0),
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      final insertedItems = <InvoiceItem>[];
      for (final item in quotationItems) {
        final itemId = await _db
            .into(_db.invoiceItemsTable)
            .insert(
              InvoiceItemCompanion.insert(
                invoiceId: invoiceId,
                productId: Value(item.productId),
                productCode: item.productCode,
                productName: item.productName,
                unit: item.unit,
                unitPricePiastres: item.unitPricePiastres,
                quantity: item.quantity,
                lineDiscountPiastres: Value(item.lineDiscountPiastres),
                lineTotalPiastres: item.lineTotalPiastres,
              ),
            );

        insertedItems.add(
          InvoiceItem(
            id: itemId,
            invoiceId: invoiceId,
            productId: item.productId,
            productCode: item.productCode,
            productName: item.productName,
            unit: item.unit,
            unitPricePiastres: item.unitPricePiastres,
            quantity: item.quantity,
            lineDiscountPiastres: item.lineDiscountPiastres,
            lineTotalPiastres: item.lineTotalPiastres,
          ),
        );
      }

      // Mark the quotation as converted to invoice
      await (_db.update(
        _db.quotationsTable,
      )..where((t) => t.id.equals(quotationId))).write(
        QuotationCompanion(
          status: const Value('convertedToInvoice'),
          updatedAt: Value(nowMs),
        ),
      );

      return Invoice(
        id: invoiceId,
        referenceNumber: referenceNumber,
        quotationId: quotationId,
        customerName: quotation.customerName,
        customerPhone: quotation.customerPhone,
        status: InvoiceStatus.unpaid,
        issueDate: now,
        notes: quotation.notes,
        subtotalPiastres: quotation.subtotalPiastres,
        discountPiastres: quotation.discountPiastres,
        taxPiastres: quotation.taxPiastres,
        grandTotalPiastres: quotation.grandTotalPiastres,
        paidAmountPiastres: 0,
        items: insertedItems,
        payments: const [],
        createdAt: now,
        updatedAt: now,
      );
    });
  }

  @override
  Future<Invoice> recordPayment({
    required int invoiceId,
    required int amountPiastres,
    required PaymentMethod paymentMethod,
    DateTime? paymentDate,
    String? notes,
  }) async {
    if (amountPiastres <= 0) {
      throw const AppFailure(
        code: 'INVALID_PAYMENT_AMOUNT',
        messageKey: 'error_invalid_payment_amount',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    return _db.transaction(() async {
      final invoiceQuery = _db.select(_db.invoicesTable)
        ..where((t) => t.id.equals(invoiceId));
      final invoice = await invoiceQuery.getSingleOrNull();

      if (invoice == null) {
        throw const AppFailure(
          code: 'INVOICE_NOT_FOUND',
          messageKey: 'error_invoice_not_found',
          category: AppFailureCategory.validation,
          retryable: false,
        );
      }

      if (invoice.status == 'cancelled') {
        throw const AppFailure(
          code: 'INVOICE_CANCELLED',
          messageKey: 'error_invoice_cancelled',
          category: AppFailureCategory.validation,
          retryable: false,
        );
      }

      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;
      final paymentDateMs = (paymentDate ?? now).millisecondsSinceEpoch;

      final newPaidAmount = invoice.paidAmountPiastres + amountPiastres;
      final newStatus = calculator.resolveStatus(
        grandTotalPiastres: invoice.grandTotalPiastres,
        paidAmountPiastres: newPaidAmount,
        currentStatus: invoice.status,
      );

      await _db
          .into(_db.invoicePaymentsTable)
          .insert(
            InvoicePaymentCompanion.insert(
              invoiceId: invoiceId,
              amountPiastres: amountPiastres,
              paymentMethod: Value(paymentMethod.name),
              paymentDate: paymentDateMs,
              notes: Value(notes?.trim()),
              createdAt: nowMs,
            ),
          );

      await (_db.update(
        _db.invoicesTable,
      )..where((t) => t.id.equals(invoiceId))).write(
        InvoiceCompanion(
          paidAmountPiastres: Value(newPaidAmount),
          status: Value(newStatus),
          updatedAt: Value(nowMs),
        ),
      );

      final items = await _loadItemsForInvoice(invoiceId);
      final payments = await _loadPaymentsForInvoice(invoiceId);

      return Invoice(
        id: invoice.id,
        referenceNumber: invoice.referenceNumber,
        quotationId: invoice.quotationId,
        customerName: invoice.customerName,
        customerPhone: invoice.customerPhone,
        status: InvoiceStatus.fromString(newStatus),
        issueDate: DateTime.fromMillisecondsSinceEpoch(invoice.issueDate),
        dueDate: invoice.dueDate != null
            ? DateTime.fromMillisecondsSinceEpoch(invoice.dueDate!)
            : null,
        notes: invoice.notes,
        subtotalPiastres: invoice.subtotalPiastres,
        discountPiastres: invoice.discountPiastres,
        taxPiastres: invoice.taxPiastres,
        grandTotalPiastres: invoice.grandTotalPiastres,
        paidAmountPiastres: newPaidAmount,
        items: items,
        payments: payments,
        createdAt: DateTime.fromMillisecondsSinceEpoch(invoice.createdAt),
        updatedAt: now,
      );
    });
  }

  @override
  Future<void> cancelInvoice(int id) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.invoicesTable)..where((t) => t.id.equals(id))).write(
      InvoiceCompanion(
        status: const Value('cancelled'),
        updatedAt: Value(nowMs),
      ),
    );
  }

  @override
  Future<void> deleteInvoice(int id) async {
    // Foreign key cascade deletes related invoice_items and invoice_payments
    await (_db.delete(_db.invoicesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<InvoiceMetrics> getMetrics() async {
    final all = await _db.select(_db.invoicesTable).get();

    int totalCount = 0;
    int unpaidCount = 0;
    int partiallyPaidCount = 0;
    int paidCount = 0;
    int totalReceivables = 0;
    int totalPaid = 0;

    for (final inv in all) {
      if (inv.status == 'cancelled') continue;

      totalCount++;
      totalPaid += inv.paidAmountPiastres;

      final remaining = inv.grandTotalPiastres - inv.paidAmountPiastres;
      if (remaining > 0) {
        totalReceivables += remaining;
      }

      if (inv.status == InvoiceStatus.paid.name) {
        paidCount++;
      } else if (inv.status == InvoiceStatus.partiallyPaid.name) {
        partiallyPaidCount++;
      } else {
        unpaidCount++;
      }
    }

    return InvoiceMetrics(
      totalCount: totalCount,
      unpaidCount: unpaidCount,
      partiallyPaidCount: partiallyPaidCount,
      paidCount: paidCount,
      totalReceivablesPiastres: totalReceivables,
      totalPaidPiastres: totalPaid,
    );
  }

  Future<List<InvoiceItem>> _loadItemsForInvoice(int invoiceId) async {
    final query = _db.select(_db.invoiceItemsTable)
      ..where((t) => t.invoiceId.equals(invoiceId));
    final rows = await query.get();

    return rows
        .map(
          (r) => InvoiceItem(
            id: r.id,
            invoiceId: r.invoiceId,
            productId: r.productId,
            productCode: r.productCode,
            productName: r.productName,
            unit: r.unit,
            unitPricePiastres: r.unitPricePiastres,
            quantity: r.quantity,
            lineDiscountPiastres: r.lineDiscountPiastres,
            lineTotalPiastres: r.lineTotalPiastres,
          ),
        )
        .toList();
  }

  Future<List<InvoicePayment>> _loadPaymentsForInvoice(int invoiceId) async {
    final query = _db.select(_db.invoicePaymentsTable)
      ..where((t) => t.invoiceId.equals(invoiceId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.paymentDate, mode: OrderingMode.asc),
      ]);
    final rows = await query.get();

    return rows
        .map(
          (r) => InvoicePayment(
            id: r.id,
            invoiceId: r.invoiceId,
            amountPiastres: r.amountPiastres,
            paymentMethod: PaymentMethod.fromString(r.paymentMethod),
            paymentDate: DateTime.fromMillisecondsSinceEpoch(r.paymentDate),
            notes: r.notes,
            createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
          ),
        )
        .toList();
  }

  Invoice _mapToInvoice(
    InvoiceEntry row,
    List<InvoiceItem> items,
    List<InvoicePayment> payments,
  ) {
    return Invoice(
      id: row.id,
      referenceNumber: row.referenceNumber,
      quotationId: row.quotationId,
      customerName: row.customerName,
      customerPhone: row.customerPhone,
      status: InvoiceStatus.fromString(row.status),
      issueDate: DateTime.fromMillisecondsSinceEpoch(row.issueDate),
      dueDate: row.dueDate != null
          ? DateTime.fromMillisecondsSinceEpoch(row.dueDate!)
          : null,
      notes: row.notes,
      subtotalPiastres: row.subtotalPiastres,
      discountPiastres: row.discountPiastres,
      taxPiastres: row.taxPiastres,
      grandTotalPiastres: row.grandTotalPiastres,
      paidAmountPiastres: row.paidAmountPiastres,
      items: items,
      payments: payments,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }
}
