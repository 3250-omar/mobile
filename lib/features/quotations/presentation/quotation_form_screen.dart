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
import '../application/quotation_form_controller.dart';
import '../domain/quotation.dart';

/// Interactive Arabic screen for building and editing quotation drafts.
class QuotationFormScreen extends ConsumerStatefulWidget {
  const QuotationFormScreen({
    super.key,
    this.existingQuotation,
    this.initialItems,
  });

  final Quotation? existingQuotation;
  final List<QuotationItemDraft>? initialItems;

  @override
  ConsumerState<QuotationFormScreen> createState() =>
      _QuotationFormScreenState();
}

class _QuotationFormScreenState extends ConsumerState<QuotationFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  late final TextEditingController _discountController;

  late final StateNotifierProvider<QuotationFormController, QuotationFormState>
  _formProvider;

  @override
  void initState() {
    super.initState();
    final q = widget.existingQuotation;
    _nameController = TextEditingController(text: q?.customerName ?? '');
    _phoneController = TextEditingController(text: q?.customerPhone ?? '');
    _notesController = TextEditingController(text: q?.notes ?? '');
    _discountController = TextEditingController(
      text: q != null && q.discountPiastres > 0 ? q.formattedDiscountEgp : '',
    );

    _formProvider =
        StateNotifierProvider<QuotationFormController, QuotationFormState>(
          (ref) => QuotationFormController(
            initialQuotation: q,
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
    final repository = ref.watch(quotationRepositoryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formState.isEditing
              ? 'تعديل عرض السعر (${formState.referenceNumber})'
              : 'إنشاء عرض سعر جديد',
        ),
      ),
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
                  child: Text(
                    formState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Customer details card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'بيانات العميل',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: 'اسم العميل أو المؤسسة *',
                      controller: _nameController,
                      onChanged: formCtrl.setCustomerName,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'رقم الهاتف (اختياري)',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            isBidiIsolated: true,
                            onChanged: formCtrl.setCustomerPhone,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppTextField(
                            label: 'ملاحظات العرض (اختياري)',
                            controller: _notesController,
                            onChanged: formCtrl.setNotes,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Line Items section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'بنود وأصناف عرض السعر',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('من الدليل'),
                        onPressed: () => _openCatalogPicker(context, formCtrl),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_note, size: 18),
                        label: const Text('صنف مخصص'),
                        onPressed: () =>
                            _openCustomItemDialog(context, formCtrl),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Line items list or empty state
              if (formState.items.isEmpty)
                AppCard(
                  child: AppEmptyState(
                    title: 'لم تتم إضافة أي أصناف بعد',
                    message: 'اختر أصنافاً من دليل المنتجات المحلي أو أضف بنوداً مخصصة',
                    actionLabel: 'إضافة من الدليل',
                    onAction: () => _openCatalogPicker(context, formCtrl),
                  ),
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
                    return _QuotationItemTile(
                      item: item,
                      index: index,
                      onQuantityChanged: (qty) {
                        formCtrl.updateItem(
                          index,
                          QuotationItemDraft(
                            productId: item.productId,
                            productCode: item.productCode,
                            productName: item.productName,
                            unit: item.unit,
                            unitPricePiastres: item.unitPricePiastres,
                            quantity: qty,
                            lineDiscountPiastres: item.lineDiscountPiastres,
                          ),
                        );
                      },
                      onRemove: () => formCtrl.removeItem(index),
                    );
                  },
                ),

              const SizedBox(height: AppSpacing.md),

              // Summary and Financial Totals Card
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
                      label: 'المجموع الفرعي (قبل الخصم):',
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
                          : formState.isEditing
                          ? 'حفظ التعديلات'
                          : 'حفظ كمسودة',
                      isLoading: formState.isSaving,
                      onPressed: formState.isSaving
                          ? null
                          : () async {
                              final ok = await formCtrl.saveQuotation(
                                repository,
                              );
                              if (ok && context.mounted) {
                                Navigator.of(context)
                                    .pop(formState.savedQuotation);
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

  void _openCatalogPicker(
    BuildContext context,
    QuotationFormController formCtrl,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => _CatalogPickerModal(
        onProductSelected: (product) {
          formCtrl.addItem(
            QuotationItemDraft(
              productId: product.id,
              productCode: product.code,
              productName: product.name,
              unit: product.unit,
              unitPricePiastres: product.unitPricePiastres,
              quantity: 1,
            ),
          );
        },
      ),
    );
  }

  void _openCustomItemDialog(
    BuildContext context,
    QuotationFormController formCtrl,
  ) {
    final nameCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'قطعة');
    final priceCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('إضافة صنف مخصص'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(label: 'اسم الصنف والمواصفات *', controller: nameCtrl),
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
                  QuotationItemDraft(
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

class _QuotationItemTile extends StatelessWidget {
  const _QuotationItemTile({
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final QuotationItemDraft item;
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
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: item.quantity > 1
                    ? () => onQuantityChanged(item.quantity - 1)
                    : null,
              ),
              Text(
                '${item.quantity}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: () => onQuantityChanged(item.quantity + 1),
              ),
            ],
          ),
          SizedBox(
            width: 80,
            child: Text(
              '$formattedLineTotal ج.م',
              textAlign: TextAlign.end,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
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
    final style = isBold
        ? theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          )
        : theme.textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _CatalogPickerModal extends ConsumerStatefulWidget {
  const _CatalogPickerModal({required this.onProductSelected});

  final ValueChanged<Product> onProductSelected;

  @override
  ConsumerState<_CatalogPickerModal> createState() =>
      _CatalogPickerModalState();
}

class _CatalogPickerModalState extends ConsumerState<_CatalogPickerModal> {
  List<Product> _products = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final repo = ref.read(catalogRepositoryProvider);
    final results = await repo.searchProducts(query, limit: 50);
    if (mounted) {
      setState(() {
        _products = results;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppShapes.roundedLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'اختر صنفاً من الدليل',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'ابحث بالاسم أو الكود...',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                ),
                onChanged: _search,
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                    ? const Center(child: Text('لا توجد أصناف مطابقة'))
                    : ListView.separated(
                        itemCount: _products.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final p = _products[index];
                          return ListTile(
                            title: Text(p.name),
                            subtitle: Text(
                              '${BidiText.wrapLtr(p.code)} • ${p.category}',
                            ),
                            trailing: Text(
                              '${p.formattedPriceEgp} ج.م',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              widget.onProductSelected(p);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
