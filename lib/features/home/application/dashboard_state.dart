import '../../../core/errors/app_failure.dart';
import '../domain/dashboard_metrics.dart';
import '../domain/recent_activity_item.dart';

/// Immutable state for the Home Dashboard.
class DashboardState {
  const DashboardState({
    this.isLoading = false,
    this.metrics = const DashboardMetrics(),
    this.recentActivities = const [],
    this.failure,
  });

  final bool isLoading;
  final DashboardMetrics metrics;
  final List<RecentActivityItem> recentActivities;
  final AppFailure? failure;

  DashboardState copyWith({
    bool? isLoading,
    DashboardMetrics? metrics,
    List<RecentActivityItem>? recentActivities,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      metrics: metrics ?? this.metrics,
      recentActivities: recentActivities ?? this.recentActivities,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          metrics == other.metrics &&
          failure == other.failure &&
          _listEquals(recentActivities, other.recentActivities);

  @override
  int get hashCode => Object.hash(
    isLoading,
    metrics,
    failure,
    Object.hashAll(recentActivities),
  );

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
