import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/products/domain/product.dart';
import 'package:offline_quotes/features/quotations/domain/quotation.dart';
import 'package:offline_quotes/features/quotations/presentation/quotation_form_screen.dart';
import 'package:offline_quotes/shared/widgets/app_text_field.dart';

import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_quotation_repository.dart';

void main() {
  group('QuotationFormScreen Widget Tests', () {
    late FakeCatalogRepository fakeCatalogRepo;
    late FakeQuotationRepository fakeQuotationRepo;

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
      fakeQuotationRepo = FakeQuotationRepository();
    });

    Widget createTestApp({Quotation? existingQuotation}) {
      return ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(fakeCatalogRepo),
          quotationRepositoryProvider.overrideWithValue(fakeQuotationRepo),
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
                        builder: (_) => QuotationFormScreen(
                          existingQuotation: existingQuotation,
                        ),
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
        matching: find.byType(TextFormField),
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

      expect(find.text('إنشاء عرض سعر جديد'), findsOneWidget);
      expect(find.text('بيانات العميل'), findsOneWidget);
      expect(find.text('اسم العميل أو المؤسسة *'), findsOneWidget);
      expect(find.text('لم تتم إضافة أي أصناف بعد'), findsOneWidget);
      expect(find.text('المجموع الفرعي (قبل الخصم):'), findsOneWidget);
      expect(find.text('0.00 ج.م'), findsNWidgets(2)); // subtotal and total
      expect(find.text('حفظ كمسودة'), findsOneWidget);
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

      // Click save without customer name
      final saveBtn = find.text('حفظ كمسودة');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('اسم العميل مطلوب'), findsOneWidget);

      // Enter customer name but no items
      await tester.enterText(
        findFieldWithLabel('اسم العميل أو المؤسسة *'),
        'مؤسسة النيل',
      );
      await tester.pumpAndSettle();

      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(
        find.text('يجب إضافة صنف واحد على الأقل لعرض السعر'),
        findsOneWidget,
      );
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

      // Enter customer name
      await tester.enterText(
        findFieldWithLabel('اسم العميل أو المؤسسة *'),
        'شركة الأمل للتجارة',
      );
      await tester.pumpAndSettle();

      // Tap custom item button
      await tester.tap(find.text('صنف مخصص'));
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('إضافة صنف مخصص'), findsOneWidget);

      await tester.enterText(
        findFieldWithLabel('اسم الصنف والمواصفات *'),
        'تركيب وصيانة خطوط',
      );
      await tester.enterText(
        findFieldWithLabel('سعر الوحدة بالجنيه (ج.م) *'),
        '150.50',
      );
      await tester.pumpAndSettle();

      // Tap add in dialog
      await tester.tap(find.text('إضافة'));
      await tester.pumpAndSettle();

      // Item should now appear in list
      expect(find.text('تركيب وصيانة خطوط'), findsOneWidget);
      expect(find.text('150.50 ج.م'), findsWidgets);
    });

    testWidgets('picks item from catalog modal and saves quotation draft', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      // Enter customer name
      await tester.enterText(
        findFieldWithLabel('اسم العميل أو المؤسسة *'),
        'مؤسسة النور الحديثة',
      );
      await tester.pumpAndSettle();

      // Tap add from catalog button
      await tester.tap(find.text('من الدليل'));
      await tester.pumpAndSettle();

      // Modal opens
      expect(find.text('اختر صنفاً من الدليل'), findsOneWidget);
      expect(find.text('ماسورة مياه 1 بوصة'), findsOneWidget);

      // Select item
      await tester.tap(find.text('ماسورة مياه 1 بوصة'));
      await tester.pumpAndSettle();

      // Should be in list with qty 1 and price 50.00
      expect(find.text('ماسورة مياه 1 بوصة'), findsOneWidget);
      expect(find.text('50.00 ج.م'), findsWidgets);

      // Increment quantity
      final plusButton = find.byIcon(Icons.add_circle_outline);
      expect(plusButton, findsOneWidget);
      await tester.tap(plusButton);
      await tester.pumpAndSettle();

      // Quantity is now 2, total 100.00 ج.م
      expect(find.text('2'), findsOneWidget);
      expect(find.text('100.00 ج.م'), findsWidgets);

      // Save draft
      final saveBtn = find.text('حفظ كمسودة');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify form was popped back to parent page
      expect(find.text('افتح النموذج'), findsOneWidget);

      // Verify saved in fake quotation repository
      final saved = await fakeQuotationRepo.getQuotationById(1);
      expect(saved, isNotNull);
      expect(saved!.customerName, 'مؤسسة النور الحديثة');
      expect(saved.grandTotalPiastres, 10000); // 100.00 EGP
      expect(saved.items.length, 1);
      expect(saved.items.first.quantity, 2);
      expect(saved.items.first.productCode, 'PROD-01');
    });

    testWidgets('pre-populates form in edit mode for existing quotation', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final existing = Quotation(
        id: 42,
        referenceNumber: 'QT-2026-0042',
        customerName: 'مكتب الهندسة',
        customerPhone: '01012345678',
        status: QuotationStatus.draft,
        issueDate: DateTime(2026, 2, 1),
        subtotalPiastres: 5000,
        discountPiastres: 500,
        taxPiastres: 0,
        grandTotalPiastres: 4500,
        notes: 'ملاحظة خاصة',
        items: [
          const QuotationItem(
            id: 1,
            quotationId: 42,
            productId: 10,
            productCode: 'PROD-01',
            productName: 'ماسورة مياه 1 بوصة',
            unit: 'متر',
            unitPricePiastres: 5000,
            quantity: 1,
            lineDiscountPiastres: 0,
            lineTotalPiastres: 5000,
          ),
        ],
        createdAt: DateTime(2026, 2, 1),
        updatedAt: DateTime(2026, 2, 1),
      );

      await tester.pumpWidget(createTestApp(existingQuotation: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      expect(find.text('تعديل عرض السعر (QT-2026-0042)'), findsOneWidget);
      expect(find.text('مكتب الهندسة'), findsOneWidget);
      expect(find.text('01012345678'), findsOneWidget);
      expect(find.text('ماسورة مياه 1 بوصة'), findsOneWidget);
      expect(find.text('حفظ التعديلات'), findsOneWidget);
    });
  });
}
