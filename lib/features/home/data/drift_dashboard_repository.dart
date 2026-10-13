import 'dart:async';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failure_mapper.dart';
import '../domain/dashboard_metrics.dart';
import '../domain/dashboard_repository.dart';
import '../domain/recent_activity_item.dart';

/// Drift-backed implementation of [DashboardRepository] utilizing fast SQLite aggregations.
class DriftDashboardRepository implements DashboardRepository {
  DriftDashboardRepository(this._db);

  final AppDatabase _db;

  @override
  Future<DashboardMetrics> getMetrics() async {
    try {
      // 1. Total products count
      final productsCountExp = _db.productsTable.id.count();
      final productsQuery = _db.selectOnly(_db.productsTable)
        ..addColumns([productsCountExp]);
      final productsRow = await productsQuery.getSingle();
      final totalProducts = productsRow.read(productsCountExp) ?? 0;

      // 2. Total quotations count
      final quotationsCountExp = _db.quotationsTable.id.count();
      final quotationsQuery = _db.selectOnly(_db.quotationsTable)
        ..addColumns([quotationsCountExp]);
      final quotationsRow = await quotationsQuery.getSingle();
      final totalQuotations = quotationsRow.read(quotationsCountExp) ?? 0;

      // 3. Active quotations value (excluding rejected)
      final activeQuotationsSumExp = _db.quotationsTable.grandTotalPiastres
          .sum();
      final activeQuotationsQuery = _db.selectOnly(_db.quotationsTable)
        ..addColumns([activeQuotationsSumExp])
        ..where(_db.quotationsTable.status.isNotValue('rejected'));
      final activeQuotationsRow = await activeQuotationsQuery.getSingle();
      final activeQuotationsValue =
          activeQuotationsRow.read(activeQuotationsSumExp) ?? 0;

      // 4. Total invoices count
      final invoicesCountExp = _db.invoicesTable.id.count();
      final invoicesQuery = _db.selectOnly(_db.invoicesTable)
        ..addColumns([invoicesCountExp]);
      final invoicesRow = await invoicesQuery.getSingle();
      final totalInvoices = invoicesRow.read(invoicesCountExp) ?? 0;

      // 5. Unpaid receivables (grandTotal - paidAmount) for unpaid / partiallyPaid invoices
      final grandTotalExp = _db.invoicesTable.grandTotalPiastres.sum();
      final paidAmountExp = _db.invoicesTable.paidAmountPiastres.sum();
      final unpaidInvoicesQuery = _db.selectOnly(_db.invoicesTable)
        ..addColumns([grandTotalExp, paidAmountExp])
        ..where(_db.invoicesTable.status.isNotValue('paid'));
      final unpaidRow = await unpaidInvoicesQuery.getSingle();
      final unpaidGrand = unpaidRow.read(grandTotalExp) ?? 0;
      final unpaidPaid = unpaidRow.read(paidAmountExp) ?? 0;
      final unpaidReceivables = (unpaidGrand - unpaidPaid) > 0
          ? (unpaidGrand - unpaidPaid)
          : 0;

      // 6. Collected revenue (all paid amounts across invoices)
      final revenueExp = _db.invoicesTable.paidAmountPiastres.sum();
      final revenueQuery = _db.selectOnly(_db.invoicesTable)
        ..addColumns([revenueExp]);
      final revenueRow = await revenueQuery.getSingle();
      final collectedRevenue = revenueRow.read(revenueExp) ?? 0;

      return DashboardMetrics(
        totalProductsCount: totalProducts,
        totalQuotationsCount: totalQuotations,
        activeQuotationsValuePiastres: activeQuotationsValue,
        totalInvoicesCount: totalInvoices,
        unpaidReceivablesPiastres: unpaidReceivables,
        collectedRevenuePiastres: collectedRevenue,
      );
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Stream<DashboardMetrics> watchMetrics() {
    late StreamController<DashboardMetrics> controller;
    StreamSubscription<List<ProductEntry>>? sub1;
    StreamSubscription<List<QuotationEntry>>? sub2;
    StreamSubscription<List<InvoiceEntry>>? sub3;

    Future<void> emitLatest() async {
      if (controller.isClosed) return;
      try {
        final metrics = await getMetrics();
        if (!controller.isClosed) {
          controller.add(metrics);
        }
      } catch (e, st) {
        if (!controller.isClosed) {
          controller.addError(FailureMapper.map(e, stackTrace: st));
        }
      }
    }

    controller = StreamController<DashboardMetrics>(
      onListen: () {
        emitLatest();
        sub1 = _db
            .select(_db.productsTable)
            .watch()
            .listen((_) => emitLatest());
        sub2 = _db
            .select(_db.quotationsTable)
            .watch()
            .listen((_) => emitLatest());
        sub3 = _db
            .select(_db.invoicesTable)
            .watch()
            .listen((_) => emitLatest());
      },
      onCancel: () async {
        await sub1?.cancel();
        await sub2?.cancel();
        await sub3?.cancel();
      },
    );

    return controller.stream;
  }

  @override
  Future<List<RecentActivityItem>> getRecentActivities({int limit = 5}) async {
    try {
      final quotationQuery = _db.select(_db.quotationsTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
        ])
        ..limit(limit);
      final quotationRows = await quotationQuery.get();

      final invoiceQuery = _db.select(_db.invoicesTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
        ])
        ..limit(limit);
      final invoiceRows = await invoiceQuery.get();

      final items = <RecentActivityItem>[];

      for (final q in quotationRows) {
        items.add(
          RecentActivityItem(
            id: q.id,
            type: ActivityType.quotation,
            referenceNumber: q.referenceNumber,
            customerName: q.customerName,
            amountPiastres: q.grandTotalPiastres,
            status: q.status,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(q.updatedAt),
          ),
        );
      }

      for (final inv in invoiceRows) {
        items.add(
          RecentActivityItem(
            id: inv.id,
            type: ActivityType.invoice,
            referenceNumber: inv.referenceNumber,
            customerName: inv.customerName,
            amountPiastres: inv.grandTotalPiastres,
            status: inv.status,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(inv.updatedAt),
          ),
        );
      }

      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return items.take(limit).toList();
    } catch (e, st) {
      throw FailureMapper.map(e, stackTrace: st);
    }
  }

  @override
  Stream<List<RecentActivityItem>> watchRecentActivities({int limit = 5}) {
    late StreamController<List<RecentActivityItem>> controller;
    StreamSubscription<List<QuotationEntry>>? sub1;
    StreamSubscription<List<InvoiceEntry>>? sub2;

    Future<void> emitLatest() async {
      if (controller.isClosed) return;
      try {
        final activities = await getRecentActivities(limit: limit);
        if (!controller.isClosed) {
          controller.add(activities);
        }
      } catch (e, st) {
        if (!controller.isClosed) {
          controller.addError(FailureMapper.map(e, stackTrace: st));
        }
      }
    }

    controller = StreamController<List<RecentActivityItem>>(
      onListen: () {
        emitLatest();
        sub1 = _db
            .select(_db.quotationsTable)
            .watch()
            .listen((_) => emitLatest());
        sub2 = _db
            .select(_db.invoicesTable)
            .watch()
            .listen((_) => emitLatest());
      },
      onCancel: () async {
        await sub1?.cancel();
        await sub2?.cancel();
      },
    );

    return controller.stream;
  }
}
