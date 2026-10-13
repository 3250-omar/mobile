import 'quotation.dart';

/// Contract for persistent quotation storage and lifecycle management.
/// Pure Dart: zero framework or ORM dependencies.
abstract class QuotationRepository {
  /// Streams all quotations ordered by issue date desc, with optional status filter.
  Stream<List<Quotation>> watchQuotations({QuotationStatus? statusFilter});

  /// Retrieves a specific quotation with its line items.
  Future<Quotation?> getQuotationById(int id);

  /// Retrieves a specific quotation by its reference number (e.g. "QT-2026-0001").
  Future<Quotation?> getQuotationByReference(String referenceNumber);

  /// Generates the next sequential quotation reference for the current year.
  Future<String> generateNextReferenceNumber();

  /// Persists a new quotation and its line items transactionally.
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

  /// Transitions quotation lifecycle status (e.g. draft -> sent -> accepted).
  Future<void> updateStatus(int id, QuotationStatus status);

  /// Deletes a quotation and cascades to its line items.
  Future<void> deleteQuotation(int id);

  /// Duplicates an existing quotation into a new draft with fresh reference number.
  Future<Quotation> duplicateQuotation(int id);

  /// Retrieves aggregated summary metrics for the quotations dashboard.
  Future<QuotationMetrics> getMetrics();
}
