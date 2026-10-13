import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/database/app_database.dart';
import '../../core/diagnostics/app_logger.dart';
import '../../core/storage/platform_data_protection.dart';
import '../../features/products/application/catalog_controller.dart';
import '../../features/products/application/import_controller.dart';
import '../../features/products/data/drift_catalog_repository.dart';
import '../../features/products/domain/catalog_repository.dart';
import '../../features/quotations/application/quotations_controller.dart';
import '../../features/quotations/data/drift_quotation_repository.dart';
import '../../features/quotations/domain/quotation_repository.dart';
import '../../features/settings/application/settings_controller.dart';
import '../../features/settings/domain/app_settings.dart';
import '../../features/settings/domain/settings_repository.dart';
import 'app_environment.dart';
import 'initialization_controller.dart';
import 'initialization_state.dart';

/// Provider for the compile-time application environment.
final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fromEnvironment();
});

/// Provider for local privacy-compliant diagnostics logger.
final appLoggerProvider = Provider<AppLogger>((ref) {
  final logger = AppLogger();
  ref.onDispose(() => logger.dispose());
  return logger;
});

/// Provider for OS platform data protection and backup exclusion.
final platformDataProtectionProvider = Provider<PlatformDataProtection>((ref) {
  return DefaultPlatformDataProtection();
});

/// Provider for persistent settings repository.
///
/// Overridden in tests or initialized during bootstrap.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError(
    'settingsRepositoryProvider must be initialized or overridden',
  );
});

/// Provider managing single-flight initialization lifecycle and recovery.
final initializationControllerProvider =
    StateNotifierProvider<
      InitializationController,
      ApplicationInitializationState
    >((ref) {
      return InitializationController();
    });

/// Provider for settings state controller.
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      return SettingsController(repository);
    });

/// Central Drift database instance provider.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider for products catalog repository.
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftCatalogRepository(db);
});

/// Provider for catalog state and instant search controller.
final catalogControllerProvider =
    StateNotifierProvider<CatalogController, CatalogState>((ref) {
      final repository = ref.watch(catalogRepositoryProvider);
      return CatalogController(repository);
    });

/// Provider for Excel catalog import controller.
final importControllerProvider =
    StateNotifierProvider<ImportController, ImportState>((ref) {
      final repository = ref.watch(catalogRepositoryProvider);
      return ImportController(catalogRepository: repository);
    });

/// Provider for quotations repository.
final quotationRepositoryProvider = Provider<QuotationRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftQuotationRepository(db);
});

/// Provider for quotations list and filter controller.
final quotationsControllerProvider =
    StateNotifierProvider<QuotationsController, QuotationsState>((ref) {
      final repository = ref.watch(quotationRepositoryProvider);
      return QuotationsController(repository);
    });
