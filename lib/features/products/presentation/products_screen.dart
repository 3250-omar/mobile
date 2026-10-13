import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading_state.dart';
import '../application/catalog_controller.dart';
import '../application/import_controller.dart';
import '../data/excel_importer.dart';
import '../domain/catalog_repository.dart';
import '../domain/product.dart';
import 'widgets/import_summary_dialog.dart';
import 'widgets/product_card.dart';
import 'widgets/product_form_dialog.dart';
import 'widgets/product_search_bar.dart';

/// Interactive Arabic screen displaying the plumbing products catalog with instant search,
/// category filtering, manual product creation/editing, and Excel import/export.
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogControllerProvider);
    final catalogCtrl = ref.read(catalogControllerProvider.notifier);
    final importState = ref.watch(importControllerProvider);
    final importCtrl = ref.read(importControllerProvider.notifier);
    final repository = ref.watch(catalogRepositoryProvider);

    // Listen to import state changes to display the summary dialog or error alerts
    ref.listen<ImportState>(importControllerProvider, (prev, next) {
      if (next is ImportSuccess) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogCtx) => ImportSummaryDialog(
            summary: next.summary,
            onDismiss: () {
              importCtrl.reset();
              catalogCtrl.loadCatalog();
            },
          ),
        );
      } else if (next is ImportFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.failure.messageKey == 'error_file_empty_or_unreadable'
                  ? 'الملف المحدد فارغ أو تعذر قراءته'
                  : 'فشل استيراد الملف، يرجى التأكد من تنسيق ملف الإكسيل',
            ),
            backgroundColor: Colors.red,
          ),
        );
        importCtrl.reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الأصناف والمنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'تصدير كإكسيل',
            onPressed: catalogState.products.isEmpty
                ? null
                : () => _exportCatalog(context, catalogState.products),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'استيراد من إكسيل',
            onPressed: () => importCtrl.pickAndImportFile(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Instant Search and Category Filter Bar
            ProductSearchBar(
              searchQuery: catalogState.searchQuery,
              onSearchChanged: catalogCtrl.onSearchChanged,
              categories: catalogState.categories,
              selectedCategory: catalogState.selectedCategory,
              onCategorySelected: catalogCtrl.onCategorySelected,
            ),

            // Import Progress Indicator if active
            if (importState is ImportPickingFile ||
                importState is ImportParsing ||
                importState is ImportPersisting)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      importState is ImportPickingFile
                          ? 'جاري اختيار الملف...'
                          : importState is ImportParsing
                          ? 'جاري قراءة وتحليل بيانات الإكسيل...'
                          : 'جاري حفظ الأصناف في قاعدة البيانات...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

            // Main Product Content Area
            Expanded(
              child: catalogState.isLoading
                  ? const AppLoadingState(message: 'جاري تحميل دليل الأصناف...')
                  : catalogState.products.isEmpty
                  ? catalogState.searchQuery.isNotEmpty ||
                            catalogState.selectedCategory != null
                        ? AppEmptyState(
                            title: 'لا توجد نتائج',
                            message: 'لا توجد أصناف مطابقة لبحثك',
                            actionLabel: 'مسح البحث',
                            onAction: () {
                              catalogCtrl.onSearchChanged('');
                              catalogCtrl.onCategorySelected(null);
                            },
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'دليل الأصناف فارغ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'يمكنك استيراد قائمة الأصناف من ملف إكسيل أو إضافة صنف يدوياً',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppButton(
                                        label: 'استيراد ملف إكسيل',
                                        onPressed: () =>
                                            importCtrl.pickAndImportFile(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.xs,
                        bottom: 80,
                      ),
                      itemCount: catalogState.products.length,
                      itemBuilder: (context, index) {
                        final product = catalogState.products[index];
                        return ProductCard(
                          product: product,
                          onEdit: () => _openEditDialog(
                            context,
                            product,
                            repository,
                            catalogCtrl,
                          ),
                          onDelete: () =>
                              _confirmDelete(context, product, catalogCtrl),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('إضافة صنف'),
        onPressed: () => _openCreateDialog(context, repository, catalogCtrl),
      ),
    );
  }

  void _openCreateDialog(
    BuildContext context,
    CatalogRepository repository,
    CatalogController catalogCtrl,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => ProductFormDialog(
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
              await repository.createProduct(
                code: code,
                name: name,
                category: category,
                unit: unit,
                unitPricePiastres: unitPricePiastres,
                barcode: barcode,
                notes: notes,
              );
              await catalogCtrl.loadCatalog();
            },
      ),
    );
  }

  void _openEditDialog(
    BuildContext context,
    Product product,
    CatalogRepository repository,
    CatalogController catalogCtrl,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => ProductFormDialog(
        initialProduct: product,
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
              await repository.updateProduct(
                id: product.id,
                code: code,
                name: name,
                category: category,
                unit: unit,
                unitPricePiastres: unitPricePiastres,
                barcode: barcode,
                notes: notes,
              );
              await catalogCtrl.loadCatalog();
            },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    Product product,
    CatalogController catalogCtrl,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AppConfirmationDialog(
        title: 'تأكيد الحذف',
        message: 'هل أنت متأكد من حذف الصنف "${product.name}"؟',
        confirmLabel: 'حذف',
        cancelLabel: 'إلغاء',
        isDestructive: true,
        onConfirm: () => catalogCtrl.deleteProduct(product.id),
      ),
    );
  }

  Future<void> _exportCatalog(
    BuildContext context,
    List<Product> products,
  ) async {
    const importer = ExcelCatalogImporter();
    final bytes = importer.exportToExcel(products);

    final uri = await FilePicker.saveFile(
      dialogTitle: 'حفظ ملف الأصناف',
      fileName: 'catalog_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: Uint8List.fromList(bytes),
    );

    if (context.mounted) {
      if (uri != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تصدير ملف الأصناف بنجاح')),
        );
      }
    }
  }
}
