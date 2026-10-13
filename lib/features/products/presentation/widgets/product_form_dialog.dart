import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../app/theme/tokens/app_shapes.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../domain/product.dart';

/// Modal dialog for adding or editing a plumbing product.
class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({
    super.key,
    this.initialProduct,
    required this.onSave,
  });

  final Product? initialProduct;
  final Future<void> Function({
    required String code,
    required String name,
    required String category,
    required String unit,
    required int unitPricePiastres,
    String? barcode,
    String? notes,
  })
  onSave;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _unitController;
  late final TextEditingController _priceController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _notesController;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProduct;
    _codeController = TextEditingController(text: p?.code ?? '');
    _nameController = TextEditingController(text: p?.name ?? '');
    _categoryController = TextEditingController(text: p?.category ?? 'لوازم');
    _unitController = TextEditingController(text: p?.unit ?? 'قطعة');
    _priceController = TextEditingController(
      text: p != null ? p.formattedPriceEgp : '',
    );
    _barcodeController = TextEditingController(text: p?.barcode ?? '');
    _notesController = TextEditingController(text: p?.notes ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final priceText = _priceController.text.trim();
    final pricePiastres = _parsePriceToPiastres(priceText);
    if (pricePiastres == null || pricePiastres < 0) {
      setState(() {
        _errorMessage = 'يرجى إدخال سعر صحيح أكبر من أو يساوي صفر';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await widget.onSave(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        unit: _unitController.text.trim(),
        unitPricePiastres: pricePiastres,
        barcode: _barcodeController.text.trim().isEmpty
            ? null
            : _barcodeController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = e.toString().contains('PRODUCT_CODE_EXISTS')
            ? 'كود الصنف مستخدم بالفعل لمنتج آخر'
            : 'حدث خطأ أثناء حفظ المنتج، يرجى المحاولة مرة أخرى';
      });
    }
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
    final isEditing = widget.initialProduct != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppShapes.roundedLg),
      title: Text(isEditing ? 'تعديل بيانات الصنف' : 'إضافة صنف جديد'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage != null) ...[
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
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Code and Barcode row
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'كود الصنف *',
                        controller: _codeController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'الكود مطلوب'
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        label: 'الباركود (اختياري)',
                        controller: _barcodeController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Name
                AppTextField(
                  label: 'اسم الصنف والمقاس *',
                  controller: _nameController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'اسم الصنف مطلوب'
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Category and Unit row
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'الفئة / التصنيف *',
                        controller: _categoryController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'الفئة مطلوبة'
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        label: 'الوحدة *',
                        controller: _unitController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'الوحدة مطلوبة'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Price
                AppTextField(
                  label: 'سعر الوحدة بالجنيه (ج.م) *',
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'السعر مطلوب';
                    if (_parsePriceToPiastres(val) == null) {
                      return 'يرجى إدخال رقم صحيح (مثال: 15.50)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),

                // Notes
                AppTextField(
                  label: 'ملاحظات إضافية',
                  controller: _notesController,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      actions: [
        AppButton(
          label: 'إلغاء',
          isSecondary: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppButton(
          label: _isSaving ? 'جاري الحفظ...' : 'حفظ',
          isLoading: _isSaving,
          onPressed: _isSaving ? null : _submit,
        ),
      ],
    );
  }
}
