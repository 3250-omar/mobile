import 'package:flutter/material.dart';

import 'route_names.dart';

/// Foundational application destinations.
enum AppDestination {
  home(
    routeName: RouteNames.home,
    path: RouteNames.homePath,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    isBranch: true,
  ),
  products(
    routeName: RouteNames.products,
    path: RouteNames.productsPath,
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    isBranch: true,
  ),
  quotations(
    routeName: RouteNames.quotations,
    path: RouteNames.quotationsPath,
    icon: Icons.request_quote_outlined,
    selectedIcon: Icons.request_quote,
    isBranch: true,
  ),
  invoices(
    routeName: RouteNames.invoices,
    path: RouteNames.invoicesPath,
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    isBranch: true,
  ),
  scan(
    routeName: RouteNames.scan,
    path: RouteNames.scanPath,
    icon: Icons.document_scanner_outlined,
    selectedIcon: Icons.document_scanner,
    isBranch: false,
  ),
  settings(
    routeName: RouteNames.settings,
    path: RouteNames.settingsPath,
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    isBranch: false,
  );

  const AppDestination({
    required this.routeName,
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.isBranch,
  });

  final String routeName;
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final bool isBranch;

  static List<AppDestination> get shellBranches =>
      values.where((d) => d.isBranch).toList();
}
