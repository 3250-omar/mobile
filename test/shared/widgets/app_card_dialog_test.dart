import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/shared/widgets/app_card.dart';
import 'package:offline_quotes/shared/widgets/app_confirmation_dialog.dart';

void main() {
  group('AppCard and AppConfirmationDialog', () {
    testWidgets('AppCard renders child and honors decoration and margin', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: AppCard(child: Text('محتوى البطاقة'))),
          ),
        ),
      );

      expect(find.text('محتوى البطاقة'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets(
      'AppConfirmationDialog renders title, message, confirm and cancel buttons',
      (tester) async {
        var confirmed = false;
        var cancelled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => AppConfirmationDialog(
                          title: 'تأكيد الحذف',
                          message: 'هل أنت متأكد من الحذف؟',
                          confirmLabel: 'حذف',
                          cancelLabel: 'إلغاء',
                          isDestructive: true,
                          onConfirm: () => confirmed = true,
                          onCancel: () => cancelled = true,
                        ),
                      );
                    },
                    child: const Text('افتح الحوار'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('افتح الحوار'));
        await tester.pumpAndSettle();

        expect(find.text('تأكيد الحذف'), findsOneWidget);
        expect(find.text('هل أنت متأكد من الحذف؟'), findsOneWidget);
        expect(find.text('حذف'), findsOneWidget);
        expect(find.text('إلغاء'), findsOneWidget);

        await tester.tap(find.text('حذف'));
        await tester.pumpAndSettle();
        expect(confirmed, isTrue);
        expect(cancelled, isFalse);
      },
    );
  });
}
