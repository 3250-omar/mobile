import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/pricing_calculator.dart';
import '../domain/quotation.dart';
import '../domain/quotation_repository.dart';

/// Drift-backed implementation of [QuotationRepository] using transactional SQLite operations.
class DriftQuotationRepository implements QuotationRepository {
  DriftQuotationRepository(
    this._db, {
    this.calculator = const PricingCalculator(),
  });

  final AppDatabase _db;
  final PricingCalculator calculator;

  @override
  Stream<List<Quotation>> watchQuotations({QuotationStatus? statusFilter}) {
    final query = _db.select(_db.quotationsTable);
    if (statusFilter != null) {
      query.where((t) => t.status.equals(statusFilter.name));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.issueDate, mode: OrderingMode.desc),
    ]);

    return query.watch().asyncMap((rows) async {
      final quotations = <Quotation>[];
      for (final row in rows) {
        final items = await _loadItemsForQuotation(row.id);
        quotations.add(_mapToQuotation(row, items));
      }
      return quotations;
    });
  }

  @override
  Future<Quotation?> getQuotationById(int id) async {
    final query = _db.select(_db.quotationsTable)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final items = await _loadItemsForQuotation(row.id);
    return _mapToQuotation(row, items);
  }

  @override
  Future<Quotation?> getQuotationByReference(String referenceNumber) async {
    final query = _db.select(_db.quotationsTable)
      ..where((t) => t.referenceNumber.equals(referenceNumber));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final items = await _loadItemsForQuotation(row.id);
    return _mapToQuotation(row, items);
  }

  @override
  Future<String> generateNextReferenceNumber() async {
    final year = DateTime.now().year;
    final prefix = 'QT-$year-';

    final query = _db.select(_db.quotationsTable)
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
    if (items.isEmpty) {
      throw const AppFailure(
        code: 'EMPTY_QUOTATION_ITEMS',
        messageKey: 'error_empty_quotation_items',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final issueDateMs = (issueDate ?? now).millisecondsSinceEpoch;
    final validUntilMs = validUntil?.millisecondsSinceEpoch;

    final lineTotals = items.map((i) => i.lineTotalPiastres).toList();
    final subtotal = calculator.calculateSubtotal(lineTotals);
    final grandTotal = calculator.calculateGrandTotal(
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );

    final referenceNumber = await generateNextReferenceNumber();

    return _db.transaction(() async {
      final quotationId = await _db
          .into(_db.quotationsTable)
          .insert(
            QuotationCompanion.insert(
              referenceNumber: referenceNumber,
              customerName: customerName.trim(),
              customerPhone: Value(customerPhone?.trim()),
              status: Value(status.name),
              issueDate: issueDateMs,
              validUntil: Value(validUntilMs),
              notes: Value(notes?.trim()),
              subtotalPiastres: Value(subtotal),
              discountPiastres: Value(discountPiastres),
              taxPiastres: Value(taxPiastres),
              grandTotalPiastres: Value(grandTotal),
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      final insertedItems = <QuotationItem>[];
      for (final item in items) {
        final itemId = await _db
            .into(_db.quotationItemsTable)
            .insert(
              QuotationItemCompanion.insert(
                quotationId: quotationId,
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
          QuotationItem(
            id: itemId,
            quotationId: quotationId,
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

      return Quotation(
        id: quotationId,
        referenceNumber: referenceNumber,
        customerName: customerName.trim(),
        customerPhone: customerPhone?.trim(),
        status: status,
        issueDate: DateTime.fromMillisecondsSinceEpoch(issueDateMs),
        validUntil: validUntilMs != null
            ? DateTime.fromMillisecondsSinceEpoch(validUntilMs)
            : null,
        notes: notes?.trim(),
        subtotalPiastres: subtotal,
        discountPiastres: discountPiastres,
        taxPiastres: taxPiastres,
        grandTotalPiastres: grandTotal,
        items: insertedItems,
        createdAt: now,
        updatedAt: now,
      );
    });
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
    final existing = await getQuotationById(id);
    if (existing == null) {
      throw const AppFailure(
        code: 'QUOTATION_NOT_FOUND',
        messageKey: 'error_quotation_not_found',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    if (existing.isLocked) {
      throw const AppFailure(
        code: 'QUOTATION_LOCKED',
        messageKey: 'error_quotation_locked',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    if (items.isEmpty) {
      throw const AppFailure(
        code: 'EMPTY_QUOTATION_ITEMS',
        messageKey: 'error_empty_quotation_items',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final issueDateMs =
        (issueDate ?? existing.issueDate).millisecondsSinceEpoch;
    final validUntilMs = validUntil?.millisecondsSinceEpoch;

    final lineTotals = items.map((i) => i.lineTotalPiastres).toList();
    final subtotal = calculator.calculateSubtotal(lineTotals);
    final grandTotal = calculator.calculateGrandTotal(
      subtotalPiastres: subtotal,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );

    return _db.transaction(() async {
      await (_db.update(
        _db.quotationsTable,
      )..where((t) => t.id.equals(id))).write(
        QuotationCompanion(
          customerName: Value(customerName.trim()),
          customerPhone: Value(customerPhone?.trim()),
          issueDate: Value(issueDateMs),
          validUntil: Value(validUntilMs),
          notes: Value(notes?.trim()),
          subtotalPiastres: Value(subtotal),
          discountPiastres: Value(discountPiastres),
          taxPiastres: Value(taxPiastres),
          grandTotalPiastres: Value(grandTotal),
          updatedAt: Value(nowMs),
        ),
      );

      // Delete existing line items and recreate with updated drafts
      await (_db.delete(
        _db.quotationItemsTable,
      )..where((t) => t.quotationId.equals(id))).go();

      final updatedItems = <QuotationItem>[];
      for (final item in items) {
        final itemId = await _db
            .into(_db.quotationItemsTable)
            .insert(
              QuotationItemCompanion.insert(
                quotationId: id,
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

        updatedItems.add(
          QuotationItem(
            id: itemId,
            quotationId: id,
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

      return Quotation(
        id: id,
        referenceNumber: existing.referenceNumber,
        customerName: customerName.trim(),
        customerPhone: customerPhone?.trim(),
        status: existing.status,
        issueDate: DateTime.fromMillisecondsSinceEpoch(issueDateMs),
        validUntil: validUntilMs != null
            ? DateTime.fromMillisecondsSinceEpoch(validUntilMs)
            : null,
        notes: notes?.trim(),
        subtotalPiastres: subtotal,
        discountPiastres: discountPiastres,
        taxPiastres: taxPiastres,
        grandTotalPiastres: grandTotal,
        items: updatedItems,
        createdAt: existing.createdAt,
        updatedAt: now,
      );
    });
  }

  @override
  Future<void> updateStatus(int id, QuotationStatus status) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(
      _db.quotationsTable,
    )..where((t) => t.id.equals(id))).write(
      QuotationCompanion(status: Value(status.name), updatedAt: Value(nowMs)),
    );
  }

  @override
  Future<void> deleteQuotation(int id) async {
    // Foreign key cascade deletes related quotation_items
    await (_db.delete(_db.quotationsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<Quotation> duplicateQuotation(int id) async {
    final existing = await getQuotationById(id);
    if (existing == null) {
      throw const AppFailure(
        code: 'QUOTATION_NOT_FOUND',
        messageKey: 'error_quotation_not_found',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final itemDrafts = existing.items
        .map(
          (i) => QuotationItemDraft(
            productId: i.productId,
            productCode: i.productCode,
            productName: i.productName,
            unit: i.unit,
            unitPricePiastres: i.unitPricePiastres,
            quantity: i.quantity,
            lineDiscountPiastres: i.lineDiscountPiastres,
          ),
        )
        .toList();

    return createQuotation(
      customerName: '${existing.customerName} (نسخة)',
      customerPhone: existing.customerPhone,
      status: QuotationStatus.draft,
      issueDate: DateTime.now(),
      validUntil: existing.validUntil,
      notes: existing.notes,
      discountPiastres: existing.discountPiastres,
      taxPiastres: existing.taxPiastres,
      items: itemDrafts,
    );
  }

  @override
  Future<QuotationMetrics> getMetrics() async {
    final all = await _db.select(_db.quotationsTable).get();

    int totalCount = all.length;
    int draftsCount = 0;
    int acceptedCount = 0;
    int acceptedTotal = 0;

    for (final q in all) {
      if (q.status == QuotationStatus.draft.name) {
        draftsCount++;
      } else if (q.status == QuotationStatus.accepted.name) {
        acceptedCount++;
        acceptedTotal += q.grandTotalPiastres;
      }
    }

    return QuotationMetrics(
      totalCount: totalCount,
      draftsCount: draftsCount,
      acceptedCount: acceptedCount,
      acceptedTotalPiastres: acceptedTotal,
    );
  }

  Future<List<QuotationItem>> _loadItemsForQuotation(int quotationId) async {
    final query = _db.select(_db.quotationItemsTable)
      ..where((t) => t.quotationId.equals(quotationId));
    final rows = await query.get();

    return rows
        .map(
          (r) => QuotationItem(
            id: r.id,
            quotationId: r.quotationId,
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

  Quotation _mapToQuotation(QuotationEntry row, List<QuotationItem> items) {
    return Quotation(
      id: row.id,
      referenceNumber: row.referenceNumber,
      customerName: row.customerName,
      customerPhone: row.customerPhone,
      status: QuotationStatus.fromString(row.status),
      issueDate: DateTime.fromMillisecondsSinceEpoch(row.issueDate),
      validUntil: row.validUntil != null
          ? DateTime.fromMillisecondsSinceEpoch(row.validUntil!)
          : null,
      notes: row.notes,
      subtotalPiastres: row.subtotalPiastres,
      discountPiastres: row.discountPiastres,
      taxPiastres: row.taxPiastres,
      grandTotalPiastres: row.grandTotalPiastres,
      items: items,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }
}
