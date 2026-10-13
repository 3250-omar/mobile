import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/core/database/app_database.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/products/data/drift_catalog_repository.dart';
import 'package:offline_quotes/features/products/domain/product.dart';

void main() {
  group('DriftCatalogRepository', () {
    late AppDatabase db;
    late DriftCatalogRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repository = DriftCatalogRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('creates and retrieves a product with integer piastres', () async {
      final product = await repository.createProduct(
        code: 'PPR-20',
        name: 'ماسورة بولي بروبلين 20 مم',
        category: 'مواسير',
        unit: 'متر',
        unitPricePiastres: 3550,
      );

      expect(product.id, isPositive);
      expect(product.code, equals('PPR-20'));
      expect(product.unitPricePiastres, equals(3550));
      expect(product.formattedPriceEgp, equals('35.50'));

      final retrieved = await repository.getProductById(product.id);
      expect(retrieved, equals(product));
    });

    test('rejects duplicate product code with AppFailure', () async {
      await repository.createProduct(
        code: 'DUP-01',
        name: 'منتج أولي',
        category: 'عام',
        unit: 'قطعة',
        unitPricePiastres: 1000,
      );

      expect(
        () => repository.createProduct(
          code: 'DUP-01',
          name: 'منتج مكرر',
          category: 'عام',
          unit: 'قطعة',
          unitPricePiastres: 2000,
        ),
        throwsA(
          isA<AppFailure>().having(
            (f) => f.code,
            'code',
            equals('PRODUCT_CODE_EXISTS'),
          ),
        ),
      );
    });

    test(
      'searches products with Arabic orthographic and numeral normalization',
      () async {
        await repository.createProduct(
          code: 'ELB-01',
          name: 'كوع زاوية ٩٠ درجة ١/٢ بوصة',
          category: 'لوازم',
          unit: 'قطعة',
          unitPricePiastres: 1500,
        );
        await repository.createProduct(
          code: 'VALVE-01',
          name: 'محبس بلية 1 بوصة إيطالي',
          category: 'محابس',
          unit: 'قطعة',
          unitPricePiastres: 12000,
        );

        // Search with Western digits matching Eastern digits in product
        final results1 = await repository.searchProducts('كوع 1/2');
        expect(results1.length, equals(1));
        expect(results1.first.code, equals('ELB-01'));

        // Search with Alef variation
        final results2 = await repository.searchProducts('ايطالي');
        expect(results2.length, equals(1));
        expect(results2.first.code, equals('VALVE-01'));
      },
    );

    test(
      'batch upserts products transactionally reporting inserted and updated',
      () async {
        // 1. Initial batch insert
        final drafts = [
          const ProductDraft(
            code: 'P-1',
            name: 'صنف 1',
            category: 'مواسير',
            unit: 'متر',
            unitPricePiastres: 1000,
          ),
          const ProductDraft(
            code: 'P-2',
            name: 'صنف 2',
            category: 'محابس',
            unit: 'قطعة',
            unitPricePiastres: 2000,
          ),
        ];

        final res1 = await repository.batchUpsertProducts(drafts);
        expect(res1.inserted, equals(2));
        expect(res1.updated, equals(0));

        // 2. Second batch with 1 existing and 1 new
        final drafts2 = [
          const ProductDraft(
            code: 'P-1',
            name: 'صنف 1 معدل',
            category: 'مواسير',
            unit: 'متر',
            unitPricePiastres: 1500,
          ),
          const ProductDraft(
            code: 'P-3',
            name: 'صنف 3 جديد',
            category: 'لوازم',
            unit: 'قطعة',
            unitPricePiastres: 3000,
          ),
        ];

        final res2 = await repository.batchUpsertProducts(drafts2);
        expect(res2.inserted, equals(1));
        expect(res2.updated, equals(1));

        // Verify P-1 price was updated
        final p1 = await repository.getProductByCode('P-1');
        expect(p1!.unitPricePiastres, equals(1500));
        expect(p1.name, equals('صنف 1 معدل'));

        // Total count should be 3
        expect(await repository.getProductCount(), equals(3));
      },
    );

    test('retrieves distinct categories', () async {
      await repository.createProduct(
        code: 'A-1',
        name: 'منتج أ',
        category: 'صرف صحي',
        unit: 'متر',
        unitPricePiastres: 500,
      );
      await repository.createProduct(
        code: 'A-2',
        name: 'منتج ب',
        category: 'صرف صحي',
        unit: 'قطعة',
        unitPricePiastres: 600,
      );
      await repository.createProduct(
        code: 'A-3',
        name: 'منتج ج',
        category: 'خلاطات ومحابس',
        unit: 'قطعة',
        unitPricePiastres: 700,
      );

      final categories = await repository.getCategories();
      expect(categories, containsAll(['خلاطات ومحابس', 'صرف صحي']));
      expect(categories.length, equals(2));
    });
  });
}
