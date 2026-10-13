import 'package:flutter_riverpod/legacy.dart';

import '../../quotations/domain/pricing_calculator.dart';
import '../domain/invoice.dart';
import '../domain/invoice_repository.dart';

/// State of the invoice creation form.
class InvoiceFormState {
  InvoiceFormState({
    this.customerName = '',
    this.customerPhone,
    this.notes,
    DateTime? issueDate,
    this.dueDate,
    this.discountPiastres = 0,
    this.taxPiastres = 0,
    this.items = const [],
    this.isSaving = false,
    this.errorMessage,
    this.savedInvoice,
  }) : issueDate = issueDate ?? DateTime.now();

  final String customerName;
  final String? customerPhone;
  final String? notes;
  final DateTime issueDate;
  final DateTime? dueDate;
  final int discountPiastres;
  final int taxPiastres;
  final List<InvoiceItemDraft> items;
  final bool isSaving;
  final String? errorMessage;
  final Invoice? savedInvoice;

  int get subtotalPiastres {
    const calc = PricingCalculator();
    return calc.calculateSubtotal(
      items.map((i) => i.lineTotalPiastres).toList(),
    );
  }

  int get grandTotalPiastres {
    const calc = PricingCalculator();
    return calc.calculateGrandTotal(
      subtotalPiastres: subtotalPiastres,
      discountPiastres: discountPiastres,
      taxPiastres: taxPiastres,
    );
  }

  String get formattedSubtotalEgp {
    final pounds = subtotalPiastres ~/ 100;
    final piastres = (subtotalPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedDiscountEgp {
    final pounds = discountPiastres ~/ 100;
    final piastres = (discountPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedTaxEgp {
    final pounds = taxPiastres ~/ 100;
    final piastres = (taxPiastres.abs() % 100).toString().padLeft(2, '0');
    return '$pounds.$piastres';
  }

  String get formattedGrandTotalEgp {
    final pounds = grandTotalPiastres ~/ 100;
    final piastres = (grandTotalPiastres.abs() % 100).toString().padLeft(
      2,
      '0',
    );
    return '$pounds.$piastres';
  }

  InvoiceFormState copyWith({
    String? customerName,
    String? customerPhone,
    String? notes,
    DateTime? issueDate,
    DateTime? dueDate,
    int? discountPiastres,
    int? taxPiastres,
    List<InvoiceItemDraft>? items,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    Invoice? savedInvoice,
  }) {
    return InvoiceFormState(
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      items: items ?? this.items,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedInvoice: savedInvoice ?? this.savedInvoice,
    );
  }
}

/// Controller managing invoice creation form fields, calculations, and persistence.
class InvoiceFormController extends StateNotifier<InvoiceFormState> {
  InvoiceFormController(
    this._repository, {
    List<InvoiceItemDraft>? initialItems,
  }) : super(InvoiceFormState(items: initialItems ?? const []));

  final InvoiceRepository _repository;

  void setCustomerName(String name) {
    state = state.copyWith(customerName: name, clearError: true);
  }

  void setCustomerPhone(String? phone) {
    state = state.copyWith(customerPhone: phone, clearError: true);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes, clearError: true);
  }

  void setIssueDate(DateTime date) {
    state = state.copyWith(issueDate: date, clearError: true);
  }

  void setDueDate(DateTime? date) {
    state = state.copyWith(dueDate: date, clearError: true);
  }

  void setDiscountPiastres(int discount) {
    state = state.copyWith(
      discountPiastres: discount < 0 ? 0 : discount,
      clearError: true,
    );
  }

  void setTaxPiastres(int tax) {
    state = state.copyWith(taxPiastres: tax < 0 ? 0 : tax, clearError: true);
  }

  void addItem(InvoiceItemDraft item) {
    final updated = List<InvoiceItemDraft>.from(state.items)..add(item);
    state = state.copyWith(items: updated, clearError: true);
  }

  void removeItem(int index) {
    if (index >= 0 && index < state.items.length) {
      final updated = List<InvoiceItemDraft>.from(state.items)..removeAt(index);
      state = state.copyWith(items: updated, clearError: true);
    }
  }

  void updateItem(int index, InvoiceItemDraft item) {
    if (index >= 0 && index < state.items.length) {
      final updated = List<InvoiceItemDraft>.from(state.items);
      updated[index] = item;
      state = state.copyWith(items: updated, clearError: true);
    }
  }

  /// Validates and saves the invoice.
  Future<Invoice?> saveInvoice() async {
    if (state.customerName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'اسم العميل مطلوب');
      return null;
    }
    if (state.items.isEmpty) {
      state = state.copyWith(errorMessage: 'يجب إضافة صنف واحد على الأقل');
      return null;
    }

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final invoice = await _repository.createInvoice(
        customerName: state.customerName.trim(),
        customerPhone: state.customerPhone?.trim(),
        issueDate: state.issueDate,
        dueDate: state.dueDate,
        notes: state.notes?.trim(),
        discountPiastres: state.discountPiastres,
        taxPiastres: state.taxPiastres,
        items: state.items,
      );
      state = state.copyWith(isSaving: false, savedInvoice: invoice);
      return invoice;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'فشل حفظ الفاتورة: $e',
      );
      return null;
    }
  }
}
