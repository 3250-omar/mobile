import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/navigation/route_names.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/recent_activity_item.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/metric_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/recent_activity_tile.dart';

/// Interactive 100% offline Arabic business dashboard.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _formatCurrency(int piastres) {
    final pounds = piastres ~/ 100;
    final rem = (piastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$rem ج.م';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(dashboardControllerProvider);
    final metrics = state.metrics;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RouteNames.settingsPath),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardControllerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Shop Header & Offline Badge
                const DashboardHeader(),
                const SizedBox(height: 20),

                // 2. Metrics Section Header
                Text(
                  'نظرة عامة على النشاط',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Metrics 2x2 Grid
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: l10n.dashboardCatalogItems,
                        value: '${metrics.totalProductsCount}',
                        unit: 'صنف',
                        icon: Icons.inventory_2_outlined,
                        iconColor: theme.colorScheme.primary,
                        onTap: () => context.go(RouteNames.productsPath),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricCard(
                        title: l10n.dashboardActiveQuotations,
                        value: _formatCurrency(
                          metrics.activeQuotationsValuePiastres,
                        ),
                        unit: '${metrics.totalQuotationsCount} عرض',
                        icon: Icons.request_quote_outlined,
                        iconColor: Colors.teal.shade700,
                        onTap: () => context.go(RouteNames.quotationsPath),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: l10n.dashboardUnpaidReceivables,
                        value: _formatCurrency(
                          metrics.unpaidReceivablesPiastres,
                        ),
                        icon: Icons.pending_actions_outlined,
                        iconColor: Colors.orange.shade800,
                        onTap: () => context.go(RouteNames.invoicesPath),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricCard(
                        title: l10n.dashboardCollectedRevenue,
                        value: _formatCurrency(
                          metrics.collectedRevenuePiastres,
                        ),
                        icon: Icons.payments_outlined,
                        iconColor: Colors.green.shade700,
                        onTap: () => context.go(RouteNames.invoicesPath),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Quick Actions Section
                Text(
                  l10n.dashboardQuickActions,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      QuickActionButton(
                        label: l10n.dashboardActionScan,
                        icon: Icons.document_scanner_outlined,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        onTap: () => context.push(RouteNames.scanPath),
                      ),
                      const SizedBox(width: 10),
                      QuickActionButton(
                        label: l10n.dashboardActionNewQuotation,
                        icon: Icons.add_chart_outlined,
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        foregroundColor: theme.colorScheme.onSecondaryContainer,
                        onTap: () => context.push(RouteNames.quotationNewPath),
                      ),
                      const SizedBox(width: 10),
                      QuickActionButton(
                        label: l10n.dashboardActionNewInvoice,
                        icon: Icons.receipt_long_outlined,
                        backgroundColor: theme.colorScheme.tertiaryContainer,
                        foregroundColor: theme.colorScheme.onTertiaryContainer,
                        onTap: () => context.push(RouteNames.invoiceNewPath),
                      ),
                      const SizedBox(width: 10),
                      QuickActionButton(
                        label: l10n.dashboardActionCatalog,
                        icon: Icons.format_list_bulleted_outlined,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        onTap: () => context.go(RouteNames.productsPath),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Recent Activity Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.dashboardRecentActivity,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (state.recentActivities.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history_outlined,
                          size: 40,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.dashboardRecentEmpty,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...state.recentActivities.map(
                    (item) => RecentActivityTile(
                      item: item,
                      onTap: () {
                        if (item.type == ActivityType.quotation) {
                          context.go(RouteNames.quotationsPath);
                        } else {
                          context.go(RouteNames.invoicesPath);
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
