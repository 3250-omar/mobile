import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/invoices/domain/invoice.dart';
import 'package:offline_quotes/features/invoices/presentation/invoices_screen.dart';

import '../../../support/fake_invoice_repository.dart';

void main() {
  group('InvoicesScreen Widget Tests', () {
    late FakeInvoiceRepository fakeInvoiceRepo;

    final sampleInvoice1 = Invoice(
      id: 1,
      referenceNumber: 'INV-2026-0001',
      customerName: 'شركة النيل للتجارة',
      customerPhone: '01012345678',
      status: InvoiceStatus.unpaid,
      issueDate: DateTime(2026, 1, 15),
      subtotalPiastres: 25000,
      discountPiastres: 0,
      taxPiastres: 0,
      grandTotalPiastres: 25000,
      paidAmountPiastres: 0,
      items: const [
        InvoiceItem(
          id: 1,
          invoiceId: 1,
          productCode: 'P-101',
          productName: 'كوع 20 مم بولي',
          unit: 'قطعة',
          unitPricePiastres: 2500,
          quantity: 10,
          lineDiscountPiastres: 0,
          lineTotalPiastres: 25000,
        ),
      ],
      payments: const [],
      createdAt: DateTime(2026, 1, 15),
      updatedAt: DateTime(2026, 1, 15),
    );

    final sampleInvoice2 = Invoice(
      id: 2,
      referenceNumber: 'INV-2026-0002',
      customerName: 'مؤسسة السلام',
      status: InvoiceStatus.paid,
      issueDate: DateTime(2026, 1, 20),
      subtotalPiastres: 50000,
      discountPiastres: 5000,
      taxPiastres: 0,
      grandTotalPiastres: 45000,
      paidAmountPiastres: 45000,
      items: const [
        InvoiceItem(
          id: 2,
          invoiceId: 2,
          productCode: 'P-102',
          productName: 'محبس دفن 3/4',
          unit: 'قطعة',
          unitPricePiastres: 5000,
          quantity: 10,
          lineDiscountPiastres: 0,
          lineTotalPiastres: 50000,
        ),
      ],
      payments: [
        InvoicePayment(
          id: 1,
          invoiceId: 2,
          amountPiastres: 45000,
          paymentMethod: PaymentMethod.cash,
          paymentDate: DateTime(2026, 1, 20),
          createdAt: DateTime(2026, 1, 20),
        ),
      ],
      createdAt: DateTime(2026, 1, 20),
      updatedAt: DateTime(2026, 1, 20),
    );

    Widget createSubject({List<Invoice>? initialInvoices}) {
      fakeInvoiceRepo = FakeInvoiceRepository(initialInvoices);

      return ProviderScope(
        overrides: [
          invoiceRepositoryProvider.overrideWithValue(fakeInvoiceRepo),
        ],
        child: const MaterialApp(locale: Locale('ar'), home: InvoicesScreen()),
      );
    }

    testWidgets('renders empty state when there are no invoices', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject(initialInvoices: []));
      await tester.pumpAndSettle();

      expect(find.text('لا توجد فواتير مبيعات مسجلة'), findsOneWidget);
      expect(find.text('فاتورة جديدة'), findsOneWidget);
    });

    testWidgets('renders list of invoices and metrics bar', (tester) async {
      await tester.pumpWidget(
        createSubject(initialInvoices: [sampleInvoice1, sampleInvoice2]),
      );
      await tester.pumpAndSettle();

      expect(find.text('INV-2026-0001'), findsOneWidget);
      expect(find.text('شركة النيل للتجارة'), findsOneWidget);
      expect(find.text('INV-2026-0002'), findsOneWidget);
      expect(find.text('مؤسسة السلام'), findsOneWidget);

      expect(find.text('المستحقات'), findsOneWidget);
      expect(find.text('المحصل'), findsOneWidget);
    });

    testWidgets('filters list by tapping status chips', (tester) async {
      await tester.pumpWidget(
        createSubject(initialInvoices: [sampleInvoice1, sampleInvoice2]),
      );
      await tester.pumpAndSettle();

      expect(find.text('INV-2026-0001'), findsOneWidget);
      expect(find.text('INV-2026-0002'), findsOneWidget);

      // Tap on 'مسدد بالكامل' filter chip
      await tester.tap(find.widgetWithText(FilterChip, 'مسدد بالكامل'));
      await tester.pumpAndSettle();

      expect(find.text('INV-2026-0001'), findsNothing);
      expect(find.text('INV-2026-0002'), findsOneWidget);

      // Tap on 'غير مسدد' filter chip
      await tester.tap(find.widgetWithText(FilterChip, 'غير مسدد'));
      await tester.pumpAndSettle();

      expect(find.text('INV-2026-0001'), findsOneWidget);
      expect(find.text('INV-2026-0002'), findsNothing);
    });

    testWidgets('deletes invoice with confirmation dialog', (tester) async {
      await tester.pumpWidget(createSubject(initialInvoices: [sampleInvoice1]));
      await tester.pumpAndSettle();

      expect(find.text('INV-2026-0001'), findsOneWidget);

      // Open popup menu on invoice card
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tap delete
      await tester.tap(find.text('حذف الفاتورة'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog
      expect(find.text('تأكيد حذف الفاتورة'), findsOneWidget);
      await tester.tap(find.text('حذف نهائي'));
      await tester.pumpAndSettle();

      expect(find.text('INV-2026-0001'), findsNothing);
      expect(find.text('لا توجد فواتير مبيعات مسجلة'), findsOneWidget);
    });
  });
}
