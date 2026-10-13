import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/products/domain/catalog_repository.dart';
import 'package:offline_quotes/features/products/domain/import_summary.dart';
import 'package:offline_quotes/features/products/domain/product.dart';
import 'package:offline_quotes/features/products/presentation/products_screen.dart';
import 'package:offline_quotes/features/products/presentation/widgets/product_card.dart';

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this._products);

  final List<Product> _products;

  @override
  Stream<List<Product>> watchAllProducts({String? categoryFilter}) {
    return Stream.value(_filter(_products, '', categoryFilter));
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    String? categoryFilter,
    int limit = 100,
  }) async {
    return _filter(_products, query, categoryFilter);
  }

  @override
  Future<List<String>> getCategories() async {
    return _products.map((p) => p.category).toSet().toList();
  }

  @override
  Future<Product?> getProductByCode(String code) async {
    return _products.where((p) => p.code == code).firstOrNull;
  }

  @override
  Future<Product?> getProductById(int id) async {
    return _products.where((p) => p.id == id).firstOrNull;
  }

  @override
  Future<Product> createProduct({
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    String? barcode,
    String? notes,
  }) async {
    final p = Product(
      id: _products.length + 1,
      code: code,
      name: name,
      category: category,
      unit: unit,
      unitPricePiastres: unitPricePiastres,
      normalizedSearchText: '$name $code',
      barcode: barcode,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _products.add(p);
    return p;
  }

  @override
  Future<Product> updateProduct({
    required int id,
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    String? barcode,
    String? notes,
  }) async {
    final index = _products.indexWhere((p) => p.id == id);
    final p = Product(
      id: id,
      code: code,
      name: name,
      category: category,
      unit: unit,
      unitPricePiastres: unitPricePiastres,
      normalizedSearchText: '$name $code',
      barcode: barcode,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _products[index] = p;
    return p;
  }

  @override
  Future<void> deleteProduct(int id) async {
    _products.removeWhere((p) => p.id == id);
  }

  @override
  Future<BatchUpsertResult> batchUpsertProducts(
    List<ProductDraft> drafts,
  ) async {
    return BatchUpsertResult(inserted: drafts.length, updated: 0);
  }

  @override
  Future<int> getProductCount() async => _products.length;

  List<Product> _filter(List<Product> list, String query, String? cat) {
    return list.where((p) {
      final matchesCat =
          cat == null || cat.isEmpty || cat == 'الكل' || p.category == cat;
      final matchesQuery =
          query.isEmpty ||
          p.name.contains(query) ||
          p.code.toLowerCase().contains(query.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
  }
}

void main() {
  group('Product Search & Filter Widget Tests', () {
    late List<Product> sampleProducts;
    late _FakeCatalogRepository repository;

    setUp(() {
      final now = DateTime.now();
      sampleProducts = [
        Product(
          id: 1,
          code: 'PPR-ELB-020',
          name: 'كوع 20 مم بولي',
          category: 'لوازم بولي',
          unit: 'قطعة',
          unitPricePiastres: 1550,
          normalizedSearchText: 'كوع 20 مم بولي ppr-elb-020',
          createdAt: now,
          updatedAt: now,
        ),
        Product(
          id: 2,
          code: 'VALVE-050',
          name: 'محبس بلية 1/2 بوصة',
          category: 'محابس',
          unit: 'قطعة',
          unitPricePiastres: 6500,
          normalizedSearchText: 'محبس بليه 1/2 بوصه valve-050',
          createdAt: now,
          updatedAt: now,
        ),
      ];
      repository = _FakeCatalogRepository(sampleProducts);
    });

    Widget createTestApp() {
      return ProviderScope(
        overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: ProductsScreen(),
          ),
        ),
      );
    }

    testWidgets('renders product list and displays product cards', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.text('كوع 20 مم بولي'), findsOneWidget);
      expect(find.text('محبس بلية 1/2 بوصة'), findsOneWidget);
      expect(find.text('15.50'), findsOneWidget);
      expect(find.text('65.00'), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(2));
    });

    testWidgets('filters products when user types in search bar', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'كوع');
      await tester.pumpAndSettle();

      expect(find.text('كوع 20 مم بولي'), findsOneWidget);
      expect(find.text('محبس بلية 1/2 بوصة'), findsNothing);
    });

    testWidgets('filters products when category chip is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final valveChip = find.widgetWithText(ChoiceChip, 'محابس');
      expect(valveChip, findsOneWidget);

      await tester.tap(valveChip);
      await tester.pumpAndSettle();

      expect(find.text('محبس بلية 1/2 بوصة'), findsOneWidget);
      expect(find.text('كوع 20 مم بولي'), findsNothing);
    });
  });
}
