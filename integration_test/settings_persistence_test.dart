import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/settings/presentation/settings_screen.dart';
import 'package:offline_quotes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'persists theme mode changes to database and survives navigation',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // From Home, open Settings
      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.tap(find.byKey(const Key('shell_settings_button')));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);

      // Change to Dark Mode
      await tester.tap(find.byKey(const Key('theme_mode_dark')));
      await tester.pumpAndSettle();

      // Pop back to Home
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Reopen Settings to verify dark mode persisted
      await tester.tap(find.byKey(const Key('shell_settings_button')));
      await tester.pumpAndSettle();

      final radioGroup = tester.widget<RadioGroup<String>>(
        find.byType(RadioGroup<String>),
      );
      expect(radioGroup.groupValue, equals('dark'));
    },
  );
}
