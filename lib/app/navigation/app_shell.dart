import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'app_destination.dart';
import 'route_names.dart';

/// Application shell providing RTL 4-branch bottom navigation, prominent Scan,
/// and secondary Settings access.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appName),
          actions: [
            IconButton(
              key: const Key('shell_settings_button'),
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settingsTitle,
              onPressed: () => context.push(RouteNames.settingsPath),
            ),
          ],
        ),
        body: navigationShell,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          key: const Key('shell_scan_fab'),
          tooltip: l10n.scanTitle,
          elevation: 3,
          onPressed: () => context.push(RouteNames.scanPath),
          child: const Icon(Icons.document_scanner),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            final isRepeatedTap = index == navigationShell.currentIndex;
            navigationShell.goBranch(index, initialLocation: isRepeatedTap);
          },
          destinations: [
            NavigationDestination(
              key: const Key('nav_branch_home'),
              icon: Icon(AppDestination.home.icon),
              selectedIcon: Icon(AppDestination.home.selectedIcon),
              label: l10n.homeTitle,
            ),
            NavigationDestination(
              key: const Key('nav_branch_products'),
              icon: Icon(AppDestination.products.icon),
              selectedIcon: Icon(AppDestination.products.selectedIcon),
              label: l10n.productsTitle,
            ),
            NavigationDestination(
              key: const Key('nav_branch_quotations'),
              icon: Icon(AppDestination.quotations.icon),
              selectedIcon: Icon(AppDestination.quotations.selectedIcon),
              label: l10n.quotationsTitle,
            ),
            NavigationDestination(
              key: const Key('nav_branch_invoices'),
              icon: Icon(AppDestination.invoices.icon),
              selectedIcon: Icon(AppDestination.invoices.selectedIcon),
              label: l10n.invoicesTitle,
            ),
          ],
        ),
      ),
    );
  }
}
