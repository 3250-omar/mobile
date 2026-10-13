import 'package:flutter/material.dart';

import '../../domain/scanned_line_item.dart';

/// Modal dialog allowing the merchant to manually add an item to the scan review.
class ManualItemDialog extends StatefulWidget {
  final int nextLineNumber;
  final ValueChanged<ScannedLineItem> onAddItem;

  const ManualItemDialog({
    super.key,
    required this.nextLineNumber,
    required this.onAddItem,
  });

  @override
  State<ManualItemDialog> createState() => _ManualItemDialogState();
}

class _ManualItemDialogState extends State<ManualItemDialog> {
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'قطعة');
  final _priceController = TextEditingController(text: '0.00');

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة صنف جديد للقائمة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الصنف أو الوصف',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'الكمية',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'الوحدة (قطعة/متر)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'سعر الوحدة (ج.م)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;

            final qty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
            final unit = _unitController.text.trim().isEmpty
                ? 'قطعة'
                : _unitController.text.trim();
            final priceEgp =
                double.tryParse(_priceController.text.trim()) ?? 0.0;
            final pricePiastres = (priceEgp * 100).round();

            final newItem = ScannedLineItem(
              id: 'manual-item-${DateTime.now().millisecondsSinceEpoch}',
              lineNumber: widget.nextLineNumber,
              rawText: name,
              normalizedText: name,
              extractedQuantity: qty,
              extractedUnit: unit,
              isCustom: true,
              customUnitPricePiastres: pricePiastres,
              reviewStatus: ScanItemStatus.verified,
            );

            widget.onAddItem(newItem);
            Navigator.of(context).pop();
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
