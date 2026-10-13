import 'package:flutter_riverpod/legacy.dart';

import '../domain/pricing_calculator.dart';
import '../domain/quotation.dart';
import '../domain/quotation_repository.dart';

/// State of the quotation creation and editing form.
class QuotationFormState {
  const QuotationFormState({
    this.id,
    this.referenceNumber,
    this.customerName = '',
    this.customerPhone,
    this.notes,
    required this.issueDate,
    this.validUntil,
    this.discountPiastres = 0,
    this.taxPiastres = 0,
    this.items = const [],
    this.isSaving = false,
    this.errorMessage,
    this.savedQuotation,
  });

  final int? id;
  final String? referenceNumber;
  final String customerName;
  final String? customerPhone;
  final String? notes;
  final DateTime issueDate;
  final DateTime? validUntil;
  final int discountPiastres;
  final int taxPiastres;
  final List<QuotationItemDraft> items;
  final bool isSaving;
  final String? errorMessage;
  final Quotation? savedQuotation;

  bool get isEditing => id != null;

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

  QuotationFormState copyWith({
    int? id,
    String? referenceNumber,
    String? customerName,
    String? customerPhone,
    String? notes,
    DateTime? issueDate,
    DateTime? validUntil,
    int? discountPiastres,
    int? taxPiastres,
    List<QuotationItemDraft>? items,
    bool? isSaving,
    String? errorMessage,
    Quotation? savedQuotation,
  }) {
    return QuotationFormState(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      issueDate: issueDate ?? this.issueDate,
      validUntil: validUntil ?? this.validUntil,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      items: items ?? this.items,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      savedQuotation: savedQuotation,
    );
  }
}

/// State notifier managing in-memory quotation construction and validation.
class QuotationFormController extends StateNotifier<QuotationFormState> {
  QuotationFormController({
    Quotation? initialQuotation,
    List<QuotationItemDraft>? initialItems,
  }) : super(
         initialQuotation != null
             ? QuotationFormState(
                 id: initialQuotation.id,
                 referenceNumber: initialQuotation.referenceNumber,
                 customerName: initialQuotation.customerName,
                 customerPhone: initialQuotation.customerPhone,
                 notes: initialQuotation.notes,
                 issueDate: initialQuotation.issueDate,
                 validUntil: initialQuotation.validUntil,
                 discountPiastres: initialQuotation.discountPiastres,
                 taxPiastres: initialQuotation.taxPiastres,
                 items: initialQuotation.items
                     .map(
                       (i) => QuotationItemDraft(
                         productId: i.productId,
                         productCode: i.productCode,
                         productName: i.productName,
                         unit: i.unit,
                         unitPricePiastres: i.unitPricePiastres,
                         quantity: i.quantity,
                         lineDiscountPiastres: i.lineDiscountPiastres,
                       ),
                     )
                     .toList(),
               )
             : QuotationFormState(
                 issueDate: DateTime.now(),
                 items: initialItems ?? const [],
               ),
       );

  void setCustomerName(String name) {
    state = state.copyWith(customerName: name);
  }

  void setCustomerPhone(String? phone) {
    state = state.copyWith(customerPhone: phone);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void setDiscountPiastres(int discount) {
    state = state.copyWith(discountPiastres: discount > 0 ? discount : 0);
  }

  void setTaxPiastres(int tax) {
    state = state.copyWith(taxPiastres: tax > 0 ? tax : 0);
  }

  void addItem(QuotationItemDraft item) {
    final updated = List<QuotationItemDraft>.from(state.items)..add(item);
    state = state.copyWith(items: updated);
  }

  void updateItem(int index, QuotationItemDraft item) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<QuotationItemDraft>.from(state.items);
    updated[index] = item;
    state = state.copyWith(items: updated);
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<QuotationItemDraft>.from(state.items)..removeAt(index);
    state = state.copyWith(items: updated);
  }

  Future<bool> saveQuotation(QuotationRepository repository) async {
    final trimmedName = state.customerName.trim();
    if (trimmedName.isEmpty) {
      state = state.copyWith(errorMessage: 'اسم العميل مطلوب');
      return false;
    }

    if (state.items.isEmpty) {
      state = state.copyWith(
        errorMessage: 'يجب إضافة صنف واحد على الأقل لعرض السعر',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final Quotation saved;
      if (state.id != null) {
        saved = await repository.updateQuotation(
          id: state.id!,
          customerName: trimmedName,
          customerPhone: state.customerPhone,
          issueDate: state.issueDate,
          validUntil: state.validUntil,
          notes: state.notes,
          discountPiastres: state.discountPiastres,
          taxPiastres: state.taxPiastres,
          items: state.items,
        );
      } else {
        saved = await repository.createQuotation(
          customerName: trimmedName,
          customerPhone: state.customerPhone,
          issueDate: state.issueDate,
          validUntil: state.validUntil,
          notes: state.notes,
          discountPiastres: state.discountPiastres,
          taxPiastres: state.taxPiastres,
          items: state.items,
        );
      }

      state = state.copyWith(isSaving: false, savedQuotation: saved);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'تعذر حفظ عرض السعر: $e',
      );
      return false;
    }
  }
}
