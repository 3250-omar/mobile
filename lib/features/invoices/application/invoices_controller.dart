import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/invoice.dart';
import '../domain/invoice_repository.dart';

/// State of the invoices list screen.
class InvoicesState {
  const InvoicesState({
    this.invoices = const [],
    this.statusFilter,
    this.metrics,
    this.isLoading = false,
    this.error,
  });

  final List<Invoice> invoices;
  final InvoiceStatus? statusFilter;
  final InvoiceMetrics? metrics;
  final bool isLoading;
  final AppFailure? error;

  InvoicesState copyWith({
    List<Invoice>? invoices,
    InvoiceStatus? statusFilter,
    bool clearFilter = false,
    InvoiceMetrics? metrics,
    bool? isLoading,
    AppFailure? error,
    bool clearError = false,
  }) {
    return InvoicesState(
      invoices: invoices ?? this.invoices,
      statusFilter: clearFilter ? null : (statusFilter ?? this.statusFilter),
      metrics: metrics ?? this.metrics,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller managing invoices list streaming, status filtering, and metrics.
class InvoicesController extends StateNotifier<InvoicesState> {
  InvoicesController(this._repository) : super(const InvoicesState()) {
    _init();
  }

  final InvoiceRepository _repository;
  StreamSubscription<List<Invoice>>? _subscription;

  void _init() {
    _listenToInvoices();
    loadMetrics();
  }

  void _listenToInvoices() {
    _subscription?.cancel();
    state = state.copyWith(isLoading: true, clearError: true);

    _subscription = _repository
        .watchInvoices(statusFilter: state.statusFilter)
        .listen(
          (invoices) {
            state = state.copyWith(
              invoices: invoices,
              isLoading: false,
              clearError: true,
            );
          },
          onError: (Object error) {
            state = state.copyWith(
              isLoading: false,
              error: AppFailure(
                code: 'INVOICES_LOAD_FAILED',
                messageKey: 'تعذر تحميل الفواتير: $error',
                category: AppFailureCategory.storage,
                retryable: true,
              ),
            );
          },
        );
  }

  /// Sets the active status filter (null for all).
  void setStatusFilter(InvoiceStatus? filter) {
    if (state.statusFilter == filter) return;
    state = state.copyWith(statusFilter: filter, clearFilter: filter == null);
    _listenToInvoices();
  }

  /// Loads aggregated shop summary metrics.
  Future<void> loadMetrics() async {
    try {
      final metrics = await _repository.getMetrics();
      state = state.copyWith(metrics: metrics);
    } catch (_) {
      // Non-fatal metrics failure
    }
  }

  /// Cancels an invoice and refreshes metrics.
  Future<bool> cancelInvoice(int id) async {
    try {
      await _repository.cancelInvoice(id);
      await loadMetrics();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'CANCEL_INVOICE_FAILED',
          messageKey: 'تعذر إلغاء الفاتورة: $e',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
      return false;
    }
  }

  /// Deletes an invoice and updates metrics.
  Future<bool> deleteInvoice(int id) async {
    try {
      await _repository.deleteInvoice(id);
      await loadMetrics();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'DELETE_INVOICE_FAILED',
          messageKey: 'تعذر حذف الفاتورة: $e',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
      return false;
    }
  }

  /// Records a payment installment for an invoice.
  Future<Invoice?> recordPayment({
    required int invoiceId,
    required int amountPiastres,
    required PaymentMethod paymentMethod,
    DateTime? paymentDate,
    String? notes,
  }) async {
    try {
      final updated = await _repository.recordPayment(
        invoiceId: invoiceId,
        amountPiastres: amountPiastres,
        paymentMethod: paymentMethod,
        paymentDate: paymentDate,
        notes: notes,
      );
      await loadMetrics();
      return updated;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'RECORD_PAYMENT_FAILED',
          messageKey: 'تعذر تسجيل الدفعة: $e',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
      return null;
    }
  }

  /// Converts an accepted quotation into an invoice.
  Future<Invoice?> convertQuotationToInvoice(int quotationId) async {
    try {
      final invoice = await _repository.convertQuotationToInvoice(quotationId);
      await loadMetrics();
      return invoice;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'CONVERT_QUOTATION_FAILED',
          messageKey: 'تعذر تحويل عرض السعر إلى فاتورة: $e',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
      return null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
