import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../application/business_profile_controller.dart';
import '../domain/business_profile.dart';
import 'widgets/business_header_preview_card.dart';

/// Full screen editor allowing merchants to customize their store details,
/// branding logo, and legal/footer notes printed on PDF documents.
class BusinessProfileScreen extends ConsumerStatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  ConsumerState<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _businessNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _phonePrimaryController;
  late final TextEditingController _phoneSecondaryController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;
  late final TextEditingController _taxNumberController;
  late final TextEditingController _crController;
  late final TextEditingController _quotationNotesController;
  late final TextEditingController _invoiceTermsController;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _ownerNameController = TextEditingController();
    _phonePrimaryController = TextEditingController();
    _phoneSecondaryController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
    _taxNumberController = TextEditingController();
    _crController = TextEditingController();
    _quotationNotesController = TextEditingController();
    _invoiceTermsController = TextEditingController();

    // Listen to changes to trigger live preview rebuilds
    _businessNameController.addListener(_onFieldChanged);
    _ownerNameController.addListener(_onFieldChanged);
    _phonePrimaryController.addListener(_onFieldChanged);
    _phoneSecondaryController.addListener(_onFieldChanged);
    _cityController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
    _taxNumberController.addListener(_onFieldChanged);
    _crController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  void _populateForm(BusinessProfile profile) {
    if (!_initialized) {
      _businessNameController.text = profile.businessName;
      _ownerNameController.text = profile.ownerName ?? '';
      _phonePrimaryController.text = profile.phonePrimary;
      _phoneSecondaryController.text = profile.phoneSecondary ?? '';
      _cityController.text = profile.city ?? '';
      _addressController.text = profile.address ?? '';
      _taxNumberController.text = profile.taxNumber ?? '';
      _crController.text = profile.commercialRegister ?? '';
      _quotationNotesController.text = profile.defaultQuotationNotes ?? '';
      _invoiceTermsController.text = profile.defaultInvoiceTerms ?? '';
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phonePrimaryController.dispose();
    _phoneSecondaryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _taxNumberController.dispose();
    _crController.dispose();
    _quotationNotesController.dispose();
    _invoiceTermsController.dispose();
    super.dispose();
  }

  BusinessProfile _buildPreviewProfile(BusinessProfile base) {
    return base.copyWith(
      businessName: _businessNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      phonePrimary: _phonePrimaryController.text.trim(),
      phoneSecondary: _phoneSecondaryController.text.trim(),
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
      taxNumber: _taxNumberController.text.trim(),
      commercialRegister: _crController.text.trim(),
    );
  }

  Future<void> _handlePickLogo() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(businessProfileControllerProvider.notifier);

    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty || files.first.path == null) return;

    final file = File(files.first.path!);
    final bytes = await file.readAsBytes();
    final extension = files.first.extension ?? 'png';

    final success = await controller.setLogoBytes(bytes, extension);
    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('تم تحديث شعار المتجر بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleRemoveLogo() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(businessProfileControllerProvider.notifier);

    final success = await controller.removeLogo();
    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('تم حذف الشعار بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(businessProfileControllerProvider.notifier);

    final success = await controller.saveProfile(
      businessName: _businessNameController.text,
      ownerName: _ownerNameController.text,
      phonePrimary: _phonePrimaryController.text,
      phoneSecondary: _phoneSecondaryController.text,
      city: _cityController.text,
      address: _addressController.text,
      taxNumber: _taxNumberController.text,
      commercialRegister: _crController.text,
      defaultQuotationNotes: _quotationNotesController.text,
      defaultInvoiceTerms: _invoiceTermsController.text,
    );

    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('تم حفظ بيانات المنشأة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessProfileControllerProvider);
    final theme = Theme.of(context);

    // Populate initial form values once state is loaded
    if (!state.isLoading) {
      _populateForm(state.profile);
    }

    ref.listen<BusinessProfileState>(businessProfileControllerProvider, (
      prev,
      next,
    ) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    final previewProfile = _buildPreviewProfile(state.profile);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات المنشأة والفواتير'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // 1. Live visual header preview
                    BusinessHeaderPreviewCard(profile: previewProfile),
                    const SizedBox(height: AppSpacing.lg),

                    // 2. Logo selector card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_size_select_actual_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'شعار المحل / المؤسسة',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.profile.hasLogo
                                      ? 'تم ضبط شعار مخصص للمستندات'
                                      : 'لم يتم تحديد شعار بعد (اختياري)',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: state.isSaving ? null : _handlePickLogo,
                            icon: const Icon(Icons.upload, size: 16),
                            label: Text(
                              state.profile.hasLogo ? 'تغيير' : 'اختيار',
                            ),
                          ),
                          if (state.profile.hasLogo) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: state.isSaving
                                  ? null
                                  : _handleRemoveLogo,
                              tooltip: 'حذف الشعار',
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 3. Basic Business Details
                    Text(
                      'البيانات الأساسية للمتجر',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          AppTextField(
                            key: const Key('profile_business_name_input'),
                            controller: _businessNameController,
                            label: 'اسم المنشأة أو المحل *',
                            hintText: 'مثال: مؤسسة الأمل للأدوات الصحية',
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'اسم المنشأة مطلوب';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: const Key('profile_owner_name_input'),
                            controller: _ownerNameController,
                            label: 'اسم المسؤول / التاجر (اختياري)',
                            hintText: 'مثال: الحاج أحمد فؤاد',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: const Key('profile_phone_primary_input'),
                            controller: _phonePrimaryController,
                            label: 'رقم الهاتف الرئيسي *',
                            hintText: 'مثال: 01012345678',
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'رقم الهاتف الرئيسي مطلوب';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: const Key('profile_phone_secondary_input'),
                            controller: _phoneSecondaryController,
                            label: 'رقم هاتف إضافي / واتساب (اختياري)',
                            hintText: 'مثال: 01200000000',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  key: const Key('profile_city_input'),
                                  controller: _cityController,
                                  label: 'المدينة / المحافظة',
                                  hintText: 'المنصورة',
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                flex: 3,
                                child: AppTextField(
                                  key: const Key('profile_address_input'),
                                  controller: _addressController,
                                  label: 'العنوان التفصيلي',
                                  hintText: 'شارع الجيش',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 4. Legal / Tax Registration
                    Text(
                      'البيانات الضريبية والتجارية (تظهر بالفواتير)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          AppTextField(
                            key: const Key('profile_tax_input'),
                            controller: _taxNumberController,
                            label: 'رقم البطاقة الضريبية (اختياري)',
                            hintText: '123-456-789',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: const Key('profile_cr_input'),
                            controller: _crController,
                            label: 'رقم السجل التجاري (اختياري)',
                            hintText: '78945',
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 5. Default Document Terms & Notes
                    Text(
                      'الشروط والملاحظات الافتراضية للطباعة',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          AppTextField(
                            key: const Key('profile_quote_notes_input'),
                            controller: _quotationNotesController,
                            label: 'شروط عروض الأسعار الافتراضية',
                            hintText: 'مثال: عرض الأسعار سارٍ لمدة ٧ أيام من تاريخه والأسعار قابلة للتغيير.',
                            maxLines: 2,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: const Key('profile_invoice_terms_input'),
                            controller: _invoiceTermsController,
                            label: 'شروط وفواتير البيع الافتراضية',
                            hintText: 'مثال: البضاعة المباعة ترد وتستبدل خلال ١٤ يوماً بموجب أصل الفاتورة.',
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // 6. Save Button
                    AppButton(
                      key: const Key('profile_save_button'),
                      label: 'حفظ بيانات المنشأة',
                      isLoading: state.isSaving,
                      onPressed: state.isSaving ? null : _handleSave,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
      ),
    );
  }
}
