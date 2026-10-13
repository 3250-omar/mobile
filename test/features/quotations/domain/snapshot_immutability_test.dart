import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/quotations/data/drift_quotation_repository.dart';
import 'package:offline_quotes/features/quotations/domain/quotation.dart';

void main() {
  group('Quotation Snapshot Immutability & Finalization Locking', () {
    late AppDatabase db;
    late DriftQuotationRepository repository;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repository = DriftQuotationRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('historical snapshot remains untouched even when catalog product price changes', () async {
      final nowMs = DateTime.now().millisecondsSinceEpoch;

      // 1. Insert product in catalog with original price 5000 (50.00 EGP)
      final productId = await db
          .into(db.productsTable)
          .insert(
            ProductCompanion.insert(
              code: 'PROD-100',
              name: 'كوع زاوية 90 درجة',
              category: 'لوازم سباكة',
              unit: 'قطعة',
              unitPricePiastres: 5000,
              normalizedSearchText: 'كوع زاوية PROD-100',
              createdAt: nowMs,
              updatedAt: nowMs,
            ),
          );

      // 2. Create quotation draft referencing this product
      final quotation = await repository.createQuotation(
        customerName: 'شركة المقاولات المتحدة',
        items: [
          QuotationItemDraft(
            productId: productId,
            productCode: 'PROD-100',
            productName: 'كوع زاوية 90 درجة',
            unit: 'قطعة',
            unitPricePiastres: 5000,
            quantity: 4,
          ),
        ],
      );

      expect(quotation.items.first.unitPricePiastres, equals(5000));
      expect(quotation.items.first.lineTotalPiastres, equals(20000));
      expect(quotation.grandTotalPiastres, equals(20000));

      // 3. Simulate catalog price increase from 5000 to 8500 (85.00 EGP) and name change
      await (db.update(
        db.productsTable,
      )..where((t) => t.id.equals(productId))).write(
        const ProductCompanion(
          unitPricePiastres: Value(8500),
          name: Value('كوع زاوية معدل 90 درجة جديد'),
        ),
      );

      // 4. Reload quotation and verify historical snapshot is completely preserved
      final reloaded = await repository.getQuotationById(quotation.id);
      expect(reloaded, isNotNull);
      expect(reloaded!.items.first.unitPricePiastres, equals(5000));
      expect(reloaded.items.first.productName, equals('كوع زاوية 90 درجة'));
      expect(reloaded.items.first.lineTotalPiastres, equals(20000));
      expect(reloaded.grandTotalPiastres, equals(20000));
    });

    test('finalized quotation is locked against draft modification', () async {
      // 1. Create quotation
      final quotation = await repository.createQuotation(
        customerName: 'مؤسسة الرياض',
        items: const [
          QuotationItemDraft(
            productCode: 'P-1',
            productName: 'صنف أ',
            unit: 'قطعة',
            unitPricePiastres: 3000,
            quantity: 2,
          ),
        ],
      );

      expect(quotation.isLocked, isFalse);

      // 2. Accept quotation (transition status to accepted)
      await repository.updateStatus(quotation.id, QuotationStatus.accepted);

      final accepted = await repository.getQuotationById(quotation.id);
      expect(accepted, isNotNull);
      expect(accepted!.status, equals(QuotationStatus.accepted));
      expect(accepted.isLocked, isTrue);

      // 3. Attempting to update a locked quotation throws QUOTATION_LOCKED
      expect(
        () => repository.updateQuotation(
          id: quotation.id,
          customerName: 'تعديل اسم بعد الإقفال',
          items: const [
            QuotationItemDraft(
              productCode: 'P-2',
              productName: 'صنف معدل',
              unit: 'قطعة',
              unitPricePiastres: 9000,
              quantity: 5,
            ),
          ],
        ),
        throwsA(
          isA<AppFailure>().having(
            (f) => f.code,
            'code',
            equals('QUOTATION_LOCKED'),
          ),
        ),
      );
    });

    test(
      'duplicating a locked quotation creates an unlocked editable draft',
      () async {
        // 1. Create and lock quotation
        final original = await repository.createQuotation(
          customerName: 'عميل سابق',
          items: const [
            QuotationItemDraft(
              productCode: 'PIP-01',
              productName: 'أنبوب بلاستيك',
              unit: 'متر',
              unitPricePiastres: 1200,
              quantity: 10,
            ),
          ],
        );
        await repository.updateStatus(original.id, QuotationStatus.accepted);

        // 2. Duplicate locked quotation
        final duplicate = await repository.duplicateQuotation(original.id);

        expect(duplicate.id, isNot(equals(original.id)));
        expect(
          duplicate.referenceNumber,
          isNot(equals(original.referenceNumber)),
        );
        expect(duplicate.status, equals(QuotationStatus.draft));
        expect(duplicate.isLocked, isFalse);
        expect(duplicate.customerName, equals('عميل سابق (نسخة)'));
        expect(duplicate.items.length, equals(1));
        expect(duplicate.items.first.productCode, equals('PIP-01'));
        expect(duplicate.items.first.unitPricePiastres, equals(1200));

        // 3. The duplicate CAN be updated since it is a draft
        final updatedDuplicate = await repository.updateQuotation(
          id: duplicate.id,
          customerName: 'عميل جديد بعد التكرار',
          items: const [
            QuotationItemDraft(
              productCode: 'PIP-01',
              productName: 'أنبوب بلاستيك',
              unit: 'متر',
              unitPricePiastres: 1200,
              quantity: 15,
            ),
          ],
        );

        expect(updatedDuplicate.customerName, equals('عميل جديد بعد التكرار'));
        expect(updatedDuplicate.items.first.quantity, equals(15));
        expect(updatedDuplicate.grandTotalPiastres, equals(18000));
      },
    );
  });
}
