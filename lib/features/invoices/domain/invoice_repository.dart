/// Contract for persistent sales invoice storage, payment tracking, and quotation conversion.
/// Pure Dart: zero framework or ORM dependencies.
library;

import 'invoice.dart';

abstract class InvoiceRepository {
  /// Streams all invoices ordered by issue date desc, with optional status filter.
  Stream<List<Invoice>> watchInvoices({InvoiceStatus? statusFilter});

  /// Retrieves an invoice by internal ID including line items and payment transactions.
  Future<Invoice?> getInvoiceById(int id);

  /// Retrieves an invoice by reference number (e.g. "INV-2026-0001").
  Future<Invoice?> getInvoiceByReference(String referenceNumber);

  /// Generates the next sequential invoice reference for the current year.
  Future<String> generateNextReferenceNumber();

  /// Persists a new sales invoice transactionally.
  Future<Invoice> createInvoice({
    required String customerName,
    String? customerPhone,
    DateTime? issueDate,
    DateTime? dueDate,
    String? notes,
    int discountPiastres = 0,
    int taxPiastres = 0,
    required List<InvoiceItemDraft> items,
  });

  /// Converts an accepted quotation into an invoice, copying snapshot items.
  /// Automatically transitions quotation status to convertedToInvoice.
  Future<Invoice> convertQuotationToInvoice(int quotationId);

  /// Records a payment installment against an invoice, updating paid amount and status.
  Future<Invoice> recordPayment({
    required int invoiceId,
    required int amountPiastres,
    required PaymentMethod paymentMethod,
    DateTime? paymentDate,
    String? notes,
  });

  /// Cancels an invoice.
  Future<void> cancelInvoice(int id);

  /// Deletes an invoice and cascades to its items and payments.
  Future<void> deleteInvoice(int id);

  /// Retrieves aggregated summary metrics for the invoices dashboard.
  Future<InvoiceMetrics> getMetrics();
}
