import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/localization/bidi_text.dart';
import '../../../app/theme/tokens/app_colors.dart';
import '../../../app/theme/tokens/app_shapes.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../products/domain/product.dart';
import '../application/invoice_form_controller.dart';
import '../domain/invoice.dart';

/// Interactive Arabic screen for building and persisting new sales invoices.
class InvoiceFormScreen extends ConsumerStatefulWidget {
  const InvoiceFormScreen({super.key, this.initialItems});

  final List<InvoiceItemDraft>? initialItems;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  late final TextEditingController _discountController;
  late final TextEditingController _taxController;

  late final StateNotifierProvider<InvoiceFormController, InvoiceFormState>
  _formProvider;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _notesController = TextEditingController();
    _discountController = TextEditingController();
    _taxController = TextEditingController();

    _formProvider =
        StateNotifierProvider<InvoiceFormController, InvoiceFormState>(
          (ref) => InvoiceFormController(
            ref.watch(invoiceRepositoryProvider),
            initialItems: widget.initialItems,
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  int? _parsePriceToPiastres(String text) {
    var cleaned = text.replaceAll('٫', '.').replaceAll(',', '.').trim();
    cleaned = cleaned
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
    final match = RegExp(r'^\d+(\.\d+)?$').firstMatch(cleaned);
    if (match == null) return null;
    final parts = cleaned.split('.');
    final pounds = int.tryParse(parts[0]) ?? 0;
    if (parts.length == 1) return pounds * 100;
    var piastresStr = parts[1];
    if (piastresStr.length == 1) piastresStr = '${piastresStr}0';
    if (piastresStr.length > 2) piastresStr = piastresStr.substring(0, 2);
    final piastres = int.tryParse(piastresStr) ?? 0;
    return (pounds * 100) + piastres;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(_formProvider);
    final formCtrl = ref.read(_formProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء فاتورة مبيعات جديدة')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (formState.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: AppShapes.roundedSm,
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          formState.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Customer Details Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بيانات العميل والفاتورة',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'اسم العميل أو المؤسسة *',
                      hintText: 'مثال: شركة النيل للتجارة أو الأستاذ محمد',
                      controller: _nameController,
                      onChanged: formCtrl.setCustomerName,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: 'رقم الهاتف (اختياري)',
                      hintText: '01012345678',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: formCtrl.setCustomerPhone,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: 'ملاحظات الفاتورة (اختياري)',
                      hintText: 'شروط الدفع والتسليم...',
                      controller: _notesController,
                      maxLines: 2,
                      onChanged: formCtrl.setNotes,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Items Header & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'بنود وأصناف الفاتورة (${formState.items.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.playlist_add, size: 18),
                        label: const Text('صنف مخصص'),
                        onPressed: () =>
                            _showAddCustomItemDialog(context, formCtrl),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      FilledButton.icon(
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text('من الدليل'),
                        onPressed: () => _showCatalogPicker(context, formCtrl),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Items List
              if (formState.items.isEmpty)
                const AppEmptyState(
                  icon: Icons.shopping_basket_outlined,
                  title: 'لم يتم إضافة أصناف بعد',
                  message: 'أضف أصناف من دليل المنتجات أو أضف بنداً مخصصاً',
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: formState.items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = formState.items[index];
                    return _InvoiceItemTile(
                      item: item,
                      index: index,
                      onQuantityChanged: (newQty) {
                        formCtrl.updateItem(
                          index,
                          InvoiceItemDraft(
                            productId: item.productId,
                            productCode: item.productCode,
                            productName: item.productName,
                            unit: item.unit,
                            unitPricePiastres: item.unitPricePiastres,
                            quantity: newQty,
                            lineDiscountPiastres: item.lineDiscountPiastres,
                          ),
                        );
                      },
                      onRemove: () => formCtrl.removeItem(index),
                    );
                  },
                ),

              const SizedBox(height: AppSpacing.md),

              // Summary Calculations Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ملخص الحساب الإجمالي',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SummaryRow(
                      label: 'المجموع الفرعي:',
                      value: '${formState.formattedSubtotalEgp} ج.م',
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Text('خصم إضافي (ج.م):'),
                        const SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _discountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              hintText: '0.00',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                            onChanged: (val) {
                              final p = _parsePriceToPiastres(val) ?? 0;
                              formCtrl.setDiscountPiastres(p);
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '- ${formState.formattedDiscountEgp} ج.م',
                          style: TextStyle(
                            color: isDark
                                ? Colors.orange[300]
                                : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Text('ضريبة القيمة المضافة (ج.م):'),
                        const SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _taxController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              hintText: '0.00',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                            onChanged: (val) {
                              final p = _parsePriceToPiastres(val) ?? 0;
                              formCtrl.setTaxPiastres(p);
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '+ ${formState.formattedTaxEgp} ج.م',
                          style: TextStyle(
                            color: isDark ? Colors.blue[300] : Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: AppSpacing.md),
                    _SummaryRow(
                      label: 'الإجمالي النهائي المطلوب:',
                      value: '${formState.formattedGrandTotalEgp} ج.م',
                      isBold: true,
                      valueColor: isDark
                          ? AppColors.darkAction
                          : AppColors.lightAction,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Bottom Actions
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'إلغاء',
                      isSecondary: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: formState.isSaving
                          ? 'جاري الحفظ...'
                          : 'حفظ الفاتورة',
                      isLoading: formState.isSaving,
                      onPressed: formState.isSaving
                          ? null
                          : () async {
                              final inv = await formCtrl.saveInvoice();
                              if (inv != null && context.mounted) {
                                Navigator.of(context).pop(inv);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCatalogPicker(
    BuildContext context,
    InvoiceFormController formCtrl,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CatalogPickerSheet(
        onProductSelected: (Product prod) {
          formCtrl.addItem(
            InvoiceItemDraft(
              productId: prod.id,
              productCode: prod.code,
              productName: prod.name,
              unit: prod.unit,
              unitPricePiastres: prod.unitPricePiastres,
              quantity: 1,
            ),
          );
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  void _showAddCustomItemDialog(
    BuildContext context,
    InvoiceFormController formCtrl,
  ) {
    final nameCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'قطعة');
    final qtyCtrl = TextEditingController(text: '1');
    final priceCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('إضافة صنف مخصص'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(label: 'اسم الصنف *', controller: nameCtrl),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppTextField(label: 'الوحدة', controller: unitCtrl),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    label: 'الكمية',
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'سعر الوحدة بالجنيه (ج.م) *',
              controller: priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final priceP = _parsePriceToPiastres(priceCtrl.text) ?? 0;
              final qty = int.tryParse(qtyCtrl.text.trim()) ?? 1;

              if (name.isNotEmpty && priceP > 0) {
                formCtrl.addItem(
                  InvoiceItemDraft(
                    productCode: 'CUSTOM',
                    productName: name,
                    unit: unitCtrl.text.trim(),
                    unitPricePiastres: priceP,
                    quantity: qty > 0 ? qty : 1,
                  ),
                );
                Navigator.of(dialogCtx).pop();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class _InvoiceItemTile extends StatelessWidget {
  const _InvoiceItemTile({
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final InvoiceItemDraft item;
  final int index;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pounds = item.lineTotalPiastres ~/ 100;
    final piastres = (item.lineTotalPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    final formattedLineTotal = '$pounds.$piastres';

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${BidiText.wrapLtr(item.productCode)} • ${(item.unitPricePiastres / 100).toStringAsFixed(2)} ج.م / ${item.unit}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: item.quantity > 1
                    ? () => onQuantityChanged(item.quantity - 1)
                    : onRemove,
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: () => onQuantityChanged(item.quantity + 1),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$formattedLineTotal ج.م',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _CatalogPickerSheet extends ConsumerStatefulWidget {
  const _CatalogPickerSheet({required this.onProductSelected});

  final ValueChanged<Product> onProductSelected;

  @override
  ConsumerState<_CatalogPickerSheet> createState() =>
      _CatalogPickerSheetState();
}

class _CatalogPickerSheetState extends ConsumerState<_CatalogPickerSheet> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogControllerProvider);
    final products = catalogState.products;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اختيار صنف من الدليل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppTextField(
            hintText: 'بحث بالاسم أو الكود...',
            controller: _searchCtrl,
            onChanged: (q) =>
                ref.read(catalogControllerProvider.notifier).onSearchChanged(q),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 350,
            child: products.isEmpty
                ? const Center(child: Text('لا توجد أصناف مطابقة'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      final prod = products[i];
                      return ListTile(
                        title: Text(prod.name),
                        subtitle: Text(
                          '${BidiText.wrapLtr(prod.code)} • ${prod.formattedPriceEgp} ج.م / ${prod.unit}',
                        ),
                        trailing: const Icon(Icons.add_shopping_cart, size: 20),
                        onTap: () => widget.onProductSelected(prod),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
