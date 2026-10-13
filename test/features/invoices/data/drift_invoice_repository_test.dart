import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/invoices/data/drift_invoice_repository.dart';
import 'package:offline_quotes/features/invoices/domain/invoice.dart';

void main() {
  group('DriftInvoiceRepository', () {
    late AppDatabase db;
    late DriftInvoiceRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftInvoiceRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'generates sequential reference numbers in INV-YYYY-#### format',
      () async {
        final ref1 = await repo.generateNextReferenceNumber();
        final year = DateTime.now().year;
        expect(ref1, 'INV-$year-0001');

        // Create an invoice
        await repo.createInvoice(
          customerName: 'شركة الأهرام',
          items: const [
            InvoiceItemDraft(
              productCode: 'PRD-01',
              productName: 'أنبوب 1 بوصة',
              unit: 'متر',
              unitPricePiastres: 5000,
              quantity: 2,
            ),
          ],
        );

        final ref2 = await repo.generateNextReferenceNumber();
        expect(ref2, 'INV-$year-0002');
      },
    );

    test('creates invoice with items, integer totals, and defaults to unpaid status', () async {
      final invoice = await repo.createInvoice(
        customerName: 'مؤسسة السلام',
        customerPhone: '01099998888',
        discountPiastres: 500,
        taxPiastres: 1400,
        items: const [
          InvoiceItemDraft(
            productCode: 'VAL-01',
            productName: 'محبس نحاس',
            unit: 'قطعة',
            unitPricePiastres: 10000,
            quantity: 3,
            lineDiscountPiastres: 1000,
          ),
        ],
      );

      expect(invoice.id, greaterThan(0));
      expect(invoice.customerName, 'مؤسسة السلام');
      expect(invoice.customerPhone, '01099998888');
      expect(invoice.status, InvoiceStatus.unpaid);
      expect(invoice.paidAmountPiastres, 0);
      expect(invoice.items.length, 1);

      // Line total: (10000 * 3) - 1000 = 29000
      expect(invoice.items.first.lineTotalPiastres, 29000);
      expect(invoice.subtotalPiastres, 29000);
      expect(invoice.discountPiastres, 500);
      expect(invoice.taxPiastres, 1400);
      // Grand total: 29000 - 500 + 1400 = 29900
      expect(invoice.grandTotalPiastres, 29900);
      expect(invoice.remainingBalancePiastres, 29900);
    });

    test('throws AppFailure when creating invoice with empty items', () async {
      expect(
        () =>
            repo.createInvoice(customerName: 'عميل بدون بنود', items: const []),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.code,
            'code',
            'EMPTY_INVOICE_ITEMS',
          ),
        ),
      );
    });

    test('converts accepted quotation into sales invoice copying frozen snapshot items', () async {
      final nowMs = DateTime.now().millisecondsSinceEpoch;

      // Seed a quotation in database
      final quotationId = await db
          .into(db.quotationsTable)
          .insert(
            QuotationCompanion.insert(
              referenceNumber: 'QT-2026-0001',
              customerName: 'شركة المقاولات المتحدة',
              customerPhone: const Value('01122334455'),
              status: const Value('accepted'),
              issueDate: nowMs,
              notes: const Value('خصم خاص للمقاول'),
              subtotalPiastres: const Value(50000),
              discountPiastres: const Value(2000),
              taxPiastres: const Value(0),
              grandTotalPiastres: const Value(48000),
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      await db
          .into(db.quotationItemsTable)
          .insert(
            QuotationItemCompanion.insert(
              quotationId: quotationId,
              productCode: 'PIPE-50',
              productName: 'مواسير 2 بوصة',
              unit: 'متر',
              unitPricePiastres: 5000,
              quantity: 10,
              lineDiscountPiastres: const Value(2000),
              lineTotalPiastres: 48000,
            ),
          );

      // Convert to invoice
      final invoice = await repo.convertQuotationToInvoice(quotationId);

      expect(invoice.id, greaterThan(0));
      expect(invoice.quotationId, quotationId);
      expect(invoice.customerName, 'شركة المقاولات المتحدة');
      expect(invoice.customerPhone, '01122334455');
      expect(invoice.status, InvoiceStatus.unpaid);
      expect(invoice.grandTotalPiastres, 48000);
      expect(invoice.items.length, 1);
      expect(invoice.items.first.productCode, 'PIPE-50');

      // Verify quotation status is now convertedToInvoice
      final updatedQuotation = await (db.select(
        db.quotationsTable,
      )..where((t) => t.id.equals(quotationId))).getSingle();
      expect(updatedQuotation.status, 'convertedToInvoice');

      // Attempting to convert again should throw QUOTATION_ALREADY_CONVERTED
      expect(
        () => repo.convertQuotationToInvoice(quotationId),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.code,
            'code',
            'QUOTATION_ALREADY_CONVERTED',
          ),
        ),
      );
    });

    test('records payment installments transitioning unpaid -> partiallyPaid -> paid', () async {
      final invoice = await repo.createInvoice(
        customerName: 'مؤسسة الرضا',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-1',
            productName: 'خلاط مياه',
            unit: 'قطعة',
            unitPricePiastres: 10000,
            quantity: 1,
          ),
        ],
      );

      expect(invoice.status, InvoiceStatus.unpaid);
      expect(invoice.grandTotalPiastres, 10000);

      // 1. First partial payment: 4000
      final afterPay1 = await repo.recordPayment(
        invoiceId: invoice.id,
        amountPiastres: 4000,
        paymentMethod: PaymentMethod.cash,
        notes: 'دفعة أولى نقداً',
      );

      expect(afterPay1.paidAmountPiastres, 4000);
      expect(afterPay1.remainingBalancePiastres, 6000);
      expect(afterPay1.status, InvoiceStatus.partiallyPaid);
      expect(afterPay1.payments.length, 1);
      expect(afterPay1.payments.first.amountPiastres, 4000);
      expect(afterPay1.payments.first.paymentMethod, PaymentMethod.cash);

      // 2. Second payment: 6000 (completes full payment)
      final afterPay2 = await repo.recordPayment(
        invoiceId: invoice.id,
        amountPiastres: 6000,
        paymentMethod: PaymentMethod.bankTransfer,
        notes: 'تحويل بنكي للمتبقي',
      );

      expect(afterPay2.paidAmountPiastres, 10000);
      expect(afterPay2.remainingBalancePiastres, 0);
      expect(afterPay2.status, InvoiceStatus.paid);
      expect(afterPay2.isFullyPaid, isTrue);
      expect(afterPay2.payments.length, 2);
    });

    test('throws AppFailure when payment amount is invalid or invoice is cancelled', () async {
      final invoice = await repo.createInvoice(
        customerName: 'تجربة الإلغاء',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-1',
            productName: 'منتج',
            unit: 'قطعة',
            unitPricePiastres: 5000,
            quantity: 1,
          ),
        ],
      );

      // Invalid amount
      expect(
        () => repo.recordPayment(
          invoiceId: invoice.id,
          amountPiastres: 0,
          paymentMethod: PaymentMethod.cash,
        ),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.code,
            'code',
            'INVALID_PAYMENT_AMOUNT',
          ),
        ),
      );

      // Cancel invoice
      await repo.cancelInvoice(invoice.id);
      final cancelled = await repo.getInvoiceById(invoice.id);
      expect(cancelled?.status, InvoiceStatus.cancelled);

      // Paying cancelled invoice
      expect(
        () => repo.recordPayment(
          invoiceId: invoice.id,
          amountPiastres: 1000,
          paymentMethod: PaymentMethod.cash,
        ),
        throwsA(
          isA<AppFailure>().having((e) => e.code, 'code', 'INVOICE_CANCELLED'),
        ),
      );
    });

    test('deletes invoice cascading to items and payments', () async {
      final invoice = await repo.createInvoice(
        customerName: 'عميل للحذف',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-1',
            productName: 'منتج',
            unit: 'قطعة',
            unitPricePiastres: 5000,
            quantity: 1,
          ),
        ],
      );

      await repo.recordPayment(
        invoiceId: invoice.id,
        amountPiastres: 2000,
        paymentMethod: PaymentMethod.cash,
      );

      // Verify items and payments exist
      expect((await (db.select(db.invoiceItemsTable)).get()).length, 1);
      expect((await (db.select(db.invoicePaymentsTable)).get()).length, 1);

      // Delete invoice
      await repo.deleteInvoice(invoice.id);

      expect(await repo.getInvoiceById(invoice.id), isNull);
      expect(await (db.select(db.invoiceItemsTable)).get(), isEmpty);
      expect(await (db.select(db.invoicePaymentsTable)).get(), isEmpty);
    });

    test('computes aggregated metrics across invoices accurately', () async {
      // 1. Unpaid: grandTotal = 10000, paid = 0
      await repo.createInvoice(
        customerName: 'عميل 1',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-1',
            productName: 'منتج 1',
            unit: 'قطعة',
            unitPricePiastres: 10000,
            quantity: 1,
          ),
        ],
      );

      // 2. Partially paid: grandTotal = 20000, paid = 5000
      final inv2 = await repo.createInvoice(
        customerName: 'عميل 2',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-2',
            productName: 'منتج 2',
            unit: 'قطعة',
            unitPricePiastres: 20000,
            quantity: 1,
          ),
        ],
      );
      await repo.recordPayment(
        invoiceId: inv2.id,
        amountPiastres: 5000,
        paymentMethod: PaymentMethod.cash,
      );

      // 3. Paid: grandTotal = 15000, paid = 15000
      final inv3 = await repo.createInvoice(
        customerName: 'عميل 3',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-3',
            productName: 'منتج 3',
            unit: 'قطعة',
            unitPricePiastres: 15000,
            quantity: 1,
          ),
        ],
      );
      await repo.recordPayment(
        invoiceId: inv3.id,
        amountPiastres: 15000,
        paymentMethod: PaymentMethod.bankTransfer,
      );

      // 4. Cancelled: grandTotal = 8000, paid = 0
      final inv4 = await repo.createInvoice(
        customerName: 'عميل 4 ملغي',
        items: const [
          InvoiceItemDraft(
            productCode: 'P-4',
            productName: 'منتج 4',
            unit: 'قطعة',
            unitPricePiastres: 8000,
            quantity: 1,
          ),
        ],
      );
      await repo.cancelInvoice(inv4.id);

      final metrics = await repo.getMetrics();
      // Total active count: 3 (cancelled is excluded from active count)
      expect(metrics.totalCount, 3);
      expect(metrics.unpaidCount, 1);
      expect(metrics.partiallyPaidCount, 1);
      expect(metrics.paidCount, 1);
      // Total paid: 5000 + 15000 = 20000
      expect(metrics.totalPaidPiastres, 20000);
      // Receivables: (10000 - 0) + (20000 - 5000) = 25000
      expect(metrics.totalReceivablesPiastres, 25000);
    });
  });
}
