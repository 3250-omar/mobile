import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/navigation/app_router.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/products/presentation/products_screen.dart';
import 'package:offline_quotes/features/scan/presentation/scan_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';
import 'package:offline_quotes/features/settings/presentation/settings_screen.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

import '../../support/fake_catalog_repository.dart';
import '../../support/fake_dashboard_repository.dart';
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
  Widget buildApp() {
    final router = createAppRouter();
    return ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(_FakeSettingsRepo()),
        catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
        quotationRepositoryProvider.overrideWithValue(
          FakeQuotationRepository(),
        ),
        invoiceRepositoryProvider.overrideWithValue(FakeInvoiceRepository()),
        dashboardRepositoryProvider.overrideWithValue(
          FakeDashboardRepository(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
      ),
    );
  }

  group('AppShell Interaction & RTL', () {
    testWidgets(
      'renders four bottom navigation destinations and prominent scan FAB',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('nav_branch_home')), findsOneWidget);
        expect(find.byKey(const Key('nav_branch_products')), findsOneWidget);
        expect(find.byKey(const Key('nav_branch_quotations')), findsOneWidget);
        expect(find.byKey(const Key('nav_branch_invoices')), findsOneWidget);
        expect(find.byKey(const Key('shell_scan_fab')), findsOneWidget);
        expect(find.byKey(const Key('shell_settings_button')), findsOneWidget);
      },
    );

    testWidgets(
      'switching bottom navigation destinations updates active screen',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_branch_products')));
        await tester.pumpAndSettle();
        expect(find.byType(ProductsScreen), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_branch_home')));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);
      },
    );

    testWidgets('tapping prominent scan FAB opens ScanScreen', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shell_scan_fab')));
      await tester.pumpAndSettle();
      expect(find.byType(ScanScreen), findsOneWidget);
    });

    testWidgets('tapping settings icon opens SettingsScreen', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shell_settings_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
