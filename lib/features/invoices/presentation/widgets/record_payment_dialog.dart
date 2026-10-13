import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/invoice.dart';

/// Modal dialog for recording a customer payment installment against an invoice.
class RecordPaymentDialog extends StatefulWidget {
  const RecordPaymentDialog({
    super.key,
    required this.invoice,
    required this.onRecordPayment,
  });

  final Invoice invoice;
  final Future<void> Function({
    required int amountPiastres,
    required PaymentMethod paymentMethod,
    DateTime? paymentDate,
    String? notes,
  })
  onRecordPayment;

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  final DateTime _paymentDate = DateTime.now();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Default to remaining balance
    _amountController.text = widget.invoice.formattedRemainingBalanceEgp;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int? _parseAmountToPiastres(String text) {
    final clean = text.trim().replaceAll(',', '.');
    final val = double.tryParse(clean);
    if (val == null || val <= 0) return null;
    return (val * 100).round();
  }

  Future<void> _submit() async {
    final amountPiastres = _parseAmountToPiastres(_amountController.text);
    if (amountPiastres == null || amountPiastres <= 0) {
      setState(() {
        _errorMessage = 'يرجى إدخال مبلغ صحيح أكبر من الصفر';
      });
      return;
    }

    if (amountPiastres > widget.invoice.remainingBalancePiastres) {
      setState(() {
        _errorMessage =
            'المبلغ المدخل أكبر من المتبقي على الفاتورة (${widget.invoice.formattedRemainingBalanceEgp} ج.م)';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await widget.onRecordPayment(
        amountPiastres: amountPiastres,
        paymentMethod: _selectedMethod,
        paymentDate: _paymentDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'تعذر تسجيل الدفعة: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'تسجيل دفعة للفاتورة',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('رقم الفاتورة:')),
                          Text(
                            widget.invoice.referenceNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Expanded(child: Text('المتبقي المطلوب:')),
                          Text(
                            '${widget.invoice.formattedRemainingBalanceEgp} ج.م',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _amountController,
                  label: 'المبلغ المسدد (ج.م)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<PaymentMethod>(
                  initialValue: _selectedMethod,
                  decoration: const InputDecoration(
                    labelText: 'طريقة الدفع',
                    border: OutlineInputBorder(),
                  ),
                  items: PaymentMethod.values.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method.arabicLabel),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedMethod = val);
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _notesController,
                  label: 'ملاحظات الدفعة (اختياري)',
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('إلغاء'),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: 'تأكيد التسجيل',
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
