import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/home/application/dashboard_controller.dart';
import 'package:offline_quotes/features/home/domain/dashboard_metrics.dart';
import 'package:offline_quotes/features/home/domain/dashboard_repository.dart';
import 'package:offline_quotes/features/home/domain/recent_activity_item.dart';

class FakeDashboardRepository implements DashboardRepository {
  FakeDashboardRepository({
    this.metrics = const DashboardMetrics(totalProductsCount: 10),
    this.activities = const [],
  });

  DashboardMetrics metrics;
  List<RecentActivityItem> activities;

  final StreamController<DashboardMetrics> _metricsController =
      StreamController<DashboardMetrics>.broadcast();
  final StreamController<List<RecentActivityItem>> _activitiesController =
      StreamController<List<RecentActivityItem>>.broadcast();

  @override
  Future<DashboardMetrics> getMetrics() async => metrics;

  @override
  Stream<DashboardMetrics> watchMetrics() async* {
    yield metrics;
    yield* _metricsController.stream;
  }

  @override
  Future<List<RecentActivityItem>> getRecentActivities({int limit = 5}) async =>
      activities;

  @override
  Stream<List<RecentActivityItem>> watchRecentActivities({
    int limit = 5,
  }) async* {
    yield activities;
    yield* _activitiesController.stream;
  }

  void emitMetrics(DashboardMetrics newMetrics) {
    metrics = newMetrics;
    _metricsController.add(newMetrics);
  }

  void emitActivities(List<RecentActivityItem> newActivities) {
    activities = newActivities;
    _activitiesController.add(newActivities);
  }

  void dispose() {
    _metricsController.close();
    _activitiesController.close();
  }
}

void main() {
  group('DashboardController Tests', () {
    late FakeDashboardRepository repository;
    late DashboardController controller;

    setUp(() {
      repository = FakeDashboardRepository();
      controller = DashboardController(repository);
    });

    tearDown(() {
      controller.dispose();
      repository.dispose();
    });

    test('initializes and streams metrics and activities', () async {
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.isLoading, false);
      expect(controller.state.metrics.totalProductsCount, 10);
      expect(controller.state.recentActivities, isEmpty);
    });

    test('updates state when repository streams emit new data', () async {
      await Future<void>.delayed(Duration.zero);

      repository.emitMetrics(
        const DashboardMetrics(
          totalProductsCount: 25,
          totalQuotationsCount: 5,
          activeQuotationsValuePiastres: 50000,
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(controller.state.metrics.totalProductsCount, 25);
      expect(controller.state.metrics.totalQuotationsCount, 5);
      expect(controller.state.metrics.activeQuotationsValuePiastres, 50000);
    });

    test('refreshes metrics on manual refresh call', () async {
      repository.metrics = const DashboardMetrics(totalProductsCount: 42);

      await controller.refresh();

      expect(controller.state.isLoading, false);
      expect(controller.state.metrics.totalProductsCount, 42);
    });
  });
}
