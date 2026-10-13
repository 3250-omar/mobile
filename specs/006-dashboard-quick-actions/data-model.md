# Data Model: Dashboard & Quick Actions

## Domain Entities

### 1. `DashboardMetrics`
Immutable domain value object encapsulating high-level operational statistics:

```dart
class DashboardMetrics {
  final int totalProductsCount;
  final int totalQuotationsCount;
  final int activeQuotationsValuePiastres;
  final int totalInvoicesCount;
  final int unpaidReceivablesPiastres;
  final int collectedRevenuePiastres;

  const DashboardMetrics({
    this.totalProductsCount = 0,
    this.totalQuotationsCount = 0,
    this.activeQuotationsValuePiastres = 0,
    this.totalInvoicesCount = 0,
    this.unpaidReceivablesPiastres = 0,
    this.collectedRevenuePiastres = 0,
  });
}
```

- **Validation Rules**:
  - All count fields must be $\ge 0$.
  - All currency piastre amounts must be $\ge 0$.
  - Pure Dart domain entity with zero dependencies on Flutter or Drift.

---

### 2. `RecentActivityItem`
Unified domain representation of a recently modified quotation or invoice:

```dart
enum ActivityType {
  quotation,
  invoice,
}

class RecentActivityItem {
  final int id;
  final ActivityType type;
  final String referenceNumber;
  final String customerName;
  final int amountPiastres;
  final String status;
  final DateTime updatedAt;

  const RecentActivityItem({
    required this.id,
    required this.type,
    required this.referenceNumber,
    required this.customerName,
    required this.amountPiastres,
    required this.status,
    required this.updatedAt,
  });
}
```

- **Validation Rules**:
  - `amountPiastres` must be $\ge 0$.
  - `referenceNumber` must not be blank.

---

### 3. `DashboardState`
Immutable application state managed by `DashboardController`:

```dart
class DashboardState {
  final bool isLoading;
  final DashboardMetrics metrics;
  final List<RecentActivityItem> recentActivities;
  final AppFailure? failure;

  const DashboardState({
    this.isLoading = false,
    this.metrics = const DashboardMetrics(),
    this.recentActivities = const [],
    this.failure,
  });
}
```

---

## Repository Contract

```dart
abstract class DashboardRepository {
  Future<DashboardMetrics> getMetrics();
  Stream<DashboardMetrics> watchMetrics();
  Future<List<RecentActivityItem>> getRecentActivities({int limit = 5});
  Stream<List<RecentActivityItem>> watchRecentActivities({int limit = 5});
}
```
