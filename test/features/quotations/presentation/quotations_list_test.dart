import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/quotations/domain/quotation.dart';
import 'package:offline_quotes/features/quotations/presentation/quotations_screen.dart';

import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_quotation_repository.dart';

void main() {
  group('QuotationsScreen Widget Tests', () {
    late FakeCatalogRepository fakeCatalogRepo;
    late FakeQuotationRepository fakeQuotationRepo;

    final sampleQuotation1 = Quotation(
      id: 1,
      referenceNumber: 'QT-2026-0001',
      customerName: 'شركة النيل للتجارة',
      customerPhone: '01012345678',
      status: QuotationStatus.draft,
      issueDate: DateTime(2026, 1, 15),
      subtotalPiastres: 25000,
      discountPiastres: 0,
      taxPiastres: 0,
      grandTotalPiastres: 25000, // 250.00 EGP
      items: const [
        QuotationItem(
          id: 1,
          quotationId: 1,
          productCode: 'P-101',
          productName: 'كوع 20 مم بولي',
          unit: 'قطعة',
          unitPricePiastres: 2500,
          quantity: 10,
          lineDiscountPiastres: 0,
          lineTotalPiastres: 25000,
        ),
      ],
      createdAt: DateTime(2026, 1, 15),
      updatedAt: DateTime(2026, 1, 15),
    );

    final sampleQuotation2 = Quotation(
      id: 2,
      referenceNumber: 'QT-2026-0002',
      customerName: 'مؤسسة السلام',
      status: QuotationStatus.accepted,
      issueDate: DateTime(2026, 1, 20),
      subtotalPiastres: 50000,
      discountPiastres: 5000,
      taxPiastres: 0,
      grandTotalPiastres: 45000, // 450.00 EGP
      items: const [
        QuotationItem(
          id: 2,
          quotationId: 2,
          productCode: 'P-102',
          productName: 'محبس دفن 3/4',
          unit: 'قطعة',
          unitPricePiastres: 50000,
          quantity: 1,
          lineDiscountPiastres: 5000,
          lineTotalPiastres: 45000,
        ),
      ],
      createdAt: DateTime(2026, 1, 20),
      updatedAt: DateTime(2026, 1, 20),
    );

    setUp(() {
      fakeCatalogRepo = FakeCatalogRepository();
      fakeQuotationRepo = FakeQuotationRepository([
        sampleQuotation1,
        sampleQuotation2,
      ]);
    });

    Widget createTestApp({List<Quotation>? initialQuotations}) {
      final repo = initialQuotations != null
          ? FakeQuotationRepository(initialQuotations)
          : fakeQuotationRepo;

      return ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(fakeCatalogRepo),
          quotationRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          home: QuotationsScreen(),
        ),
      );
    }

    testWidgets('renders empty state when there are no quotations', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialQuotations: []));
      await tester.pumpAndSettle();

      expect(find.text('عروض الأسعار'), findsOneWidget);
      expect(find.text('لا توجد أي عروض أسعار حتى الآن'), findsOneWidget);
      expect(find.text('عرض سعر جديد'), findsWidgets);
    });

    testWidgets('displays list of quotations with cards and metrics', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Top metrics summary
      expect(find.text('إجمالي العروض'), findsOneWidget);
      expect(find.text('2'), findsWidgets); // total count
      expect(find.text('المسودات'), findsOneWidget);
      expect(find.text('المقبولة'), findsOneWidget);

      // Quotation 1 Card
      expect(find.textContaining('QT-2026-0001'), findsOneWidget);
      expect(find.text('شركة النيل للتجارة'), findsOneWidget);
      expect(find.text('250.00 ج.م'), findsOneWidget);
      expect(find.text('مسودة'), findsWidgets);

      // Quotation 2 Card
      expect(find.textContaining('QT-2026-0002'), findsOneWidget);
      expect(find.text('مؤسسة السلام'), findsOneWidget);
      expect(
        find.text('450.00 ج.م'),
        findsNWidgets(2),
      ); // in metrics and in card
      expect(find.text('مقبول'), findsWidgets);
    });

    testWidgets('filters list by clicking status chips', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('QT-2026-0001'), findsOneWidget);
      expect(find.textContaining('QT-2026-0002'), findsOneWidget);

      // Tap "مسودة" filter chip
      await tester.tap(find.widgetWithText(ChoiceChip, 'مسودة'));
      await tester.pumpAndSettle();

      // Only draft is visible
      expect(find.textContaining('QT-2026-0001'), findsOneWidget);
      expect(find.textContaining('QT-2026-0002'), findsNothing);

      // Tap "مقبول" filter chip
      await tester.tap(find.widgetWithText(ChoiceChip, 'مقبول'));
      await tester.pumpAndSettle();

      // Only accepted is visible
      expect(find.textContaining('QT-2026-0001'), findsNothing);
      expect(find.textContaining('QT-2026-0002'), findsOneWidget);

      // Tap "الكل" to reset filter
      await tester.tap(find.widgetWithText(ChoiceChip, 'الكل'));
      await tester.pumpAndSettle();

      expect(find.textContaining('QT-2026-0001'), findsOneWidget);
      expect(find.textContaining('QT-2026-0002'), findsOneWidget);
    });

    testWidgets('deletes quotation with confirmation dialog', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('QT-2026-0001'), findsOneWidget);

      // Open popup menu on first card
      final moreButtons = find.byIcon(Icons.more_vert);
      await tester.tap(moreButtons.first);
      await tester.pumpAndSettle();

      // Tap "حذف عرض السعر"
      await tester.tap(find.text('حذف عرض السعر'));
      await tester.pumpAndSettle();

      // Confirmation dialog opens
      expect(find.text('تأكيد حذف عرض السعر'), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.text('حذف نهائي'));
      await tester.pumpAndSettle();

      // Quotation 1 is deleted, Quotation 2 remains
      expect(find.textContaining('QT-2026-0001'), findsNothing);
      expect(find.textContaining('QT-2026-0002'), findsOneWidget);
    });

    testWidgets('duplicates quotation and creates fresh draft', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Open popup menu on second card (accepted quotation)
      final moreButtons = find.byIcon(Icons.more_vert);
      await tester.tap(moreButtons.at(1));
      await tester.pumpAndSettle();

      // Tap "نسخ كمسودة"
      await tester.tap(find.text('نسخ كمسودة'));
      await tester.pumpAndSettle();

      // Now 3 quotations exist (card + snackbar)
      expect(find.textContaining('QT-2026-0003'), findsNWidgets(2));
    });
  });
}
