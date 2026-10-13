import 'package:flutter/material.dart';

import '../../domain/scanned_line_item.dart';
import 'candidate_selector_dialog.dart';

/// Card widget representing an individual scanned item in the review screen.
class LineItemReviewTile extends StatelessWidget {
  final ScannedLineItem item;
  final ValueChanged<ScannedLineItem> onUpdateItem;
  final VoidCallback onDelete;

  const LineItemReviewTile({
    super.key,
    required this.item,
    required this.onUpdateItem,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePrice = item.effectiveUnitPricePiastres;
    final totalPiastres = (effectivePrice * item.extractedQuantity).round();
    final totalEgp = (totalPiastres / 100).toStringAsFixed(2);
    final unitPriceEgp = (effectivePrice / 100).toStringAsFixed(2);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.reviewStatus == ScanItemStatus.needsReview
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
          width: item.reviewStatus == ScanItemStatus.needsReview ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and actions row
            Row(
              children: [
                _buildStatusChip(theme, item.reviewStatus),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.manage_search, size: 22),
                  tooltip: 'اختيار الصنف أو البدائل',
                  onPressed: () => _openCandidateDialog(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 22,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: 'حذف البند',
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Item Title
            Text(
              item.effectiveTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Raw OCR line text
            Text(
              'النص المقروء: "${item.rawText}"',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),

            // Warning banner if needs review
            if (item.reviewStatus == ScanItemStatus.needsReview) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.25,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 20,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'دقة المطابقة أقل من 85% أو توجد عدة بدائل مشابهة.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            const Divider(),

            // Quantity and pricing row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity editor controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.remove, size: 16),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (item.extractedQuantity > 1) {
                          onUpdateItem(
                            item.copyWith(
                              extractedQuantity: item.extractedQuantity - 1,
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.extractedQuantity.toStringAsFixed(item.extractedQuantity.truncateToDouble() == item.extractedQuantity ? 0 : 1)} ${item.extractedUnit}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.add, size: 16),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        onUpdateItem(
                          item.copyWith(
                            extractedQuantity: item.extractedQuantity + 1,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Financials
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalEgp ج.م',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'سعر الوحدة: $unitPriceEgp ج.م',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, ScanItemStatus status) {
    switch (status) {
      case ScanItemStatus.verified:
        final percentage = item.matchedProduct != null
            ? (item.matchedProduct!.matchScore * 100).round()
            : 100;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 14, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                'مطابق ومؤكد ($percentage%)',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case ScanItemStatus.needsReview:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, size: 14, color: Colors.deepOrange),
              SizedBox(width: 4),
              Text(
                'بحاجة لمراجعة',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case ScanItemStatus.unmatched:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline,
                size: 14,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 4),
              Text(
                'صنف مخصص',
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }

  void _openCandidateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => CandidateSelectorDialog(
        item: item,
        onSelectCandidate: (candidate) {
          onUpdateItem(
            item.copyWith(
              matchedProduct: candidate,
              isCustom: false,
              reviewStatus: ScanItemStatus.verified,
            ),
          );
        },
        onSelectCustom: (customName, customPrice) {
          onUpdateItem(
            item.copyWith(
              isCustom: true,
              clearMatchedProduct: true,
              normalizedText: customName,
              customUnitPricePiastres: customPrice,
              reviewStatus: ScanItemStatus.verified,
            ),
          );
        },
      ),
    );
  }
}
