import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/quotation.dart';
import '../domain/quotation_repository.dart';

/// State of the quotations list screen.
class QuotationsState {
  const QuotationsState({
    this.quotations = const [],
    this.statusFilter,
    this.metrics,
    this.isLoading = false,
    this.error,
  });

  final List<Quotation> quotations;
  final QuotationStatus? statusFilter;
  final QuotationMetrics? metrics;
  final bool isLoading;
  final AppFailure? error;

  QuotationsState copyWith({
    List<Quotation>? quotations,
    QuotationStatus? statusFilter,
    bool clearFilter = false,
    QuotationMetrics? metrics,
    bool? isLoading,
    AppFailure? error,
    bool clearError = false,
  }) {
    return QuotationsState(
      quotations: quotations ?? this.quotations,
      statusFilter: clearFilter ? null : (statusFilter ?? this.statusFilter),
      metrics: metrics ?? this.metrics,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller managing quotations list streaming, status filtering, and metrics.
class QuotationsController extends StateNotifier<QuotationsState> {
  QuotationsController(this._repository) : super(const QuotationsState()) {
    _init();
  }

  final QuotationRepository _repository;
  StreamSubscription<List<Quotation>>? _subscription;

  void _init() {
    _listenToQuotations();
    loadMetrics();
  }

  void _listenToQuotations() {
    _subscription?.cancel();
    state = state.copyWith(isLoading: true, clearError: true);

    _subscription = _repository
        .watchQuotations(statusFilter: state.statusFilter)
        .listen(
          (quotations) {
            state = state.copyWith(
              quotations: quotations,
              isLoading: false,
              clearError: true,
            );
          },
          onError: (Object error) {
            state = state.copyWith(
              isLoading: false,
              error: AppFailure(
                code: 'QUOTATIONS_LOAD_FAILED',
                messageKey: 'تعذر تحميل عروض الأسعار: $error',
                category: AppFailureCategory.storage,
                retryable: true,
              ),
            );
          },
        );
  }

  /// Sets the active status filter (null for all).
  void setStatusFilter(QuotationStatus? filter) {
    if (state.statusFilter == filter) return;
    state = state.copyWith(statusFilter: filter, clearFilter: filter == null);
    _listenToQuotations();
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

  /// Updates quotation status and refreshes metrics.
  Future<bool> updateStatus(int id, QuotationStatus newStatus) async {
    try {
      await _repository.updateStatus(id, newStatus);
      await loadMetrics();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'STATUS_UPDATE_FAILED',
          messageKey: 'تعذر تغيير حالة عرض السعر: $e',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
      return false;
    }
  }

  /// Deletes a quotation and updates metrics.
  Future<bool> deleteQuotation(int id) async {
    try {
      await _repository.deleteQuotation(id);
      await loadMetrics();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'DELETE_QUOTATION_FAILED',
          messageKey: 'تعذر حذف عرض السعر: $e',
          category: AppFailureCategory.storage,
          retryable: true,
        ),
      );
      return false;
    }
  }

  /// Duplicates an existing quotation into a new draft.
  Future<Quotation?> duplicateQuotation(int id) async {
    try {
      final dup = await _repository.duplicateQuotation(id);
      await loadMetrics();
      return dup;
    } catch (e) {
      state = state.copyWith(
        error: AppFailure(
          code: 'DUPLICATE_QUOTATION_FAILED',
          messageKey: 'تعذر نسخ عرض السعر: $e',
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
