import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/theme/tokens/app_colors.dart';
import '../../../app/theme/tokens/app_shapes.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading_state.dart';
import '../domain/quotation.dart';
import 'quotation_form_screen.dart';
import 'widgets/quotation_card.dart';

/// Interactive Arabic screen displaying all quotations, metrics summary, status filtering,
/// and management actions.
class QuotationsScreen extends ConsumerWidget {
  const QuotationsScreen({super.key});

  void _openCreateQuotation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const QuotationFormScreen()),
    );
  }

  void _openEditQuotation(BuildContext context, Quotation quotation) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuotationFormScreen(existingQuotation: quotation),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quotationsControllerProvider);
    final controller = ref.read(quotationsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('عروض الأسعار'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: () {
              controller.loadMetrics();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateQuotation(context),
        icon: const Icon(Icons.add),
        label: const Text('عرض سعر جديد'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Metrics Summary Bar
            if (state.metrics != null)
              _MetricsSummaryBar(metrics: state.metrics!),

            // Filter Chips Bar
            _FilterChipsBar(
              selectedFilter: state.statusFilter,
              onFilterSelected: controller.setStatusFilter,
            ),

            const SizedBox(height: AppSpacing.xs),

            // Content: Loading, Error, Empty, or List
            Expanded(
              child: state.isLoading && state.quotations.isEmpty
                  ? const Center(
                      child: AppLoadingState(
                        message: 'جاري تحميل عروض الأسعار...',
                      ),
                    )
                  : state.quotations.isEmpty
                  ? AppEmptyState(
                      title: state.statusFilter == null
                          ? 'لا توجد أي عروض أسعار حتى الآن'
                          : 'لا توجد عروض أسعار بهذه الحالة',
                      message: state.statusFilter == null
                          ? 'ابدأ بإنشاء عرض سعر جديد للعميل مع حساب فوري وتلقائي'
                          : 'جرب اختيار تصنيف آخر أو إنشاء عرض سعر جديد',
                      actionLabel: 'إنشاء عرض سعر جديد',
                      onAction: () => _openCreateQuotation(context),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: state.quotations.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final quotation = state.quotations[index];
                        return QuotationCard(
                          quotation: quotation,
                          onTap: () {
                            if (!quotation.isLocked) {
                              _openEditQuotation(context, quotation);
                            }
                          },
                          onEdit: () => _openEditQuotation(context, quotation),
                          onDuplicate: () async {
                            final dup = await controller.duplicateQuotation(
                              quotation.id,
                            );
                            if (dup != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم نسخ عرض السعر كمسودة جديدة (${dup.referenceNumber})',
                                  ),
                                ),
                              );
                            }
                          },
                          onStatusChanged: (newStatus) async {
                            final ok = await controller.updateStatus(
                              quotation.id,
                              newStatus,
                            );
                            if (ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم تغيير الحالة إلى "${newStatus.arabicLabel}"',
                                  ),
                                ),
                              );
                            }
                          },
                          onConvertToInvoice: () async {
                            try {
                              final inv = await ref
                                  .read(invoiceRepositoryProvider)
                                  .convertQuotationToInvoice(quotation.id);
                              await controller.loadMetrics();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم تحويل عرض السعر إلى فاتورة مبيعات (${inv.referenceNumber}) بنجاح',
                                    ),
                                    backgroundColor: Colors.purple.shade800,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تعذر تحويل عرض السعر: $e'),
                                    backgroundColor: Colors.red.shade800,
                                  ),
                                );
                              }
                            }
                          },
                          onDelete: () {
                            showDialog<void>(
                              context: context,
                              builder: (dialogCtx) => AppConfirmationDialog(
                                title: 'تأكيد حذف عرض السعر',
                                message:
                                    'هل أنت متأكد من رغبتك في حذف عرض السعر "${quotation.referenceNumber}" للعميل "${quotation.customerName}"؟',
                                confirmLabel: 'حذف نهائي',
                                cancelLabel: 'إلغاء',
                                isDestructive: true,
                                onConfirm: () async {
                                  final ok = await controller.deleteQuotation(
                                    quotation.id,
                                  );
                                  if (ok && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم حذف عرض السعر بنجاح'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsSummaryBar extends StatelessWidget {
  const _MetricsSummaryBar({required this.metrics});

  final QuotationMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppShapes.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricItem(
            label: 'إجمالي العروض',
            value: '${metrics.totalCount}',
            color: isDark ? Colors.blue[300]! : Colors.blue[800]!,
          ),
          _MetricDivider(),
          _MetricItem(
            label: 'المسودات',
            value: '${metrics.draftsCount}',
            color: isDark ? Colors.grey[300]! : Colors.grey[700]!,
          ),
          _MetricDivider(),
          _MetricItem(
            label: 'المقبولة',
            value: '${metrics.acceptedCount}',
            extra: '${metrics.formattedAcceptedTotalEgp} ج.م',
            color: isDark ? Colors.green[300]! : Colors.green[800]!,
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    this.extra,
    required this.color,
  });

  final String label;
  final String value;
  final String? extra;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (extra != null) ...[
          const SizedBox(height: 1),
          Text(
            extra!,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
    );
  }
}

class _FilterChipsBar extends StatelessWidget {
  const _FilterChipsBar({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final QuotationStatus? selectedFilter;
  final ValueChanged<QuotationStatus?> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('الكل'),
            selected: selectedFilter == null,
            onSelected: (_) => onFilterSelected(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          ChoiceChip(
            label: Text(QuotationStatus.draft.arabicLabel),
            selected: selectedFilter == QuotationStatus.draft,
            onSelected: (_) => onFilterSelected(QuotationStatus.draft),
          ),
          const SizedBox(width: AppSpacing.xs),
          ChoiceChip(
            label: Text(QuotationStatus.sent.arabicLabel),
            selected: selectedFilter == QuotationStatus.sent,
            onSelected: (_) => onFilterSelected(QuotationStatus.sent),
          ),
          const SizedBox(width: AppSpacing.xs),
          ChoiceChip(
            label: Text(QuotationStatus.accepted.arabicLabel),
            selected: selectedFilter == QuotationStatus.accepted,
            onSelected: (_) => onFilterSelected(QuotationStatus.accepted),
          ),
          const SizedBox(width: AppSpacing.xs),
          ChoiceChip(
            label: Text(QuotationStatus.rejected.arabicLabel),
            selected: selectedFilter == QuotationStatus.rejected,
            onSelected: (_) => onFilterSelected(QuotationStatus.rejected),
          ),
        ],
      ),
    );
  }
}
