import 'package:drift/drift.dart';

/// Drift table definition for the merchant's [BusinessProfile] singleton aggregate.
///
/// Contains strictly one row with id = 1 storing branding, legal registration,
/// and document header/footer defaults.
@TableIndex(name: 'idx_business_profiles_id', columns: {#id})
@DataClassName('BusinessProfileData', companion: 'BusinessProfileCompanion')
class BusinessProfilesTable extends Table {
  @override
  String get tableName => 'business_profiles';

  /// Primary key singleton constraint: id is always 1.
  IntColumn get id => integer()
      .withDefault(const Constant(1))
      .customConstraint('NOT NULL CHECK (id = 1)')();

  /// Business / store trade name (e.g. مؤسسة الأمل للأدوات الصحية).
  TextColumn get businessName => text()();

  /// Responsible merchant / owner name.
  TextColumn get ownerName => text().nullable()();

  /// Primary contact phone number.
  TextColumn get phonePrimary => text()();

  /// Secondary phone number or WhatsApp.
  TextColumn get phoneSecondary => text().nullable()();

  /// Store physical address / street.
  TextColumn get address => text().nullable()();

  /// City / governorate (e.g. المنصورة، الدقهلية).
  TextColumn get city => text().nullable()();

  /// Tax card number (البطاقة الضريبية).
  TextColumn get taxNumber => text().nullable()();

  /// Commercial register number (السجل التجاري).
  TextColumn get commercialRegister => text().nullable()();

  /// Local sandboxed relative file path for store logo.
  TextColumn get logoPath => text().nullable()();

  /// Default quotation terms and validity note printed on PDF.
  TextColumn get defaultQuotationNotes => text().nullable()();

  /// Default invoice terms, warranty, and return policy printed on PDF.
  TextColumn get defaultInvoiceTerms => text().nullable()();

  /// Last updated UTC instant formatted as ISO-8601 string.
  TextColumn get updatedAtUtc => text()();

  @override
  Set<Column> get primaryKey => {id};
}
