# Contract: Dashboard Repository

`DashboardRepository` provides the abstraction for querying operational business metrics and recent activity streams from the local persistence layer.

## Interface Definition

```dart
abstract class DashboardRepository {
  /// Fetches an instantaneous snapshot of high-level business metrics.
  Future<DashboardMetrics> getMetrics();

  /// Observes business metrics, emitting updates whenever products, quotations,
  /// or invoices change.
  Stream<DashboardMetrics> watchMetrics();

  /// Fetches up to [limit] most recently modified quotations and invoices.
  Future<List<RecentActivityItem>> getRecentActivities({int limit = 5});

  /// Observes up to [limit] most recently modified quotations and invoices.
  Stream<List<RecentActivityItem>> watchRecentActivities({int limit = 5});
}
```

## Guarantees

1. **Deterministic Accuracy**: Values in `DashboardMetrics` must precisely reflect database counts and sums without approximation or truncation.
2. **100% Offline**: All operations are executed locally against SQLite. Zero outbound network calls are permitted.
3. **Resilience**: Empty tables return zero metrics and an empty activity list without throwing exceptions.
