import 'package:flutter_riverpod/legacy.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/business_profile.dart';
import '../domain/business_profile_repository.dart';

/// Immutable state for the merchant's business profile management.
class BusinessProfileState {
  const BusinessProfileState({
    required this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  final BusinessProfile profile;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  BusinessProfileState copyWith({
    BusinessProfile? profile,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return BusinessProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

/// Controller managing business profile data, validation, and local logo files.
class BusinessProfileController extends StateNotifier<BusinessProfileState> {
  BusinessProfileController(this._repository)
    : super(BusinessProfileState(profile: BusinessProfile.defaults())) {
    loadProfile();
  }

  final BusinessProfileRepository _repository;

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await _repository.load();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'تعذر تحميل بيانات المنشأة',
      );
    }
  }

  Future<bool> saveProfile({
    required String businessName,
    String? ownerName,
    required String phonePrimary,
    String? phoneSecondary,
    String? address,
    String? city,
    String? taxNumber,
    String? commercialRegister,
    String? defaultQuotationNotes,
    String? defaultInvoiceTerms,
  }) async {
    final trimmedName = businessName.trim();
    if (trimmedName.isEmpty) {
      state = state.copyWith(errorMessage: 'اسم المنشأة أو المحل مطلوب');
      return false;
    }

    final trimmedPhone = phonePrimary.trim();
    if (trimmedPhone.isEmpty) {
      state = state.copyWith(errorMessage: 'رقم الهاتف الرئيسي مطلوب');
      return false;
    }

    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final updated = state.profile.copyWith(
        businessName: trimmedName,
        ownerName: ownerName?.trim().isEmpty == true ? null : ownerName?.trim(),
        phonePrimary: trimmedPhone,
        phoneSecondary: phoneSecondary?.trim().isEmpty == true
            ? null
            : phoneSecondary?.trim(),
        address: address?.trim().isEmpty == true ? null : address?.trim(),
        city: city?.trim().isEmpty == true ? null : city?.trim(),
        taxNumber: taxNumber?.trim().isEmpty == true ? null : taxNumber?.trim(),
        commercialRegister: commercialRegister?.trim().isEmpty == true
            ? null
            : commercialRegister?.trim(),
        defaultQuotationNotes: defaultQuotationNotes?.trim().isEmpty == true
            ? null
            : defaultQuotationNotes?.trim(),
        defaultInvoiceTerms: defaultInvoiceTerms?.trim().isEmpty == true
            ? null
            : defaultInvoiceTerms?.trim(),
      );

      final saved = await _repository.save(updated);
      state = state.copyWith(
        profile: saved,
        isSaving: false,
        successMessage: 'تم حفظ بيانات المنشأة بنجاح',
      );
      return true;
    } catch (e) {
      final msg = e is AppFailure
          ? 'حدث خطأ أثناء حفظ البيانات'
          : 'تعذر حفظ بيانات المنشأة';
      state = state.copyWith(isSaving: false, errorMessage: msg);
      return false;
    }
  }

  Future<bool> setLogoBytes(List<int> bytes, String extension) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final path = await _repository.saveLogoFile(bytes, extension);
      final updated = state.profile.copyWith(logoPath: path);
      state = state.copyWith(
        profile: updated,
        isSaving: false,
        successMessage: 'تم تحديث شعار المنشأة بنجاح',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'تعذر حفظ الشعار المحدد',
      );
      return false;
    }
  }

  Future<bool> removeLogo() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteLogoFile();
      final updated = state.profile.copyWith(clearLogo: true);
      state = state.copyWith(
        profile: updated,
        isSaving: false,
        successMessage: 'تم حذف الشعار بنجاح',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: 'تعذر حذف الشعار');
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}
