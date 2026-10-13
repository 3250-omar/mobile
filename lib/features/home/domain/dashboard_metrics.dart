/// Pure Dart domain entity for aggregated business metrics.
/// Zero dependencies on Flutter, Drift, or external packages.
library;

class DashboardMetrics {
  const DashboardMetrics({
    this.totalProductsCount = 0,
    this.totalQuotationsCount = 0,
    this.activeQuotationsValuePiastres = 0,
    this.totalInvoicesCount = 0,
    this.unpaidReceivablesPiastres = 0,
    this.collectedRevenuePiastres = 0,
  });

  /// Total number of products currently in the catalog.
  final int totalProductsCount;

  /// Total count of all quotations.
  final int totalQuotationsCount;

  /// Grand total value (in piastres) of active (non-rejected) quotations.
  final int activeQuotationsValuePiastres;

  /// Total count of all invoices.
  final int totalInvoicesCount;

  /// Outstanding balance in piastres (grandTotal - paidAmount) for unpaid/partially paid invoices.
  final int unpaidReceivablesPiastres;

  /// Total collected cash in piastres across all invoices.
  final int collectedRevenuePiastres;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardMetrics &&
          runtimeType == other.runtimeType &&
          totalProductsCount == other.totalProductsCount &&
          totalQuotationsCount == other.totalQuotationsCount &&
          activeQuotationsValuePiastres ==
              other.activeQuotationsValuePiastres &&
          totalInvoicesCount == other.totalInvoicesCount &&
          unpaidReceivablesPiastres == other.unpaidReceivablesPiastres &&
          collectedRevenuePiastres == other.collectedRevenuePiastres;

  @override
  int get hashCode => Object.hash(
    totalProductsCount,
    totalQuotationsCount,
    activeQuotationsValuePiastres,
    totalInvoicesCount,
    unpaidReceivablesPiastres,
    collectedRevenuePiastres,
  );
}
