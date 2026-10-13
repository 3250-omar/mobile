import 'package:flutter/material.dart';

import '../../domain/scanned_line_item.dart';

/// Modal dialog allowing the merchant to pick from matched catalog candidates
/// or keep the item as a custom line item.
class CandidateSelectorDialog extends StatefulWidget {
  final ScannedLineItem item;
  final ValueChanged<CatalogCandidateMatch> onSelectCandidate;
  final void Function(String name, int pricePiastres) onSelectCustom;

  const CandidateSelectorDialog({
    super.key,
    required this.item,
    required this.onSelectCandidate,
    required this.onSelectCustom,
  });

  @override
  State<CandidateSelectorDialog> createState() =>
      _CandidateSelectorDialogState();
}

class _CandidateSelectorDialogState extends State<CandidateSelectorDialog> {
  late final TextEditingController _customNameController;
  late final TextEditingController _customPriceController;
  bool _showCustomInputs = false;

  @override
  void initState() {
    super.initState();
    _customNameController = TextEditingController(
      text: widget.item.normalizedText.isNotEmpty
          ? widget.item.normalizedText
          : widget.item.rawText,
    );
    final initialPriceEgp = (widget.item.customUnitPricePiastres / 100);
    _customPriceController = TextEditingController(
      text: initialPriceEgp > 0 ? initialPriceEgp.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _customNameController.dispose();
    _customPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تحديد الصنف المطابق'),
          const SizedBox(height: 4),
          Text(
            'النص الأصلي: "${widget.item.rawText}"',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.item.candidates.isNotEmpty) ...[
                Text(
                  'أقرب الأصناف في كتالوج المحل:',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.item.candidates.map((candidate) {
                  final isCurrentlySelected =
                      widget.item.matchedProduct?.productId ==
                      candidate.productId;
                  final percentage = (candidate.matchScore * 100).round();

                  return Card(
                    color: isCurrentlySelected
                        ? theme.colorScheme.primaryContainer
                        : null,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        candidate.productName,
                        style: TextStyle(
                          fontWeight: isCurrentlySelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        'كود: ${candidate.productCode} • السعر: ${(candidate.unitPricePiastres / 100).toStringAsFixed(2)} ج.م',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: percentage >= 85
                              ? Colors.green.withValues(alpha: 0.15)
                              : Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$percentage%',
                          style: TextStyle(
                            color: percentage >= 85
                                ? Colors.green.shade800
                                : Colors.orange.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      onTap: () {
                        widget.onSelectCandidate(candidate);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                }),
                const Divider(height: 24),
              ],
              if (!_showCustomInputs)
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: const Text('تعيين كصنف مخصص / غير مسجل بالكتالوج'),
                  onPressed: () {
                    setState(() {
                      _showCustomInputs = true;
                    });
                  },
                )
              else ...[
                Text(
                  'بيانات الصنف المخصص:',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _customNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الصنف أو الوصف',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _customPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'سعر الوحدة (ج.م)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    final name = _customNameController.text.trim();
                    final priceEgp =
                        double.tryParse(_customPriceController.text.trim()) ??
                        0.0;
                    final pricePiastres = (priceEgp * 100).round();
                    widget.onSelectCustom(name, pricePiastres);
                    Navigator.of(context).pop();
                  },
                  child: const Text('تأكيد الصنف المخصص'),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
      ],
    );
  }
}
