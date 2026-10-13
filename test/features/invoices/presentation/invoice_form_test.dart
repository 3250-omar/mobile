import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/invoices/domain/invoice.dart';
import 'package:offline_quotes/features/invoices/presentation/invoice_form_screen.dart';
import 'package:offline_quotes/features/invoices/presentation/widgets/record_payment_dialog.dart';
import 'package:offline_quotes/features/products/domain/product.dart';
import 'package:offline_quotes/shared/widgets/app_text_field.dart';

import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_invoice_repository.dart';

void main() {
  group('InvoiceFormScreen & Payment Dialog Widget Tests', () {
    late FakeCatalogRepository fakeCatalogRepo;
    late FakeInvoiceRepository fakeInvoiceRepo;

    final sampleProduct = Product(
      id: 10,
      code: 'PROD-01',
      name: 'ماسورة مياه 1 بوصة',
      category: 'سباكة',
      unit: 'متر',
      unitPricePiastres: 5000, // 50.00 EGP
      normalizedSearchText: 'ماسورة مياه PROD-01',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    setUp(() {
      fakeCatalogRepo = FakeCatalogRepository([sampleProduct]);
      fakeInvoiceRepo = FakeInvoiceRepository();
    });

    Widget createTestApp() {
      return ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(fakeCatalogRepo),
          invoiceRepositoryProvider.overrideWithValue(fakeInvoiceRepo),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const InvoiceFormScreen(),
                      ),
                    );
                  },
                  child: const Text('افتح النموذج'),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Finder findFieldWithLabel(String label) {
      return find.descendant(
        of: find.widgetWithText(AppTextField, label),
        matching: find.byType(TextField),
      );
    }

    testWidgets('renders initial empty form correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      expect(find.text('إنشاء فاتورة مبيعات جديدة'), findsOneWidget);
      expect(find.text('اسم العميل أو المؤسسة *'), findsOneWidget);
      expect(find.text('لم يتم إضافة أصناف بعد'), findsOneWidget);
      expect(find.text('حفظ الفاتورة'), findsOneWidget);
    });

    testWidgets('validates required customer name and items before saving', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      // Tap save directly
      await tester.tap(find.text('حفظ الفاتورة'));
      await tester.pumpAndSettle();

      expect(find.text('اسم العميل مطلوب'), findsOneWidget);

      // Enter name but no items
      await tester.enterText(
        findFieldWithLabel('اسم العميل أو المؤسسة *'),
        'عميل تجريبي',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('حفظ الفاتورة'));
      await tester.pumpAndSettle();

      expect(find.text('يجب إضافة صنف واحد على الأقل'), findsOneWidget);
    });

    testWidgets('adds custom item and recalculates financial totals', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      // Open custom item dialog
      await tester.tap(find.text('صنف مخصص'));
      await tester.pumpAndSettle();

      expect(find.text('إضافة صنف مخصص'), findsOneWidget);

      await tester.enterText(
        findFieldWithLabel('اسم الصنف *'),
        'محبس زاوية إيطالي',
      );
      await tester.enterText(findFieldWithLabel('الكمية'), '3');
      await tester.enterText(
        findFieldWithLabel('سعر الوحدة بالجنيه (ج.م) *'),
        '150.00',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('إضافة'));
      await tester.pumpAndSettle();

      // 3 * 150 = 450.00 EGP
      expect(find.text('محبس زاوية إيطالي'), findsOneWidget);
      expect(find.text('450.00 ج.م'), findsWidgets);
    });

    testWidgets('picks item from catalog modal and saves invoice', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      await tester.enterText(
        findFieldWithLabel('اسم العميل أو المؤسسة *'),
        'شركة الأهرام',
      );

      // Open catalog picker
      await tester.tap(find.text('من الدليل'));
      await tester.pumpAndSettle();

      expect(find.text('اختيار صنف من الدليل'), findsOneWidget);
      expect(find.text('ماسورة مياه 1 بوصة'), findsOneWidget);

      await tester.tap(find.text('ماسورة مياه 1 بوصة'));
      await tester.pumpAndSettle();

      expect(find.text('ماسورة مياه 1 بوصة'), findsOneWidget);

      // Save invoice
      await tester.tap(find.text('حفظ الفاتورة'));
      await tester.pumpAndSettle();

      // Navigates back after saving
      expect(find.text('إنشاء فاتورة مبيعات جديدة'), findsNothing);
      expect(find.text('افتح النموذج'), findsOneWidget);
    });

    testWidgets('RecordPaymentDialog validates payment and submits', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final invoice = Invoice(
        id: 1,
        referenceNumber: 'INV-2026-0001',
        customerName: 'عميل نقدي',
        status: InvoiceStatus.unpaid,
        issueDate: DateTime(2026, 1, 1),
        subtotalPiastres: 10000,
        grandTotalPiastres: 10000, // 100.00 EGP
        paidAmountPiastres: 0,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      int recordedAmount = 0;
      PaymentMethod? recordedMethod;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          home: Scaffold(
            body: Center(
              child: RecordPaymentDialog(
                invoice: invoice,
                onRecordPayment:
                    ({
                      required int amountPiastres,
                      required PaymentMethod paymentMethod,
                      DateTime? paymentDate,
                      String? notes,
                    }) async {
                      recordedAmount = amountPiastres;
                      recordedMethod = paymentMethod;
                    },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تسجيل دفعة للفاتورة'), findsOneWidget);
      expect(find.text('INV-2026-0001'), findsOneWidget);

      // Default amount is remaining balance: 100.00
      // Submit payment
      await tester.tap(find.text('تأكيد التسجيل'));
      await tester.pumpAndSettle();

      expect(recordedAmount, equals(10000));
      expect(recordedMethod, equals(PaymentMethod.cash));
    });
  });
}
