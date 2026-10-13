import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/navigation/app_router.dart';
import 'package:offline_quotes/app/navigation/route_names.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/invoices/presentation/invoices_screen.dart';
import 'package:offline_quotes/features/products/presentation/products_screen.dart';
import 'package:offline_quotes/features/quotations/presentation/quotations_screen.dart';
import 'package:offline_quotes/features/scan/presentation/scan_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';
import 'package:offline_quotes/features/settings/presentation/settings_screen.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

import '../../support/fake_catalog_repository.dart';
import '../../support/fake_invoice_repository.dart';
import '../../support/fake_quotation_repository.dart';

class _FakeSettingsRepo implements SettingsRepository {
  AppSettings current = AppSettings.defaults();

  @override
  Future<AppSettings> load() async => current;

  @override
  Stream<AppSettings> watch() => Stream.value(current);

  @override
  Future<AppSettings> setThemeMode(String mode) async {
    current = current.copyWith(themeMode: mode, revision: current.revision + 1);
    return current;
  }
}

void main() {
  Widget buildAppWithRouter({String initialLocation = RouteNames.homePath}) {
    final router = createAppRouter(initialLocation: initialLocation);
    return ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(_FakeSettingsRepo()),
        catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
        quotationRepositoryProvider.overrideWithValue(
          FakeQuotationRepository(),
        ),
        invoiceRepositoryProvider.overrideWithValue(FakeInvoiceRepository()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
      ),
    );
  }

  group('AppRouter Navigation', () {
    testWidgets('initial location renders HomeScreen', (tester) async {
      await tester.pumpWidget(buildAppWithRouter());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('navigates to Products branch', (tester) async {
      await tester.pumpWidget(
        buildAppWithRouter(initialLocation: RouteNames.productsPath),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProductsScreen), findsOneWidget);
    });

    testWidgets('navigates to Quotations branch', (tester) async {
      await tester.pumpWidget(
        buildAppWithRouter(initialLocation: RouteNames.quotationsPath),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuotationsScreen), findsOneWidget);
    });

    testWidgets('navigates to Invoices branch', (tester) async {
      await tester.pumpWidget(
        buildAppWithRouter(initialLocation: RouteNames.invoicesPath),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InvoicesScreen), findsOneWidget);
    });

    testWidgets('navigates to Scan root screen', (tester) async {
      await tester.pumpWidget(
        buildAppWithRouter(initialLocation: RouteNames.scanPath),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScanScreen), findsOneWidget);
    });

    testWidgets('navigates to Settings root screen', (tester) async {
      await tester.pumpWidget(
        buildAppWithRouter(initialLocation: RouteNames.settingsPath),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('unknown route displays localized error page and back button', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildAppWithRouter(initialLocation: '/unknown-route-path'),
      );
      await tester.pumpAndSettle();

      expect(find.text('الصفحة غير موجودة'), findsOneWidget);
      expect(find.text('العودة للرئيسية'), findsOneWidget);

      await tester.tap(find.text('العودة للرئيسية'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
