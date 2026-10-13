# Contract: CatalogRepository

**Feature**: [002-catalog-management](../spec.md)

## Interface Definition

```dart
abstract interface class CatalogRepository {
  /// Watches the entire active product list, ordered by Arabic name or code.
  Stream<List<Product>> watchAllProducts({String? categoryFilter});

  /// Queries products matching the normalized Arabic search query.
  Future<List<Product>> searchProducts(String query, {String? categoryFilter, int limit = 100});

  /// Finds a single product by its unique code.
  Future<Product?> getProductByCode(String code);

  /// Finds a single product by its database ID.
  Future<Product?> getProductById(int id);

  /// Inserts a new product. Throws [AppFailure] if code already exists.
  Future<Product> createProduct({
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    String? barcode,
    String? notes,
  });

  /// Updates an existing product. Throws [AppFailure] if not found or code conflict.
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

  /// Deletes a product by ID.
  Future<void> deleteProduct(int id);

  /// Retrieves the distinct list of categories currently in the catalog.
  Future<List<String>> getCategories();

  /// Executes transactional batch upsert of products during Excel import.
  /// Reports inserted and updated counts.
  Future<BatchUpsertResult> batchUpsertProducts(List<ProductDraft> drafts);

  /// Total count of products in catalog.
  Future<int> getProductCount();
}
```

## Error Codes
- `PRODUCT_CODE_EXISTS`: When inserting a product with a code that already exists.
- `PRODUCT_NOT_FOUND`: When attempting to update/delete a non-existent product.
- `INVALID_PRODUCT_DATA`: When name is empty or price is negative.
