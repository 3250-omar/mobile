import 'package:offline_quotes/features/home/domain/dashboard_metrics.dart';
import 'package:offline_quotes/features/home/domain/dashboard_repository.dart';
import 'package:offline_quotes/features/home/domain/recent_activity_item.dart';

/// Test double for [DashboardRepository] that emits in-memory static or configurable values.
class FakeDashboardRepository implements DashboardRepository {
  FakeDashboardRepository({
    this.metrics = const DashboardMetrics(
      totalProductsCount: 100,
      totalQuotationsCount: 5,
      activeQuotationsValuePiastres: 5000000,
      totalInvoicesCount: 4,
      unpaidReceivablesPiastres: 2000000,
      collectedRevenuePiastres: 3000000,
    ),
    this.activities = const [],
  });

  DashboardMetrics metrics;
  List<RecentActivityItem> activities;

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
