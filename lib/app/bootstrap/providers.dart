import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/database/app_database.dart';
import '../../core/diagnostics/app_logger.dart';
import '../../core/storage/platform_data_protection.dart';
import '../../features/products/application/catalog_controller.dart';
import '../../features/products/application/import_controller.dart';
import '../../features/products/data/drift_catalog_repository.dart';
import '../../features/products/domain/catalog_repository.dart';
import '../../features/backup/application/backup_restore_controller.dart';
import '../../features/backup/data/default_backup_restore_service.dart';
import '../../features/backup/domain/backup_restore_service.dart';
import '../../features/home/application/dashboard_controller.dart';
import '../../features/home/application/dashboard_state.dart';
import '../../features/home/data/drift_dashboard_repository.dart';
import '../../features/home/domain/dashboard_repository.dart';
import '../../features/invoices/application/invoices_controller.dart';
import '../../features/invoices/data/drift_invoice_repository.dart';
import '../../features/invoices/data/pdf_invoice_generator.dart';
import '../../features/invoices/domain/invoice_repository.dart';
import '../../features/invoices/domain/pdf_invoice_generator.dart';
import '../../features/quotations/application/quotations_controller.dart';
import '../../features/quotations/data/drift_quotation_repository.dart';
import '../../features/quotations/data/pdf_quotation_generator.dart';
import '../../features/quotations/domain/pdf_quotation_generator.dart';
import '../../features/quotations/domain/quotation_repository.dart';
import '../../features/scan/application/scan_controller.dart';
import '../../features/scan/application/scan_state.dart';
import '../../features/scan/data/drift_catalog_matcher.dart';
import '../../features/scan/data/image_capture_service.dart';
import '../../features/scan/data/mlkit_ocr_scanner.dart';
import '../../features/scan/domain/catalog_matcher.dart';
import '../../features/scan/domain/ocr_scanner.dart';
import '../../features/scan/domain/plumbing_line_parser.dart';
import '../../features/scan/domain/plumbing_text_parser.dart';
import '../../features/settings/application/business_profile_controller.dart';
import '../../features/settings/application/settings_controller.dart';
import '../../features/settings/data/drift_business_profile_repository.dart';
import '../../features/settings/domain/app_settings.dart';
import '../../features/settings/domain/business_profile_repository.dart';
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

/// Provider for 100% offline PDF quotation generator.
final pdfQuotationGeneratorProvider = Provider<PdfQuotationGenerator>((ref) {
  return DefaultPdfQuotationGenerator();
});

/// Provider for invoices repository.
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftInvoiceRepository(db);
});

/// Provider for 100% offline PDF invoice generator.
final pdfInvoiceGeneratorProvider = Provider<PdfInvoiceGenerator>((ref) {
  return DefaultPdfInvoiceGenerator();
});

/// Provider for invoices list and filter controller.
final invoicesControllerProvider =
    StateNotifierProvider<InvoicesController, InvoicesState>((ref) {
      final repository = ref.watch(invoiceRepositoryProvider);
      return InvoicesController(repository);
    });

/// Provider for local image acquisition.
final imageCaptureServiceProvider = Provider<ImageCaptureService>((ref) {
  return const FilePickerImageCaptureService();
});

/// Provider for on-device OCR engine.
final ocrScannerProvider = Provider<OcrScanner>((ref) {
  return const MlKitOcrScanner();
});

/// Provider for Arabic plumbing text normalization and line parser.
final plumbingTextParserProvider = Provider<PlumbingTextParser>((ref) {
  return const DefaultPlumbingLineParser();
});

/// Provider for local SQLite catalog matching.
final catalogMatcherProvider = Provider<CatalogMatcher>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftCatalogMatcher(db);
});

/// Provider for scan session controller.
final scanControllerProvider = StateNotifierProvider<ScanController, ScanState>(
  (ref) {
    final imageCapture = ref.watch(imageCaptureServiceProvider);
    final ocrScanner = ref.watch(ocrScannerProvider);
    final textParser = ref.watch(plumbingTextParserProvider);
    final catalogMatcher = ref.watch(catalogMatcherProvider);
    return ScanController(
      imageCaptureService: imageCapture,
      ocrScanner: ocrScanner,
      textParser: textParser,
      catalogMatcher: catalogMatcher,
    );
  },
);

/// Provider for dashboard operational metrics and recent activities repository.
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftDashboardRepository(db);
});

/// Provider for live home dashboard state controller.
final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final repository = ref.watch(dashboardRepositoryProvider);
      return DashboardController(repository);
    });

/// Provider for local backup and restore service.
final backupRestoreServiceProvider = Provider<BackupRestoreService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DefaultBackupRestoreService(db: db);
});

/// Provider for backup and restore controller.
final backupRestoreControllerProvider =
    StateNotifierProvider<BackupRestoreController, BackupRestoreState>((ref) {
      final service = ref.watch(backupRestoreServiceProvider);
      return BackupRestoreController(service);
    });

/// Provider for the business profile repository.
final businessProfileRepositoryProvider = Provider<BusinessProfileRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftBusinessProfileRepository(db);
});

/// Provider for business profile management controller.
final businessProfileControllerProvider =
    StateNotifierProvider<BusinessProfileController, BusinessProfileState>((
      ref,
    ) {
      final repository = ref.watch(businessProfileRepositoryProvider);
      return BusinessProfileController(repository);
    });
