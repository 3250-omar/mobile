import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/navigation/route_names.dart';
import '../../invoices/domain/invoice.dart';
import '../../quotations/domain/quotation.dart';
import '../application/scan_state.dart';
import 'widgets/line_item_review_tile.dart';
import 'widgets/manual_item_dialog.dart';

/// Interactive review screen for OCR-extracted plumbing items.
class ScanReviewScreen extends ConsumerWidget {
  const ScanReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanControllerProvider);
    final scanController = ref.read(scanControllerProvider.notifier);
    final theme = Theme.of(context);

    // Compute grand total
    var grandTotalPiastres = 0;
    for (final item in scanState.items) {
      grandTotalPiastres +=
          (item.effectiveUnitPricePiastres * item.extractedQuantity).round();
    }
    final grandTotalEgp = (grandTotalPiastres / 100).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة الأصناف المستخرجة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة صنف يدوياً',
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => ManualItemDialog(
                  nextLineNumber: scanState.items.length + 1,
                  onAddItem: scanController.addItem,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'إعادة مسح ورقة جديدة',
            onPressed: () {
              scanController.reset();
              context.pop();
            },
          ),
        ],
      ),
      body: scanState.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  const Text('لا توجد بنود مستخرجة في هذه الجلسة'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة صنف يدوياً'),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => ManualItemDialog(
                          nextLineNumber: 1,
                          onAddItem: scanController.addItem,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Summary metrics bar
                Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'إجمالي الأصناف: ${scanState.items.length}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (scanState.needsReviewCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'بحاجة لمراجعة: ${scanState.needsReviewCount}',
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Text(
                        'الإجمالي: $grandTotalEgp ج.م',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // List of scanned items
                Expanded(
                  child: ListView.builder(
                    itemCount: scanState.items.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final item = scanState.items[index];
                      return LineItemReviewTile(
                        key: ValueKey(item.id),
                        item: item,
                        onUpdateItem: scanController.updateItem,
                        onDelete: () => scanController.deleteItem(item.id),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: scanState.items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        icon: const Icon(Icons.request_quote_outlined),
                        label: const Text('إنشاء عرض سعر'),
                        onPressed: () =>
                            _convertToQuotation(context, scanState),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('إنشاء فاتورة'),
                        onPressed: () => _convertToInvoice(context, scanState),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _convertToQuotation(BuildContext context, ScanState state) {
    final quotationDrafts = state.items.map((item) {
      return QuotationItemDraft(
        productId: item.matchedProduct?.productId,
        productCode: item.matchedProduct?.productCode ?? 'CUSTOM',
        productName: item.effectiveTitle,
        unit: item.extractedUnit,
        unitPricePiastres: item.effectiveUnitPricePiastres,
        quantity: item.extractedQuantity.round().clamp(1, 999999),
      );
    }).toList();

    context.pushNamed(RouteNames.quotationNew, extra: quotationDrafts);
  }

  void _convertToInvoice(BuildContext context, ScanState state) {
    final invoiceDrafts = state.items.map((item) {
      return InvoiceItemDraft(
        productId: item.matchedProduct?.productId,
        productCode: item.matchedProduct?.productCode ?? 'CUSTOM',
        productName: item.effectiveTitle,
        unit: item.extractedUnit,
        unitPricePiastres: item.effectiveUnitPricePiastres,
        quantity: item.extractedQuantity.round().clamp(1, 999999),
      );
    }).toList();

    context.pushNamed(RouteNames.invoiceNew, extra: invoiceDrafts);
  }
}
