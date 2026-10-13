import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/invoices/domain/invoice.dart';
import '../../features/invoices/presentation/invoice_form_screen.dart';
import '../../features/invoices/presentation/invoices_screen.dart';
import '../../features/products/presentation/products_screen.dart';
import '../../features/quotations/domain/quotation.dart';
import '../../features/quotations/presentation/quotation_form_screen.dart';
import '../../features/quotations/presentation/quotations_screen.dart';
import '../../features/scan/presentation/scan_review_screen.dart';
import '../../features/scan/presentation/scan_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import 'app_shell.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNav',
);
final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'homeNav',
);
final GlobalKey<NavigatorState> productsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'productsNav');
final GlobalKey<NavigatorState> quotationsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'quotationsNav');
final GlobalKey<NavigatorState> invoicesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'invoicesNav');

/// Builds the GoRouter instance configuring the 4-branch indexed shell,
/// root routes, and safe localized error handling.
GoRouter createAppRouter({String initialLocation = RouteNames.homePath}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.home,
                path: RouteNames.homePath,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: productsNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.products,
                path: RouteNames.productsPath,
                builder: (context, state) => const ProductsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: quotationsNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.quotations,
                path: RouteNames.quotationsPath,
                builder: (context, state) => const QuotationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: invoicesNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.invoices,
                path: RouteNames.invoicesPath,
                builder: (context, state) => const InvoicesScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: RouteNames.scan,
        path: RouteNames.scanPath,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        name: RouteNames.scanReview,
        path: RouteNames.scanReviewPath,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScanReviewScreen(),
      ),
      GoRoute(
        name: RouteNames.settings,
        path: RouteNames.settingsPath,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        name: RouteNames.quotationNew,
        path: RouteNames.quotationNewPath,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          if (state.extra is Quotation) {
            return QuotationFormScreen(
              existingQuotation: state.extra as Quotation,
            );
          } else if (state.extra is List<QuotationItemDraft>) {
            return QuotationFormScreen(
              initialItems: state.extra as List<QuotationItemDraft>,
            );
          }
          return const QuotationFormScreen();
        },
      ),
      GoRoute(
        name: RouteNames.invoiceNew,
        path: RouteNames.invoiceNewPath,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          if (state.extra is List<InvoiceItemDraft>) {
            return InvoiceFormScreen(
              initialItems: state.extra as List<InvoiceItemDraft>,
            );
          }
          return const InvoiceFormScreen();
        },
      ),
    ],
    errorBuilder: (context, state) {
      final l10n = AppLocalizations.of(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.notFoundTitle)),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 64,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.notFoundMessage,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(RouteNames.homePath),
                    child: Text(l10n.backToHome),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
