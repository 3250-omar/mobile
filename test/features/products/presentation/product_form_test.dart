import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/products/domain/catalog_repository.dart';
import 'package:offline_quotes/features/products/domain/import_summary.dart';
import 'package:offline_quotes/features/products/domain/product.dart';
import 'package:offline_quotes/features/products/presentation/widgets/product_form_dialog.dart';
import 'package:offline_quotes/shared/widgets/app_text_field.dart';

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this._products);

  final List<Product> _products;

  @override
  Stream<List<Product>> watchAllProducts({String? categoryFilter}) {
    return Stream.value(_products);
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    String? categoryFilter,
    int limit = 100,
  }) async {
    return _products;
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
}

void main() {
  group('ProductFormDialog Widget Tests', () {
    late List<Product> initialProducts;
    late _FakeCatalogRepository repository;

    setUp(() {
      initialProducts = [
        Product(
          id: 1,
          code: 'P-101',
          name: 'كوع 20 مم بولي',
          category: 'مواسير ولوازمها',
          unit: 'قطعة',
          unitPricePiastres: 1250,
          normalizedSearchText: 'كوع 20 مم بولي P-101',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];
      repository = _FakeCatalogRepository(initialProducts);
    });

    Widget createTestApp({Product? productToEdit}) {
      return ProviderScope(
        overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          locale: const Locale('ar'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => ProductFormDialog(
                        initialProduct: productToEdit,
                        onSave:
                            ({
                              required code,
                              required name,
                              required category,
                              required unit,
                              required unitPricePiastres,
                              barcode,
                              notes,
                            }) async {
                              if (productToEdit != null) {
                                await repository.updateProduct(
                                  id: productToEdit.id,
                                  code: code,
                                  name: name,
                                  category: category,
                                  unit: unit,
                                  unitPricePiastres: unitPricePiastres,
                                  barcode: barcode,
                                  notes: notes,
                                );
                              } else {
                                await repository.createProduct(
                                  code: code,
                                  name: name,
                                  category: category,
                                  unit: unit,
                                  unitPricePiastres: unitPricePiastres,
                                  barcode: barcode,
                                  notes: notes,
                                );
                              }
                            },
                      ),
                    );
                  },
                  child: const Text('افتح النموذج'),
                );
              },
            ),
          ),
        ),
      );
    }

    testWidgets('validates required fields on empty submit', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      expect(find.text('إضافة صنف جديد'), findsOneWidget);

      // Tap Save without entering code or name
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(find.text('الكود مطلوب'), findsOneWidget);
      expect(find.text('اسم الصنف مطلوب'), findsOneWidget);
      expect(find.text('السعر مطلوب'), findsOneWidget);
    });

    testWidgets('validates positive and numeric price value', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      // Code is first
      await tester.enterText(textFields.at(0), 'NEW-01');
      // Name is 3rd
      await tester.enterText(textFields.at(2), 'صنف تجريبي');
      // Price is 5th (at index 4) because row 1 has code & barcode (0, 1), row 2 has name (2), row 3 has category & unit (3, 4), price is 5 (at 5)
      // Let's find by label or type
      final priceField = find.widgetWithText(
        AppTextField,
        'سعر الوحدة بالجنيه (ج.م) *',
      );
      await tester.enterText(priceField, 'invalid-price');

      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(find.text('يرجى إدخال رقم صحيح (مثال: 15.50)'), findsOneWidget);
    });

    testWidgets('creates product successfully with piastre conversion', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      final codeField = find.widgetWithText(AppTextField, 'كود الصنف *');
      final nameField = find.widgetWithText(
        AppTextField,
        'اسم الصنف والمقاس *',
      );
      final priceField = find.widgetWithText(
        AppTextField,
        'سعر الوحدة بالجنيه (ج.م) *',
      );

      await tester.enterText(codeField, 'NEW-02');
      await tester.enterText(nameField, 'ماسورة 3/4 بوصة');
      await tester.enterText(priceField, '45.50');

      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(repository._products.length, 2);
      final created = repository._products.last;
      expect(created.code, 'NEW-02');
      expect(created.name, 'ماسورة 3/4 بوصة');
      expect(created.unitPricePiastres, 4550); // 45.50 EGP -> 4550 piastres
    });

    testWidgets('pre-populates fields and updates product price in edit mode', (
      tester,
    ) async {
      final existing = initialProducts.first;
      await tester.pumpWidget(createTestApp(productToEdit: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.text('افتح النموذج'));
      await tester.pumpAndSettle();

      expect(find.text('تعديل بيانات الصنف'), findsOneWidget);
      expect(find.text('P-101'), findsOneWidget);
      expect(find.text('كوع 20 مم بولي'), findsOneWidget);
      expect(find.text('12.50'), findsOneWidget);

      final priceField = find.widgetWithText(
        AppTextField,
        'سعر الوحدة بالجنيه (ج.م) *',
      );
      await tester.enterText(priceField, '18.75');

      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(repository._products.first.unitPricePiastres, 1875);
    });

    testWidgets(
      'displays duplicate code error when onSave throws PRODUCT_CODE_EXISTS',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              catalogRepositoryProvider.overrideWithValue(repository),
            ],
            child: MaterialApp(
              locale: const Locale('ar'),
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) => ProductFormDialog(
                            onSave:
                                ({
                                  required code,
                                  required name,
                                  required category,
                                  required unit,
                                  required unitPricePiastres,
                                  barcode,
                                  notes,
                                }) async {
                                  throw Exception(
                                    'PRODUCT_CODE_EXISTS: duplicate code',
                                  );
                                },
                          ),
                        );
                      },
                      child: const Text('افتح النموذج'),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('افتح النموذج'));
        await tester.pumpAndSettle();

        final codeField = find.widgetWithText(AppTextField, 'كود الصنف *');
        final nameField = find.widgetWithText(
          AppTextField,
          'اسم الصنف والمقاس *',
        );
        final priceField = find.widgetWithText(
          AppTextField,
          'سعر الوحدة بالجنيه (ج.م) *',
        );

        await tester.enterText(codeField, 'P-101');
        await tester.enterText(nameField, 'صنف مكرر');
        await tester.enterText(priceField, '20.00');

        await tester.tap(find.text('حفظ'));
        await tester.pumpAndSettle();

        expect(find.text('كود الصنف مستخدم بالفعل لمنتج آخر'), findsOneWidget);
      },
    );
  });
}
