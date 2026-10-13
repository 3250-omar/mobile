/// Pure Dart repository contract for dashboard operational metrics and activities.
/// Zero dependencies on Flutter, Drift, or external packages.
library;

import 'dashboard_metrics.dart';
import 'recent_activity_item.dart';

abstract class DashboardRepository {
  /// Fetches an instantaneous snapshot of business metrics.
  Future<DashboardMetrics> getMetrics();

  /// Observes business metrics, emitting updates when underlying data changes.
  Stream<DashboardMetrics> watchMetrics();

  /// Fetches up to [limit] most recently updated quotations and invoices.
  Future<List<RecentActivityItem>> getRecentActivities({int limit = 5});

  /// Observes up to [limit] most recently updated quotations and invoices.
  Stream<List<RecentActivityItem>> watchRecentActivities({int limit = 5});
}
