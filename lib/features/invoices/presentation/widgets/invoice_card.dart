import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../domain/invoice.dart';

/// Interactive card widget for displaying an invoice in the list.
class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
    this.onRecordPayment,
    this.onPrintA4,
    this.onPrintReceipt,
    this.onCancel,
    this.onDelete,
  });

  final Invoice invoice;
  final VoidCallback? onTap;
  final VoidCallback? onRecordPayment;
  final VoidCallback? onPrintA4;
  final VoidCallback? onPrintReceipt;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.partiallyPaid:
        return Colors.orange;
      case InvoiceStatus.unpaid:
        return Colors.blue;
      case InvoiceStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(invoice.status);

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header row: Reference, Status, Popup menu
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      invoice.referenceNumber,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      invoice.status.arabicLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    tooltip: 'خيارات الفاتورة',
                    onSelected: (val) {
                      switch (val) {
                        case 'print_a4':
                          onPrintA4?.call();
                          break;
                        case 'print_receipt':
                          onPrintReceipt?.call();
                          break;
                        case 'record_payment':
                          onRecordPayment?.call();
                          break;
                        case 'cancel':
                          onCancel?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'print_a4',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.picture_as_pdf_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('طباعة PDF'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'print_receipt',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('إيصال حراري'),
                          ],
                        ),
                      ),
                      if (invoice.status != InvoiceStatus.paid &&
                          invoice.status != InvoiceStatus.cancelled) ...[
                        const PopupMenuItem(
                          value: 'record_payment',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                size: 18,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text('تسجيل دفعة'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 18,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text('إلغاء الفاتورة'),
                            ],
                          ),
                        ),
                      ],
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'حذف الفاتورة',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Customer name & date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      invoice.customerName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${invoice.issueDate.year}-${invoice.issueDate.month.toString().padLeft(2, '0')}-${invoice.issueDate.day.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (invoice.customerPhone != null &&
                  invoice.customerPhone!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  invoice.customerPhone!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Financial Breakdown: Total, Paid, Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SummaryColumn(
                    title: 'الإجمالي',
                    value: '${invoice.formattedGrandTotalEgp} ج.م',
                    valueColor: theme.colorScheme.onSurface,
                  ),
                  _SummaryColumn(
                    title: 'المسدد',
                    value: '${invoice.formattedPaidAmountEgp} ج.م',
                    valueColor: Colors.green,
                  ),
                  _SummaryColumn(
                    title: 'المتبقي',
                    value: '${invoice.formattedRemainingBalanceEgp} ج.م',
                    valueColor: invoice.remainingBalancePiastres > 0
                        ? Colors.red
                        : Colors.green,
                  ),
                ],
              ),

              // Quick action buttons if remaining balance > 0
              if (invoice.status != InvoiceStatus.paid &&
                  invoice.status != InvoiceStatus.cancelled) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                      label: const Text('PDF'),
                      onPressed: onPrintA4,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.payments_outlined, size: 16),
                      label: const Text('تسجيل دفعة'),
                      onPressed: onRecordPayment,
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
