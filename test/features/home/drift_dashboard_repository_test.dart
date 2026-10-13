import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/features/home/data/drift_dashboard_repository.dart';
import 'package:offline_quotes/features/home/domain/recent_activity_item.dart';

void main() {
  group('DriftDashboardRepository Tests', () {
    late AppDatabase db;
    late DriftDashboardRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repository = DriftDashboardRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('returns zero metrics on fresh empty database', () async {
      final metrics = await repository.getMetrics();

      expect(metrics.totalProductsCount, 0);
      expect(metrics.totalQuotationsCount, 0);
      expect(metrics.activeQuotationsValuePiastres, 0);
      expect(metrics.totalInvoicesCount, 0);
      expect(metrics.unpaidReceivablesPiastres, 0);
      expect(metrics.collectedRevenuePiastres, 0);
    });

    test('returns empty recent activities list on empty database', () async {
      final activities = await repository.getRecentActivities();
      expect(activities, isEmpty);
    });

    test('accurately aggregates products, quotations, and invoice metrics', () async {
      final now = DateTime.now().millisecondsSinceEpoch;

      // 1. Insert 2 products
      await db
          .into(db.productsTable)
          .insert(
            ProductCompanion.insert(
              code: 'VAL-01',
              name: 'محبس بلية 1/2',
              category: 'محابس',
              unit: 'قطعة',
              unitPricePiastres: 5000,
              normalizedSearchText: 'محبس بليه 1/2',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductCompanion.insert(
              code: 'PIP-01',
              name: 'ماسورة 20 مم',
              category: 'مواسير',
              unit: 'متر',
              unitPricePiastres: 2500,
              normalizedSearchText: 'ماسوره 20 مم',
              createdAt: now,
              updatedAt: now,
            ),
          );

      // 2. Insert 2 quotations (1 accepted: 10,000, 1 rejected: 5,000)
      await db
          .into(db.quotationsTable)
          .insert(
            QuotationCompanion.insert(
              referenceNumber: 'QT-2026-0001',
              customerName: 'طارق علي',
              status: const Value('accepted'),
              issueDate: now,
              subtotalPiastres: const Value(10000),
              grandTotalPiastres: const Value(10000),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.quotationsTable)
          .insert(
            QuotationCompanion.insert(
              referenceNumber: 'QT-2026-0002',
              customerName: 'سامح حسن',
              status: const Value('rejected'),
              issueDate: now,
              subtotalPiastres: const Value(5000),
              grandTotalPiastres: const Value(5000),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // 3. Insert 2 invoices:
      // Inv 1: total 20,000, paid 5,000 (status: partiallyPaid, unpaid: 15,000)
      // Inv 2: total 10,000, paid 10,000 (status: paid, unpaid: 0)
      await db
          .into(db.invoicesTable)
          .insert(
            InvoiceCompanion.insert(
              referenceNumber: 'INV-2026-0001',
              customerName: 'محمود أحمد',
              status: const Value('partiallyPaid'),
              issueDate: now,
              grandTotalPiastres: const Value(20000),
              paidAmountPiastres: const Value(5000),
              createdAt: now,
              updatedAt: now + 10,
            ),
          );
      await db
          .into(db.invoicesTable)
          .insert(
            InvoiceCompanion.insert(
              referenceNumber: 'INV-2026-0002',
              customerName: 'خالد مصطفى',
              status: const Value('paid'),
              issueDate: now,
              grandTotalPiastres: const Value(10000),
              paidAmountPiastres: const Value(10000),
              createdAt: now,
              updatedAt: now + 20,
            ),
          );

      final metrics = await repository.getMetrics();

      expect(metrics.totalProductsCount, 2);
      expect(metrics.totalQuotationsCount, 2);
      // Only accepted quotation counts towards active quotations
      expect(metrics.activeQuotationsValuePiastres, 10000);
      expect(metrics.totalInvoicesCount, 2);
      // Unpaid = 20,000 - 5,000 = 15,000
      expect(metrics.unpaidReceivablesPiastres, 15000);
      // Total collected = 5,000 + 10,000 = 15,000
      expect(metrics.collectedRevenuePiastres, 15000);
    });

    test(
      'retrieves recent activities merged and ordered by updatedAt descending',
      () async {
        const base = 100000;

        await db
            .into(db.quotationsTable)
            .insert(
              QuotationCompanion.insert(
                referenceNumber: 'QT-2026-0001',
                customerName: 'عميل 1',
                status: const Value('draft'),
                issueDate: base,
                grandTotalPiastres: const Value(3000),
                createdAt: base,
                updatedAt: base + 100, // newest quotation
              ),
            );

        await db
            .into(db.invoicesTable)
            .insert(
              InvoiceCompanion.insert(
                referenceNumber: 'INV-2026-0001',
                customerName: 'عميل 2',
                status: const Value('unpaid'),
                issueDate: base,
                grandTotalPiastres: const Value(7000),
                createdAt: base,
                updatedAt: base + 200, // newest overall
              ),
            );

        final activities = await repository.getRecentActivities(limit: 5);

        expect(activities.length, 2);
        expect(activities[0].referenceNumber, 'INV-2026-0001');
        expect(activities[0].type, ActivityType.invoice);
        expect(activities[0].amountPiastres, 7000);

        expect(activities[1].referenceNumber, 'QT-2026-0001');
        expect(activities[1].type, ActivityType.quotation);
        expect(activities[1].amountPiastres, 3000);
      },
    );
  });
}
