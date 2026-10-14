# Contract: BusinessProfileRepository & Controller

## Interface: `BusinessProfileRepository`

Location: `lib/features/settings/domain/business_profile_repository.dart`

```dart
abstract interface class BusinessProfileRepository {
  /// Loads the business profile singleton (id = 1), creating deterministic defaults if not present.
  Future<BusinessProfile> load();

  /// Observes real-time changes to the business profile.
  Stream<BusinessProfile> watch();

  /// Atomically saves changes to the business profile.
  Future<BusinessProfile> save(BusinessProfile profile);

  /// Saves a newly picked logo file bytes into application sandbox storage and returns the saved file path.
  Future<String> saveLogoFile(List<int> bytes, String extension);

  /// Removes the active sandboxed logo file.
  Future<void> deleteLogoFile();
}
```

---

## State & Controller: `BusinessProfileController`

Location: `lib/features/settings/application/business_profile_controller.dart`

```dart
class BusinessProfileState {
  final BusinessProfile profile;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;
}
```
