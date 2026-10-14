import 'business_profile.dart';

/// Contract for loading, watching, and persisting the singleton [BusinessProfile],
/// as well as handling local sandboxed logo files.
abstract interface class BusinessProfileRepository {
  /// Loads the persisted business profile, initializing deterministic defaults if absent.
  Future<BusinessProfile> load();

  /// Observes real-time changes to the business profile singleton.
  Stream<BusinessProfile> watch();

  /// Atomically updates and persists the business profile.
  Future<BusinessProfile> save(BusinessProfile profile);

  /// Saves newly picked logo bytes into the application's secure sandbox directory
  /// and returns the local relative file path.
  Future<String> saveLogoFile(List<int> bytes, String extension);

  /// Removes the active sandboxed logo file from storage.
  Future<void> deleteLogoFile();
}
