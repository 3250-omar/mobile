import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/home/domain/dashboard_metrics.dart';
import 'package:offline_quotes/features/home/domain/dashboard_repository.dart';
import 'package:offline_quotes/features/home/domain/recent_activity_item.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/home/presentation/widgets/metric_card.dart';
import 'package:offline_quotes/features/home/presentation/widgets/quick_action_button.dart';
import 'package:offline_quotes/features/home/presentation/widgets/recent_activity_tile.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

class FakeDashboardRepo implements DashboardRepository {
  FakeDashboardRepo({
    this.metrics = const DashboardMetrics(
      totalProductsCount: 150,
      totalQuotationsCount: 4,
      activeQuotationsValuePiastres: 4500000, // 45,000.00 EGP
      totalInvoicesCount: 3,
      unpaidReceivablesPiastres: 2500000, // 25,000.00 EGP
      collectedRevenuePiastres: 1000000, // 10,000.00 EGP
    ),
    this.activities = const [],
  });

  final DashboardMetrics metrics;
  final List<RecentActivityItem> activities;

  @override
  Future<DashboardMetrics> getMetrics() async => metrics;

  @override
  Stream<DashboardMetrics> watchMetrics() => Stream.value(metrics);

  @override
  Future<List<RecentActivityItem>> getRecentActivities({int limit = 5}) async =>
      activities;

  @override
  Stream<List<RecentActivityItem>> watchRecentActivities({int limit = 5}) =>
      Stream.value(activities);
}

void main() {
  group('HomeScreen Dashboard Widget Tests', () {
    Widget buildTestScreen({
      DashboardMetrics? metrics,
      List<RecentActivityItem>? activities,
    }) {
      final repo = FakeDashboardRepo(
        metrics:
            metrics ??
            const DashboardMetrics(
              totalProductsCount: 150,
              totalQuotationsCount: 4,
              activeQuotationsValuePiastres: 4500000,
              totalInvoicesCount: 3,
              unpaidReceivablesPiastres: 2500000,
              collectedRevenuePiastres: 1000000,
            ),
        activities: activities ?? const [],
      );

      return ProviderScope(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('renders header, 4 metric cards, and 4 quick actions', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestScreen());
      await tester.pumpAndSettle();

      // Header checks
      expect(find.text('عروض الأسعار والفواتير'), findsOneWidget);
      expect(find.text('100% دون إنترنت'), findsOneWidget);

      // Metric cards
      expect(find.byType(MetricCard), findsNWidgets(4));
      expect(find.text('أصناف الكتالوج'), findsOneWidget);
      expect(find.text('عروض أسعار نشطة'), findsOneWidget);
      expect(find.text('مستحقات معلقة'), findsOneWidget);
      expect(find.text('إجمالي المحصل'), findsOneWidget);

      // Quick action buttons
      expect(find.byType(QuickActionButton), findsNWidgets(4));
      expect(find.text('مسح كشف طلبية'), findsOneWidget);
      expect(find.text('عرض سعر جديد'), findsOneWidget);
      expect(find.text('فاتورة جديدة'), findsOneWidget);
      expect(find.text('دليل الأصناف'), findsOneWidget);
    });

    testWidgets('displays empty state when there is no recent activity', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestScreen(activities: []));
      await tester.pumpAndSettle();

      expect(find.text('النشاط الأخير'), findsOneWidget);
      expect(find.text('لا توجد معاملات تجارية مسجلة بعد'), findsOneWidget);
      expect(find.byType(RecentActivityTile), findsNothing);
    });

    testWidgets('displays recent activities when available', (tester) async {
      final items = [
        RecentActivityItem(
          id: 1,
          type: ActivityType.quotation,
          referenceNumber: 'QT-2026-0001',
          customerName: 'المهندس مصطفى',
          amountPiastres: 45000, // 450.00 EGP
          status: 'accepted',
          updatedAt: DateTime(2026, 10, 14),
        ),
        RecentActivityItem(
          id: 10,
          type: ActivityType.invoice,
          referenceNumber: 'INV-2026-0001',
          customerName: 'شركة الإخوة',
          amountPiastres: 120000, // 1200.00 EGP
          status: 'unpaid',
          updatedAt: DateTime(2026, 10, 14),
        ),
      ];

      await tester.pumpWidget(buildTestScreen(activities: items));
      await tester.pumpAndSettle();

      expect(find.byType(RecentActivityTile), findsNWidgets(2));
      expect(find.text('المهندس مصطفى'), findsOneWidget);
      expect(find.text('شركة الإخوة'), findsOneWidget);
    });
  });
}
