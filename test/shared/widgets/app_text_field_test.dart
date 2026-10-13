import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/shared/widgets/app_text_field.dart';

void main() {
  group('AppTextField Widget', () {
    testWidgets(
      'renders label, hint and supports text entry with 48px target',
      (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AppTextField(
                  controller: controller,
                  label: 'اسم العميل',
                  hintText: 'أدخل الاسم هنا',
                ),
              ),
            ),
          ),
        );

        expect(find.text('اسم العميل'), findsOneWidget);
        expect(find.text('أدخل الاسم هنا'), findsOneWidget);

        final fieldFinder = find.byType(AppTextField);
        final size = tester.getSize(fieldFinder);
        expect(size.height, greaterThanOrEqualTo(48.0));

        await tester.enterText(fieldFinder, 'شركة النور');
        await tester.pump();
        expect(controller.text, equals('شركة النور'));
      },
    );

    testWidgets('renders validation error text and error styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppTextField(label: 'المبلغ', errorText: 'حقل مطلوب'),
            ),
          ),
        ),
      );

      expect(find.text('حقل مطلوب'), findsOneWidget);
    });
  });
}
