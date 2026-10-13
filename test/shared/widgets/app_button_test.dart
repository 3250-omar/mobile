import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/shared/widgets/app_button.dart';

void main() {
  group('AppButton Widget', () {
    testWidgets('renders label and respects minimum 48px touch target', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(label: 'حفظ', onPressed: () {}),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);
      final size = tester.getSize(buttonFinder);
      expect(size.height, greaterThanOrEqualTo(48.0));
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(find.text('حفظ'), findsOneWidget);
    });

    testWidgets('handles disabled state without invoking callback', (
      tester,
    ) async {
      var invoked = false;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: AppButton(label: 'معطل', onPressed: null)),
          ),
        ),
      );

      await tester.tap(find.text('معطل'));
      await tester.pump();
      expect(invoked, isFalse);
    });

    testWidgets(
      'shows loading spinner and disables click when isLoading is true',
      (tester) async {
        var invoked = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AppButton(
                  label: 'جاري التحميل',
                  isLoading: true,
                  onPressed: () => invoked = true,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.tap(find.byType(AppButton));
        await tester.pump();
        expect(invoked, isFalse);
      },
    );
  });
}
