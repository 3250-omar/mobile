import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_shapes.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../domain/import_summary.dart';

/// Modal dialog presenting detailed metrics and error rows after an Excel import.
class ImportSummaryDialog extends StatelessWidget {
  const ImportSummaryDialog({
    super.key,
    required this.summary,
    required this.onDismiss,
  });

  final ImportSummary summary;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppShapes.roundedLg),
      title: Row(
        children: [
          Icon(
            summary.isCleanSuccess
                ? Icons.check_circle_outline
                : Icons.info_outline,
            color: summary.isCleanSuccess
                ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
                : (isDark ? AppColors.darkAction : AppColors.lightAction),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text('تقرير استيراد ملف الأصناف'),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Metric cards
              Row(
                children: [
                  Expanded(
                    child: _MetricBadge(
                      label: 'إجمالي الصفوف',
                      value: summary.totalRows.toString(),
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _MetricBadge(
                      label: 'أصناف جديدة',
                      value: summary.insertedCount.toString(),
                      color: isDark
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: _MetricBadge(
                      label: 'أصناف محدثة',
                      value: summary.updatedCount.toString(),
                      color: isDark
                          ? AppColors.darkAction
                          : AppColors.lightAction,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _MetricBadge(
                      label: 'صفوف مرفوضة',
                      value: summary.rejectedCount.toString(),
                      color: isDark
                          ? AppColors.darkError
                          : AppColors.lightError,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Duration text
              Text(
                'استغرق الاستيراد: ${summary.durationMs} مللي ثانية',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkMutedText
                      : AppColors.lightMutedText,
                ),
              ),

              // Errors list if any
              if (summary.errors.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'تفاصيل الصفوف المرفوضة (${summary.errors.length}):',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkError : AppColors.lightError,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                    borderRadius: AppShapes.roundedSm,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: summary.errors.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final err = summary.errors[index];
                      return Padding(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'صف ${err.rowNumber}: ${err.reason}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (err.rawCode != null || err.rawPrice != null)
                              Text(
                                'كود: "${err.rawCode ?? '-'}" | سعر: "${err.rawPrice ?? '-'}"',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkMutedText
                                      : AppColors.lightMutedText,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      actions: [
        AppButton(
          label: 'إغلاق',
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss();
          },
        ),
      ],
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppShapes.roundedSm,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
