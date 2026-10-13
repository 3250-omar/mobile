import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/catalog_repository.dart';
import '../domain/product.dart';

/// State of the product catalog view.
class CatalogState {
  const CatalogState({
    this.searchQuery = '',
    this.selectedCategory,
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  final String searchQuery;
  final String? selectedCategory;
  final List<Product> products;
  final List<String> categories;
  final bool isLoading;
  final AppFailure? error;

  CatalogState copyWith({
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
    List<Product>? products,
    List<String>? categories,
    bool? isLoading,
    AppFailure? error,
    bool clearError = false,
  }) {
    return CatalogState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller managing catalog products, instant search, and category filtering.
class CatalogController extends StateNotifier<CatalogState> {
  CatalogController(this._repository) : super(const CatalogState()) {
    loadCatalog();
  }

  final CatalogRepository _repository;

  /// Loads categories and initial products list.
  Future<void> loadCatalog() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final categories = await _repository.getCategories();
      final products = await _repository.searchProducts(
        state.searchQuery,
        categoryFilter: state.selectedCategory,
      );
      state = state.copyWith(
        categories: categories,
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: const AppFailure(
          code: 'CATALOG_LOAD_FAILED',
          messageKey: 'error_loading_catalog',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
    }
  }

  /// Updates the search query and filters results instantly.
  Future<void> onSearchChanged(String query) async {
    state = state.copyWith(searchQuery: query);
    await _search();
  }

  /// Sets or clears the active category filter pill.
  Future<void> onCategorySelected(String? category) async {
    if (category == null ||
        category == 'الكل' ||
        category == state.selectedCategory) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
    await _search();
  }

  /// Deletes a product and refreshes catalog and categories.
  Future<void> deleteProduct(int id) async {
    try {
      await _repository.deleteProduct(id);
      await loadCatalog();
    } catch (e) {
      state = state.copyWith(
        error: const AppFailure(
          code: 'PRODUCT_DELETE_FAILED',
          messageKey: 'error_deleting_product',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
    }
  }

  Future<void> _search() async {
    try {
      final products = await _repository.searchProducts(
        state.searchQuery,
        categoryFilter: state.selectedCategory,
      );
      state = state.copyWith(products: products);
    } catch (e) {
      state = state.copyWith(
        error: const AppFailure(
          code: 'SEARCH_FAILED',
          messageKey: 'error_search_failed',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
    }
  }
}
