import 'package:flutter/material.dart';

import '../../../../app/localization/bidi_text.dart';
import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_shapes.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/quotation.dart';

/// Card widget rendering quotation metadata, status badge, financial total, and quick actions.
class QuotationCard extends StatelessWidget {
  const QuotationCard({
    super.key,
    required this.quotation,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onDelete,
    this.onStatusChanged,
    this.onConvertToInvoice,
  });

  final Quotation quotation;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final ValueChanged<QuotationStatus>? onStatusChanged;
  final VoidCallback? onConvertToInvoice;

  Color _getStatusColor(QuotationStatus status, bool isDark) {
    switch (status) {
      case QuotationStatus.draft:
        return isDark ? Colors.grey[400]! : Colors.grey[700]!;
      case QuotationStatus.sent:
        return isDark ? AppColors.darkAction : AppColors.lightAction;
      case QuotationStatus.accepted:
        return isDark ? Colors.green[400]! : Colors.green[700]!;
      case QuotationStatus.rejected:
        return isDark ? AppColors.darkError : AppColors.lightError;
      case QuotationStatus.convertedToInvoice:
        return isDark ? Colors.purple[300]! : Colors.purple[700]!;
    }
  }

  Color _getStatusBgColor(QuotationStatus status, bool isDark) {
    switch (status) {
      case QuotationStatus.draft:
        return (isDark ? Colors.grey[700]! : Colors.grey[200]!).withValues(
          alpha: 0.5,
        );
      case QuotationStatus.sent:
        return (isDark ? Colors.blue[900]! : Colors.blue[50]!).withValues(
          alpha: 0.5,
        );
      case QuotationStatus.accepted:
        return (isDark ? Colors.green[900]! : Colors.green[50]!).withValues(
          alpha: 0.5,
        );
      case QuotationStatus.rejected:
        return (isDark ? Colors.red[900]! : Colors.red[50]!).withValues(
          alpha: 0.5,
        );
      case QuotationStatus.convertedToInvoice:
        return (isDark ? Colors.purple[900]! : Colors.purple[50]!).withValues(
          alpha: 0.5,
        );
    }
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor(quotation.status, isDark);
    final statusBgColor = _getStatusBgColor(quotation.status, isDark);

    return AppCard(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Reference + Status Badge + Popup Menu
            Row(
              children: [
                Text(
                  BidiText.wrapLtr(quotation.referenceNumber),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: AppShapes.roundedSm,
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (quotation.isLocked) ...[
                        Icon(Icons.lock, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        quotation.status.arabicLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  tooltip: 'خيارات عرض السعر',
                  onSelected: (val) {
                    switch (val) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'duplicate':
                        onDuplicate?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                      case 'convert_to_invoice':
                        onConvertToInvoice?.call();
                        break;
                      case 'status_draft':
                        onStatusChanged?.call(QuotationStatus.draft);
                        break;
                      case 'status_sent':
                        onStatusChanged?.call(QuotationStatus.sent);
                        break;
                      case 'status_accepted':
                        onStatusChanged?.call(QuotationStatus.accepted);
                        break;
                      case 'status_rejected':
                        onStatusChanged?.call(QuotationStatus.rejected);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (!quotation.isLocked)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('نسخ كمسودة'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    if (!quotation.isLocked) ...[
                      if (quotation.status != QuotationStatus.sent)
                        const PopupMenuItem(
                          value: 'status_sent',
                          child: Row(
                            children: [
                              Icon(Icons.send_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('تحديد كمرسل'),
                            ],
                          ),
                        ),
                      if (quotation.status != QuotationStatus.accepted)
                        const PopupMenuItem(
                          value: 'status_accepted',
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text('قبول العرض'),
                            ],
                          ),
                        ),
                      if (quotation.status != QuotationStatus.rejected)
                        const PopupMenuItem(
                          value: 'status_rejected',
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text('تحديد كمرفوض'),
                            ],
                          ),
                        ),
                      const PopupMenuDivider(),
                    ],
                    if (quotation.status !=
                        QuotationStatus.convertedToInvoice) ...[
                      const PopupMenuItem(
                        value: 'convert_to_invoice',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 18,
                              color: Colors.purple,
                            ),
                            SizedBox(width: 8),
                            Text('تحويل لفاتورة'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                    ],
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'حذف عرض السعر',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            // Customer Name & Optional Phone
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    quotation.customerName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (quotation.customerPhone != null &&
                    quotation.customerPhone!.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.phone_outlined, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    BidiText.wrapLtr(quotation.customerPhone!),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Footer: Date + Items Count + Grand Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(quotation.issueDate),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '• ${quotation.items.length} بنود',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  '${quotation.formattedGrandTotalEgp} ج.م',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkAction
                        : AppColors.lightAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
