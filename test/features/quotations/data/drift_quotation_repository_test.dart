import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/quotations/data/drift_quotation_repository.dart';
import 'package:offline_quotes/features/quotations/domain/quotation.dart';

void main() {
  group('DriftQuotationRepository Integration Tests', () {
    late AppDatabase db;
    late DriftQuotationRepository repository;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repository = DriftQuotationRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('creates quotation with line items and generates sequential reference number', () async {
      final items = [
        const QuotationItemDraft(
          productCode: 'VAL-01',
          productName: 'محبس بلية 1/2 بوصة',
          unit: 'قطعة',
          unitPricePiastres: 6500, // 65.00 EGP
          quantity: 2,
        ),
        const QuotationItemDraft(
          productCode: 'PIP-20',
          productName: 'ماسورة 20 مم بولي',
          unit: 'متر',
          unitPricePiastres: 2500, // 25.00 EGP
          quantity: 4,
          lineDiscountPiastres: 500, // 5.00 EGP discount
        ),
      ];

      final quotation = await repository.createQuotation(
        customerName: 'المهندس طارق',
        customerPhone: '01011223344',
        discountPiastres: 1000, // 10.00 EGP global discount
        items: items,
      );

      final year = DateTime.now().year;
      expect(quotation.referenceNumber, equals('QT-$year-0001'));
      expect(quotation.customerName, equals('المهندس طارق'));
      expect(quotation.status, equals(QuotationStatus.draft));
      expect(quotation.items.length, equals(2));

      // Line 1: 6500 * 2 = 13000
      // Line 2: (2500 * 4) - 500 = 9500
      // Subtotal: 13000 + 9500 = 22500
      // Discount: 1000
      // Grand Total: 22500 - 1000 = 21500
      expect(quotation.subtotalPiastres, equals(22500));
      expect(quotation.grandTotalPiastres, equals(21500));
      expect(quotation.formattedGrandTotalEgp, equals('215.00'));

      // Next quotation gets 0002
      final q2 = await repository.createQuotation(
        customerName: 'عميل ثان',
        items: [items.first],
      );
      expect(q2.referenceNumber, equals('QT-$year-0002'));
    });

    test(
      'updates draft quotation line items and recalculates totals',
      () async {
        final created = await repository.createQuotation(
          customerName: 'أحمد',
          items: [
            const QuotationItemDraft(
              productCode: 'P-1',
              productName: 'كوع 20 مم',
              unit: 'قطعة',
              unitPricePiastres: 1000,
              quantity: 5,
            ),
          ],
        );

        expect(created.grandTotalPiastres, 5000);

        final updated = await repository.updateQuotation(
          id: created.id,
          customerName: 'أحمد محمود',
          items: [
            const QuotationItemDraft(
              productCode: 'P-1',
              productName: 'كوع 20 مم',
              unit: 'قطعة',
              unitPricePiastres: 1000,
              quantity: 10,
            ),
          ],
        );

        expect(updated.customerName, 'أحمد محمود');
        expect(updated.grandTotalPiastres, 10000);
        expect(updated.items.first.quantity, 10);
      },
    );

    test('rejects updating locked/accepted quotations', () async {
      final created = await repository.createQuotation(
        customerName: 'شركة المقاولات',
        items: [
          const QuotationItemDraft(
            productCode: 'P-1',
            productName: 'بند',
            unit: 'قطعة',
            unitPricePiastres: 1000,
            quantity: 1,
          ),
        ],
      );

      await repository.updateStatus(created.id, QuotationStatus.accepted);

      expect(
        () => repository.updateQuotation(
          id: created.id,
          customerName: 'تعديل ممنوع',
          items: [
            const QuotationItemDraft(
              productCode: 'P-1',
              productName: 'بند',
              unit: 'قطعة',
              unitPricePiastres: 2000,
              quantity: 1,
            ),
          ],
        ),
        throwsA(
          isA<AppFailure>().having((e) => e.code, 'code', 'QUOTATION_LOCKED'),
        ),
      );
    });

    test(
      'duplicates quotation into new draft with reset reference and timestamp',
      () async {
        final original = await repository.createQuotation(
          customerName: 'مؤسسة البناء',
          items: [
            const QuotationItemDraft(
              productCode: 'PIP-1',
              productName: 'ماسورة',
              unit: 'متر',
              unitPricePiastres: 3000,
              quantity: 3,
            ),
          ],
        );

        final duplicate = await repository.duplicateQuotation(original.id);

        expect(duplicate.id, isNot(equals(original.id)));
        expect(
          duplicate.referenceNumber,
          isNot(equals(original.referenceNumber)),
        );
        expect(duplicate.customerName, equals('مؤسسة البناء (نسخة)'));
        expect(duplicate.status, equals(QuotationStatus.draft));
        expect(
          duplicate.grandTotalPiastres,
          equals(original.grandTotalPiastres),
        );
      },
    );

    test('calculates metrics accurately for dashboard', () async {
      await repository.createQuotation(
        customerName: 'مسودة 1',
        items: [
          const QuotationItemDraft(
            productCode: 'X',
            productName: 'صنف',
            unit: 'قطعة',
            unitPricePiastres: 5000,
            quantity: 2,
          ),
        ],
      );

      final q2 = await repository.createQuotation(
        customerName: 'معتمد 1',
        items: [
          const QuotationItemDraft(
            productCode: 'Y',
            productName: 'صنف',
            unit: 'قطعة',
            unitPricePiastres: 7000,
            quantity: 1,
          ),
        ],
      );

      await repository.updateStatus(q2.id, QuotationStatus.accepted);

      final metrics = await repository.getMetrics();
      expect(metrics.totalCount, equals(2));
      expect(metrics.draftsCount, equals(1));
      expect(metrics.acceptedCount, equals(1));
      expect(metrics.acceptedTotalPiastres, equals(7000));
      expect(metrics.formattedAcceptedTotalEgp, equals('70.00'));
    });
  });
}
