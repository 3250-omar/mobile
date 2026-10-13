import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/invoices/presentation/invoices_screen.dart';
import 'package:offline_quotes/features/products/presentation/products_screen.dart';
import 'package:offline_quotes/features/quotations/presentation/quotations_screen.dart';
import 'package:offline_quotes/features/scan/presentation/scan_screen.dart';
import 'package:offline_quotes/features/settings/presentation/settings_screen.dart';
import 'package:offline_quotes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Integration Tests', () {
    testWidgets('visit six destinations and back hierarchy', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Start at Home
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Products
      await tester.tap(find.byKey(const Key('nav_branch_products')));
      await tester.pumpAndSettle();
      expect(find.byType(ProductsScreen), findsOneWidget);

      // Navigate to Quotations
      await tester.tap(find.byKey(const Key('nav_branch_quotations')));
      await tester.pumpAndSettle();
      expect(find.byType(QuotationsScreen), findsOneWidget);

      // Navigate to Invoices
      await tester.tap(find.byKey(const Key('nav_branch_invoices')));
      await tester.pumpAndSettle();
      expect(find.byType(InvoicesScreen), findsOneWidget);

      // Open Scan root route
      await tester.tap(find.byKey(const Key('shell_scan_fab')));
      await tester.pumpAndSettle();
      expect(find.byType(ScanScreen), findsOneWidget);

      // Back from Scan returns to Invoices
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(InvoicesScreen), findsOneWidget);

      // Open Settings root route
      await tester.tap(find.byKey(const Key('shell_settings_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      // Back from Settings returns to Invoices
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(InvoicesScreen), findsOneWidget);

      // Switch back to Home
      await tester.tap(find.byKey(const Key('nav_branch_home')));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('platform back hierarchy assertion', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Conditional platform execution
      final isAndroid = !kIsWeb && Platform.isAndroid;
      final isIOS = !kIsWeb && Platform.isIOS;

      if (!isAndroid && !isIOS) {
        // Host environment: confirm home screen is present and exit gracefully
        expect(find.byType(HomeScreen), findsOneWidget);
        return;
      }

      // On Android/iOS device: test overlay / back navigation flow
      await tester.tap(find.byKey(const Key('shell_scan_fab')));
      await tester.pumpAndSettle();
      expect(find.byType(ScanScreen), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
