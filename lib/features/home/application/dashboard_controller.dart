import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/dashboard_metrics.dart';
import '../domain/dashboard_repository.dart';
import '../domain/recent_activity_item.dart';
import 'dashboard_state.dart';

/// StateNotifier managing the live operational dashboard state.
class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._repository)
    : super(const DashboardState(isLoading: true)) {
    _init();
  }

  final DashboardRepository _repository;
  StreamSubscription<DashboardMetrics>? _metricsSubscription;
  StreamSubscription<List<RecentActivityItem>>? _activitiesSubscription;

  void _init() {
    _subscribeToStreams();
  }

  void _subscribeToStreams() {
    state = state.copyWith(isLoading: true, clearFailure: true);

    _metricsSubscription?.cancel();
    _metricsSubscription = _repository.watchMetrics().listen(
      (metrics) {
        state = state.copyWith(
          metrics: metrics,
          isLoading: false,
          clearFailure: true,
        );
      },
      onError: (Object error) {
        final failure = error is AppFailure
            ? error
            : AppFailure(
                code: 'DASHBOARD_METRICS_ERROR',
                messageKey: 'errorGeneric',
                category: AppFailureCategory.storage,
                retryable: true,
                causeForLogs: error.toString(),
              );
        state = state.copyWith(isLoading: false, failure: failure);
      },
    );

    _activitiesSubscription?.cancel();
    _activitiesSubscription = _repository
        .watchRecentActivities(limit: 5)
        .listen(
          (activities) {
            state = state.copyWith(
              recentActivities: activities,
              isLoading: false,
            );
          },
          onError: (Object error) {
            // Log or handle activity failure gracefully
          },
        );
  }

  /// Manually re-fetches dashboard metrics and activities.
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    try {
      final metrics = await _repository.getMetrics();
      final activities = await _repository.getRecentActivities(limit: 5);
      state = state.copyWith(
        metrics: metrics,
        recentActivities: activities,
        isLoading: false,
        clearFailure: true,
      );
    } catch (e) {
      final failure = e is AppFailure
          ? e
          : AppFailure(
              code: 'DASHBOARD_REFRESH_ERROR',
              messageKey: 'errorGeneric',
              category: AppFailureCategory.storage,
              retryable: true,
              causeForLogs: e.toString(),
            );
      state = state.copyWith(isLoading: false, failure: failure);
    }
  }

  @override
  void dispose() {
    _metricsSubscription?.cancel();
    _activitiesSubscription?.cancel();
    super.dispose();
  }
}
