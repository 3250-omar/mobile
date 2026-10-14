/// Pure Dart domain model representing the merchant's business identity,
/// branding, and document header/footer defaults.
class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.businessName,
    this.ownerName,
    required this.phonePrimary,
    this.phoneSecondary,
    this.address,
    this.city,
    this.taxNumber,
    this.commercialRegister,
    this.logoPath,
    this.defaultQuotationNotes,
    this.defaultInvoiceTerms,
    required this.updatedAt,
  });

  /// Singleton identifier. Always 1.
  final int id;

  /// Business / trade name (اسم المؤسسة / المتجر).
  final String businessName;

  /// Responsible owner / contact name (اسم المسؤول).
  final String? ownerName;

  /// Primary phone number (رقم الهاتف الأساسي).
  final String phonePrimary;

  /// Secondary phone or WhatsApp number (رقم إضافي / واتساب).
  final String? phoneSecondary;

  /// Physical shop or warehouse address (العنوان).
  final String? address;

  /// City / governorate (المدينة / المحافظة).
  final String? city;

  /// Tax card number (البطاقة الضريبية).
  final String? taxNumber;

  /// Commercial register number (السجل التجاري).
  final String? commercialRegister;

  /// Local sandboxed relative file path for store logo image.
  final String? logoPath;

  /// Default quotation terms and validity note printed on PDF.
  final String? defaultQuotationNotes;

  /// Default invoice terms, warranty, and return policy printed on PDF.
  final String? defaultInvoiceTerms;

  /// Last modification timestamp.
  final DateTime updatedAt;

  /// Deterministic default business profile used on first initialization.
  factory BusinessProfile.defaults() => BusinessProfile(
    id: 1,
    businessName: 'تسعيرة للأدوات الصحية والسباكة',
    phonePrimary: '',
    updatedAt: DateTime.now(),
  );

  bool get hasLogo => logoPath != null && logoPath!.trim().isNotEmpty;

  bool get hasTaxCredentials =>
      (taxNumber != null && taxNumber!.trim().isNotEmpty) ||
      (commercialRegister != null && commercialRegister!.trim().isNotEmpty);

  BusinessProfile copyWith({
    String? businessName,
    String? ownerName,
    String? phonePrimary,
    String? phoneSecondary,
    String? address,
    String? city,
    String? taxNumber,
    String? commercialRegister,
    String? logoPath,
    bool clearLogo = false,
    String? defaultQuotationNotes,
    String? defaultInvoiceTerms,
    DateTime? updatedAt,
  }) {
    return BusinessProfile(
      id: id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phonePrimary: phonePrimary ?? this.phonePrimary,
      phoneSecondary: phoneSecondary ?? this.phoneSecondary,
      address: address ?? this.address,
      city: city ?? this.city,
      taxNumber: taxNumber ?? this.taxNumber,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      logoPath: clearLogo ? null : (logoPath ?? this.logoPath),
      defaultQuotationNotes:
          defaultQuotationNotes ?? this.defaultQuotationNotes,
      defaultInvoiceTerms: defaultInvoiceTerms ?? this.defaultInvoiceTerms,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          businessName == other.businessName &&
          ownerName == other.ownerName &&
          phonePrimary == other.phonePrimary &&
          phoneSecondary == other.phoneSecondary &&
          address == other.address &&
          city == other.city &&
          taxNumber == other.taxNumber &&
          commercialRegister == other.commercialRegister &&
          logoPath == other.logoPath &&
          defaultQuotationNotes == other.defaultQuotationNotes &&
          defaultInvoiceTerms == other.defaultInvoiceTerms;

  @override
  int get hashCode => Object.hash(
    id,
    businessName,
    ownerName,
    phonePrimary,
    phoneSecondary,
    address,
    city,
    taxNumber,
    commercialRegister,
    logoPath,
    defaultQuotationNotes,
    defaultInvoiceTerms,
  );
}
