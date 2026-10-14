# Data Model: 008-business-profile

## Domain Entity: `BusinessProfile`

Defined in `lib/features/settings/domain/business_profile.dart`. Zero dependencies on Flutter, Drift, or external packages.

```dart
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

  final int id; // Always 1 (singleton)
  final String businessName;
  final String? ownerName;
  final String phonePrimary;
  final String? phoneSecondary;
  final String? address;
  final String? city;
  final String? taxNumber;
  final String? commercialRegister;
  final String? logoPath;
  final String? defaultQuotationNotes;
  final String? defaultInvoiceTerms;
  final DateTime updatedAt;

  factory BusinessProfile.defaults() => BusinessProfile(
    id: 1,
    businessName: 'تسعيرة للأدوات الصحية',
    phonePrimary: '',
    updatedAt: DateTime.now(),
  );

  bool get hasLogo => logoPath != null && logoPath!.isNotEmpty;
  bool get hasTaxCredentials => (taxNumber != null && taxNumber!.isNotEmpty) ||
                                (commercialRegister != null && commercialRegister!.isNotEmpty);

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
  });
}
```

---

## SQLite Table: `business_profiles`

Defined in `lib/core/database/tables/business_profile_table.dart`.

```sql
CREATE TABLE business_profiles (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  business_name TEXT NOT NULL,
  owner_name TEXT,
  phone_primary TEXT NOT NULL,
  phone_secondary TEXT,
  address TEXT,
  city TEXT,
  tax_number TEXT,
  commercial_register TEXT,
  logo_path TEXT,
  default_quotation_notes TEXT,
  default_invoice_terms TEXT,
  updated_at INTEGER NOT NULL
);
```

---

## Validation Rules & Invariants

1. **Singleton Enactment**: `id` column must always equal `1`.
2. **Mandatory Fields**: `business_name` must be between 2 and 100 characters. `phone_primary` must not be blank.
3. **Logo Integrity**: `logo_path` must refer to a relative or valid local sandboxed file path. If the file does not exist, the app gracefully falls back to text-only rendering.
4. **Offline Isolation**: All phone numbers and text strings are processed locally with zero external network lookup.
