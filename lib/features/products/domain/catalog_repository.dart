import 'import_summary.dart';
import 'product.dart';

/// Contract for catalog persistence and retrieval.
///
/// Pure Dart interface with zero dependencies on Flutter or Drift.
abstract interface class CatalogRepository {
  /// Stream emitting all products, optionally filtered by category.
  Stream<List<Product>> watchAllProducts({String? categoryFilter});

  /// Queries products matching the normalized Arabic search query.
  Future<List<Product>> searchProducts(
    String query, {
    String? categoryFilter,
    int limit = 100,
  });

  /// Finds a single product by its unique code.
  Future<Product?> getProductByCode(String code);

  /// Finds a single product by its database primary key.
  Future<Product?> getProductById(int id);

  /// Creates a new product. Throws an exception if the code already exists.
  Future<Product> createProduct({
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    String? barcode,
    String? notes,
  });

  /// Updates an existing product.
  Future<Product> updateProduct({
    required int id,
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    String? barcode,
    String? notes,
  });

  /// Deletes a product by its ID.
  Future<void> deleteProduct(int id);

  /// Returns the distinct list of existing category names.
  Future<List<String>> getCategories();

  /// Performs a high-performance transactional batch upsert of product drafts.
  Future<BatchUpsertResult> batchUpsertProducts(List<ProductDraft> drafts);

  /// Returns the total number of products in the catalog.
  Future<int> getProductCount();
}
