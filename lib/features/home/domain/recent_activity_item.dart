/// Pure Dart domain entity representing recent commercial activities.
/// Zero dependencies on Flutter, Drift, or external packages.
library;

enum ActivityType {
  quotation('عرض سعر'),
  invoice('فاتورة مبيعات');

  const ActivityType(this.arabicLabel);
  final String arabicLabel;
}

class RecentActivityItem {
  const RecentActivityItem({
    required this.id,
    required this.type,
    required this.referenceNumber,
    required this.customerName,
    required this.amountPiastres,
    required this.status,
    required this.updatedAt,
  });

  final int id;
  final ActivityType type;
  final String referenceNumber;
  final String customerName;
  final int amountPiastres;
  final String status;
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentActivityItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          referenceNumber == other.referenceNumber &&
          customerName == other.customerName &&
          amountPiastres == other.amountPiastres &&
          status == other.status &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    type,
    referenceNumber,
    customerName,
    amountPiastres,
    status,
    updatedAt,
  );
}
