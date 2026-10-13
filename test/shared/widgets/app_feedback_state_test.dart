import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/shared/widgets/app_empty_state.dart';
import 'package:offline_quotes/shared/widgets/app_error_state.dart';
import 'package:offline_quotes/shared/widgets/app_loading_state.dart';

void main() {
  group('App Feedback States', () {
    testWidgets('AppLoadingState displays message and progress indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLoadingState(message: 'جاري تحميل البيانات...'),
          ),
        ),
      );

      expect(find.text('جاري تحميل البيانات...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppEmptyState displays title, message and optional action', (
      tester,
    ) async {
      var actionTriggered = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              title: 'لا توجد فواتير',
              message: 'لم يتم إنشاء أي فواتير بعد.',
              actionLabel: 'إضافة فاتورة',
              onAction: () => actionTriggered = true,
            ),
          ),
        ),
      );

      expect(find.text('لا توجد فواتير'), findsOneWidget);
      expect(find.text('لم يتم إنشاء أي فواتير بعد.'), findsOneWidget);
      expect(find.text('إضافة فاتورة'), findsOneWidget);

      await tester.tap(find.text('إضافة فاتورة'));
      await tester.pump();
      expect(actionTriggered, isTrue);
    });

    testWidgets(
      'AppErrorState displays title, error message and retry action',
      (tester) async {
        var retried = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppErrorState(
                title: 'حدث خطأ',
                message: 'تعذر الاتصال بقاعدة البيانات.',
                onRetry: () => retried = true,
              ),
            ),
          ),
        );

        expect(find.text('حدث خطأ'), findsOneWidget);
        expect(find.text('تعذر الاتصال بقاعدة البيانات.'), findsOneWidget);
        expect(find.text('إعادة المحاولة'), findsOneWidget);

        await tester.tap(find.text('إعادة المحاولة'));
        await tester.pump();
        expect(retried, isTrue);
      },
    );
  });
}
