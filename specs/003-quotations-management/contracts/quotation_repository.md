# Contract: QuotationRepository

```dart
abstract class QuotationRepository {
  /// Watches all quotations with optional status filter.
  Stream<List<Quotation>> watchQuotations({QuotationStatus? statusFilter});

  /// Retrieves a specific quotation with its line items.
  Future<Quotation?> getQuotationById(int id);

  /// Retrieves a specific quotation by its human-readable reference number.
  Future<Quotation?> getQuotationByReference(String referenceNumber);

  /// Generates the next sequential quotation reference for the current year (e.g. "QT-2026-0001").
  Future<String> generateNextReferenceNumber();

  /// Creates a new quotation and its line items transactionally.
  Future<Quotation> createQuotation({
    required String customerName,
    String? customerPhone,
    QuotationStatus status = QuotationStatus.draft,
    DateTime? issueDate,
    DateTime? validUntil,
    String? notes,
    int discountPiastres = 0,
    int taxPiastres = 0,
    required List<QuotationItemDraft> items,
  });

  /// Updates an existing draft quotation and replaces its line items transactionally.
  Future<Quotation> updateQuotation({
    required int id,
    required String customerName,
    String? customerPhone,
    DateTime? issueDate,
    DateTime? validUntil,
    String? notes,
    int discountPiastres = 0,
    int taxPiastres = 0,
    required List<QuotationItemDraft> items,
  });

  /// Updates the status of a quotation (e.g. draft -> sent -> accepted).
  Future<void> updateStatus(int id, QuotationStatus status);

  /// Deletes a quotation and cascades to its line items.
  Future<void> deleteQuotation(int id);

  /// Duplicates an existing quotation into a new draft with fresh reference number.
  Future<Quotation> duplicateQuotation(int id);

  /// Returns total counts and metrics (total count, active drafts count, accepted total sum).
  Future<QuotationMetrics> getMetrics();
}
```
