import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/catalog_repository.dart';
import '../domain/import_summary.dart';
import '../domain/product.dart';
import 'arabic_search_normalizer.dart';

/// Drift/SQLite implementation of the [CatalogRepository].
class DriftCatalogRepository implements CatalogRepository {
  const DriftCatalogRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Product>> watchAllProducts({String? categoryFilter}) {
    final query = _database.select(_database.productsTable);
    if (categoryFilter != null &&
        categoryFilter.isNotEmpty &&
        categoryFilter != 'الكل') {
      query.where((t) => t.category.equals(categoryFilter));
    }
    query.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map((rows) => rows.map(_mapToDomain).toList());
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    String? categoryFilter,
    int limit = 100,
  }) async {
    final normalized = ArabicSearchNormalizer.normalize(query);
    final statement = _database.select(_database.productsTable);

    if (normalized.isNotEmpty) {
      final tokens = normalized.split(' ').where((t) => t.isNotEmpty);
      for (final token in tokens) {
        statement.where((t) => t.normalizedSearchText.like('%$token%'));
      }
    }

    if (categoryFilter != null &&
        categoryFilter.isNotEmpty &&
        categoryFilter != 'الكل') {
      statement.where((t) => t.category.equals(categoryFilter));
    }

    statement.limit(limit);
    statement.orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await statement.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<Product?> getProductByCode(String code) async {
    final query = _database.select(_database.productsTable)
      ..where((t) => t.code.equals(code.trim()));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomain(row) : null;
  }

  @override
  Future<Product?> getProductById(int id) async {
    final query = _database.select(_database.productsTable)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomain(row) : null;
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
    final trimmedCode = code.trim();
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const AppFailure(
        code: 'INVALID_PRODUCT_DATA',
        messageKey: 'error_product_name_required',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }
    if (unitPricePiastres < 0) {
      throw const AppFailure(
        code: 'INVALID_PRODUCT_DATA',
        messageKey: 'error_price_negative',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final existing = await getProductByCode(trimmedCode);
    if (existing != null) {
      throw const AppFailure(
        code: 'PRODUCT_CODE_EXISTS',
        messageKey: 'error_product_code_exists',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    final normalizedSearch = ArabicSearchNormalizer.buildSearchText(
      name: trimmedName,
      code: trimmedCode,
      category: category.trim(),
      barcode: barcode?.trim(),
    );

    final id = await _database
        .into(_database.productsTable)
        .insert(
          ProductCompanion.insert(
            code: trimmedCode,
            name: trimmedName,
            category: category.trim(),
            unit: unit.trim(),
            unitPricePiastres: unitPricePiastres,
            normalizedSearchText: normalizedSearch,
            barcode: Value(barcode?.trim()),
            notes: Value(notes?.trim()),
            createdAt: nowMs,
            updatedAt: nowMs,
          ),
        );

    final created = await getProductById(id);
    return created!;
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
    final trimmedCode = code.trim();
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const AppFailure(
        code: 'INVALID_PRODUCT_DATA',
        messageKey: 'error_product_name_required',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }
    if (unitPricePiastres < 0) {
      throw const AppFailure(
        code: 'INVALID_PRODUCT_DATA',
        messageKey: 'error_price_negative',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    // Check code conflict with other products
    final conflict =
        await (_database.select(
              _database.productsTable,
            )..where((t) => t.code.equals(trimmedCode) & t.id.equals(id).not()))
            .getSingleOrNull();
    if (conflict != null) {
      throw const AppFailure(
        code: 'PRODUCT_CODE_EXISTS',
        messageKey: 'error_product_code_exists',
        category: AppFailureCategory.validation,
        retryable: false,
      );
    }

    final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    final normalizedSearch = ArabicSearchNormalizer.buildSearchText(
      name: trimmedName,
      code: trimmedCode,
      category: category.trim(),
      barcode: barcode?.trim(),
    );

    await (_database.update(
      _database.productsTable,
    )..where((t) => t.id.equals(id))).write(
      ProductCompanion(
        code: Value(trimmedCode),
        name: Value(trimmedName),
        category: Value(category.trim()),
        unit: Value(unit.trim()),
        unitPricePiastres: Value(unitPricePiastres),
        normalizedSearchText: Value(normalizedSearch),
        barcode: Value(barcode?.trim()),
        notes: Value(notes?.trim()),
        updatedAt: Value(nowMs),
      ),
    );

    final updated = await getProductById(id);
    if (updated == null) {
      throw const AppFailure(
        code: 'PRODUCT_NOT_FOUND',
        messageKey: 'error_product_not_found',
        category: AppFailureCategory.storage,
        retryable: false,
      );
    }
    return updated;
  }

  @override
  Future<void> deleteProduct(int id) async {
    await (_database.delete(
      _database.productsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<String>> getCategories() async {
    final query = _database.selectOnly(_database.productsTable, distinct: true)
      ..addColumns([_database.productsTable.category])
      ..orderBy([OrderingTerm.asc(_database.productsTable.category)]);

    final rows = await query.get();
    return rows
        .map((row) => row.read(_database.productsTable.category))
        .whereType<String>()
        .where((c) => c.isNotEmpty)
        .toList();
  }

  @override
  Future<BatchUpsertResult> batchUpsertProducts(
    List<ProductDraft> drafts,
  ) async {
    if (drafts.isEmpty) {
      return const BatchUpsertResult(inserted: 0, updated: 0);
    }

    int insertedCount = 0;
    int updatedCount = 0;

    // Process in transactional chunks of 200 items
    const chunkSize = 200;
    for (var i = 0; i < drafts.length; i += chunkSize) {
      final end = (i + chunkSize < drafts.length)
          ? i + chunkSize
          : drafts.length;
      final chunk = drafts.sublist(i, end);

      await _database.transaction(() async {
        final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;

        for (final draft in chunk) {
          final normalizedSearch = ArabicSearchNormalizer.buildSearchText(
            name: draft.name,
            code: draft.code,
            category: draft.category,
            barcode: draft.barcode,
          );

          final existing = await (_database.select(
            _database.productsTable,
          )..where((t) => t.code.equals(draft.code))).getSingleOrNull();

          if (existing != null) {
            await (_database.update(
              _database.productsTable,
            )..where((t) => t.id.equals(existing.id))).write(
              ProductCompanion(
                name: Value(draft.name),
                category: Value(draft.category),
                unit: Value(draft.unit),
                unitPricePiastres: Value(draft.unitPricePiastres),
                normalizedSearchText: Value(normalizedSearch),
                barcode: Value(draft.barcode),
                notes: Value(draft.notes),
                updatedAt: Value(nowMs),
              ),
            );
            updatedCount++;
          } else {
            await _database
                .into(_database.productsTable)
                .insert(
                  ProductCompanion.insert(
                    code: draft.code,
                    name: draft.name,
                    category: draft.category,
                    unit: draft.unit,
                    unitPricePiastres: draft.unitPricePiastres,
                    normalizedSearchText: normalizedSearch,
                    barcode: Value(draft.barcode),
                    notes: Value(draft.notes),
                    createdAt: nowMs,
                    updatedAt: nowMs,
                  ),
                );
            insertedCount++;
          }
        }
      });
    }

    return BatchUpsertResult(inserted: insertedCount, updated: updatedCount);
  }

  @override
  Future<int> getProductCount() async {
    final countExp = _database.productsTable.id.count();
    final query = _database.selectOnly(_database.productsTable)
      ..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Product _mapToDomain(ProductEntry entry) {
    return Product(
      id: entry.id,
      code: entry.code,
      name: entry.name,
      category: entry.category,
      unit: entry.unit,
      unitPricePiastres: entry.unitPricePiastres,
      normalizedSearchText: entry.normalizedSearchText,
      barcode: entry.barcode,
      notes: entry.notes,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        entry.createdAt,
        isUtc: true,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        entry.updatedAt,
        isUtc: true,
      ),
    );
  }
}
