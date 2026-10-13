import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/theme/tokens/app_shapes.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading_state.dart';
import '../domain/invoice.dart';
import 'invoice_form_screen.dart';
import 'widgets/invoice_card.dart';
import 'widgets/record_payment_dialog.dart';

/// Interactive Arabic screen displaying all sales invoices, financial metrics summary,
/// status filtering, payment recording, and offline PDF printing.
class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  void _openCreateInvoice(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const InvoiceFormScreen()));
  }

  Future<void> _recordPayment(
    BuildContext context,
    WidgetRef ref,
    Invoice invoice,
  ) async {
    final controller = ref.read(invoicesControllerProvider.notifier);
    await showDialog<bool>(
      context: context,
      builder: (ctx) => RecordPaymentDialog(
        invoice: invoice,
        onRecordPayment:
            ({
              required int amountPiastres,
              required PaymentMethod paymentMethod,
              DateTime? paymentDate,
              String? notes,
            }) async {
              final res = await controller.recordPayment(
                invoiceId: invoice.id,
                amountPiastres: amountPiastres,
                paymentMethod: paymentMethod,
                paymentDate: paymentDate,
                notes: notes,
              );
              if (res != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم تسجيل دفعة بقيمة ${(amountPiastres / 100).toStringAsFixed(2)} ج.م بنجاح',
                    ),
                    backgroundColor: Colors.green.shade800,
                  ),
                );
              }
            },
      ),
    );
  }

  Future<void> _printPdf(
    BuildContext context,
    WidgetRef ref,
    Invoice invoice, {
    required bool isThermalReceipt,
  }) async {
    try {
      final generator = ref.read(pdfInvoiceGeneratorProvider);
      final bytes = await generator.generateInvoicePdf(
        invoice: invoice,
        isThermalReceipt: isThermalReceipt,
      );
      await Printing.layoutPdf(
        onLayout: (_) => bytes,
        name: isThermalReceipt
            ? 'Receipt-${invoice.referenceNumber}.pdf'
            : 'Invoice-${invoice.referenceNumber}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر إنشاء ملف الطباعة: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoicesControllerProvider);
    final controller = ref.read(invoicesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الفواتير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: () => controller.loadMetrics(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateInvoice(context),
        icon: const Icon(Icons.add),
        label: const Text('فاتورة جديدة'),
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

            // Content: Loading, Empty, or List
            Expanded(
              child: state.isLoading && state.invoices.isEmpty
                  ? const Center(
                      child: AppLoadingState(message: 'جاري تحميل الفواتير...'),
                    )
                  : state.invoices.isEmpty
                  ? AppEmptyState(
                      title: state.statusFilter == null
                          ? 'لا توجد فواتير مبيعات مسجلة'
                          : 'لا توجد فواتير بهذه الحالة',
                      message: state.statusFilter == null
                          ? 'ابدأ بإنشاء فاتورة جديدة أو تحويل أحد عروض الأسعار المقبولة'
                          : 'جرب اختيار تصنيف آخر أو إنشاء فاتورة جديدة',
                      actionLabel: 'إنشاء فاتورة جديدة',
                      onAction: () => _openCreateInvoice(context),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: state.invoices.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final invoice = state.invoices[index];
                        return InvoiceCard(
                          invoice: invoice,
                          onRecordPayment: () =>
                              _recordPayment(context, ref, invoice),
                          onPrintA4: () => _printPdf(
                            context,
                            ref,
                            invoice,
                            isThermalReceipt: false,
                          ),
                          onPrintReceipt: () => _printPdf(
                            context,
                            ref,
                            invoice,
                            isThermalReceipt: true,
                          ),
                          onCancel: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => AppConfirmationDialog(
                                title: 'تأكيد إلغاء الفاتورة',
                                message:
                                    'هل أنت متأكد من رغبتك في إلغاء الفاتورة ${invoice.referenceNumber}؟',
                                confirmLabel: 'إلغاء الفاتورة',
                                cancelLabel: 'رجوع',
                                isDestructive: true,
                                onConfirm: () =>
                                    controller.cancelInvoice(invoice.id),
                              ),
                            );
                          },
                          onDelete: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => AppConfirmationDialog(
                                title: 'تأكيد حذف الفاتورة',
                                message:
                                    'هل أنت متأكد من رغبتك في حذف الفاتورة ${invoice.referenceNumber} نهائياً مع كافة بنودها ودفعاتها؟',
                                confirmLabel: 'حذف نهائي',
                                cancelLabel: 'إلغاء',
                                isDestructive: true,
                                onConfirm: () =>
                                    controller.deleteInvoice(invoice.id),
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

  final InvoiceMetrics metrics;

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
        color: isDark
            ? theme.colorScheme.surfaceContainerHigh
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppShapes.roundedMd,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricItem(
            label: 'الفواتير',
            value: '${metrics.totalCount}',
            color: theme.colorScheme.onSurface,
          ),
          _MetricDivider(),
          _MetricItem(
            label: 'المستحقات',
            value: '${metrics.formattedTotalReceivablesEgp} ج.م',
            color: metrics.totalReceivablesPiastres > 0
                ? (isDark ? Colors.red[300] : Colors.red[800])
                : (isDark ? Colors.green[300] : Colors.green[800]),
          ),
          _MetricDivider(),
          _MetricItem(
            label: 'المحصل',
            value: '${metrics.formattedTotalPaidEgp} ج.م',
            color: isDark ? Colors.green[300] : Colors.green[800],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant
          .withValues(alpha: 0.5),
    );
  }
}

class _FilterChipsBar extends StatelessWidget {
  const _FilterChipsBar({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final InvoiceStatus? selectedFilter;
  final ValueChanged<InvoiceStatus?> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          FilterChip(
            label: const Text('الكل'),
            selected: selectedFilter == null,
            onSelected: (_) => onFilterSelected(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(
            label: const Text('غير مسدد'),
            selected: selectedFilter == InvoiceStatus.unpaid,
            onSelected: (_) => onFilterSelected(
              selectedFilter == InvoiceStatus.unpaid
                  ? null
                  : InvoiceStatus.unpaid,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(
            label: const Text('مسدد جزئياً'),
            selected: selectedFilter == InvoiceStatus.partiallyPaid,
            onSelected: (_) => onFilterSelected(
              selectedFilter == InvoiceStatus.partiallyPaid
                  ? null
                  : InvoiceStatus.partiallyPaid,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(
            label: const Text('مسدد بالكامل'),
            selected: selectedFilter == InvoiceStatus.paid,
            onSelected: (_) => onFilterSelected(
              selectedFilter == InvoiceStatus.paid ? null : InvoiceStatus.paid,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(
            label: const Text('ملغي'),
            selected: selectedFilter == InvoiceStatus.cancelled,
            onSelected: (_) => onFilterSelected(
              selectedFilter == InvoiceStatus.cancelled
                  ? null
                  : InvoiceStatus.cancelled,
            ),
          ),
        ],
      ),
    );
  }
}
