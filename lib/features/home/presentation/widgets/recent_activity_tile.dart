import 'package:flutter/material.dart';

import '../../../../app/localization/bidi_text.dart';
import '../../domain/recent_activity_item.dart';

/// Presentation card/tile representing a recent quotation or invoice activity.
class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final RecentActivityItem item;
  final VoidCallback onTap;

  String _formatEgp(int piastres) {
    final pounds = piastres ~/ 100;
    final rem = (piastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$rem ج.م';
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  (String label, Color color) _getStatusBadge(
    BuildContext context,
    String status,
  ) {
    final theme = Theme.of(context);
    switch (status) {
      case 'accepted':
      case 'paid':
        return (status == 'paid' ? 'مسددة' : 'معتمد', Colors.green.shade700);
      case 'partiallyPaid':
        return ('مسددة جزئياً', Colors.orange.shade800);
      case 'unpaid':
        return ('غير مسددة', Colors.red.shade700);
      case 'sent':
        return ('مرسل', theme.colorScheme.primary);
      case 'draft':
        return ('مسودة', theme.colorScheme.outline);
      case 'rejected':
      case 'cancelled':
        return (
          status == 'cancelled' ? 'ملغاة' : 'مرفوض',
          theme.colorScheme.error,
        );
      case 'convertedToInvoice':
        return ('محولة لفاتورة', Colors.teal.shade700);
      default:
        return (status, theme.colorScheme.outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInvoice = item.type == ActivityType.invoice;
    final icon = isInvoice
        ? Icons.receipt_long_outlined
        : Icons.description_outlined;
    final iconColor = isInvoice
        ? theme.colorScheme.primary
        : Colors.teal.shade700;
    final (statusLabel, statusColor) = _getStatusBadge(context, item.status);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          BidiText.wrapLtr(item.referenceNumber),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.customerName.isEmpty
                          ? 'عميل نقدي'
                          : item.customerName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    BidiText.wrapLtr(_formatEgp(item.amountPiastres)),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.updatedAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
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
}
