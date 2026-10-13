import 'package:offline_quotes/features/products/domain/catalog_repository.dart';
import 'package:offline_quotes/features/products/domain/import_summary.dart';
import 'package:offline_quotes/features/products/domain/product.dart';

/// In-memory fake catalog repository for navigation and widget tests.
class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository([List<Product>? initialProducts])
    : _products = List.of(initialProducts ?? []);

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
    if (index >= 0) {
      _products[index] = p;
    } else {
      _products.add(p);
    }
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
