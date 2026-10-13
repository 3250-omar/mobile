import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/bootstrap_gate.dart';
import 'package:offline_quotes/app/bootstrap/initialization_controller.dart';
import 'package:offline_quotes/app/bootstrap/initialization_state.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/core/errors/app_failure.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/l10n/app_localizations.dart';

import '../../support/fake_dashboard_repository.dart';

void main() {
  Widget buildTestApp({required InitializationController controller}) {
    return ProviderScope(
      overrides: [
        initializationControllerProvider.overrideWith((ref) => controller),
        dashboardRepositoryProvider
            .overrideWithValue(FakeDashboardRepository()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ar'),
        home: BootstrapGate(child: HomeScreen()),
      ),
    );
  }

  group('Offline Startup', () {
    testWidgets('shows Arabic loading gate while initializing', (tester) async {
      final controller = InitializationController();
      controller.state = ApplicationInitializationState.initializing(
        stage: InitializationStage.database,
        attemptId: 'ATTEMPT_1',
        startTime: DateTime.now(),
      );

      await tester.pumpWidget(buildTestApp(controller: controller));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('فتح قاعدة البيانات المحلية...'), findsOneWidget);
    });

    testWidgets('renders HomeScreen when initialization reaches ready', (
      tester,
    ) async {
      final controller = InitializationController();
      controller.state = ApplicationInitializationState.ready(
        settings: AppSettings.defaults(),
      );

      await tester.pumpWidget(buildTestApp(controller: controller));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('عروض الأسعار والفواتير'), findsOneWidget);
      expect(find.text('100% دون إنترنت'), findsOneWidget);
    });

    testWidgets('displays Arabic error gate and retry button on failure', (
      tester,
    ) async {
      final controller = InitializationController();
      controller.state = const ApplicationInitializationState.failed(
        failure: AppFailure(
          code: 'DB_OPEN_FAILED',
          messageKey: 'errorDatabase',
          category: AppFailureCategory.storage,
          retryable: true,
          diagnosticReference: 'ATTEMPT_FAIL_1',
        ),
        attemptId: 'ATTEMPT_FAIL_1',
      );

      await tester.pumpWidget(buildTestApp(controller: controller));

      expect(find.text('تعذر بدء التطبيق'), findsOneWidget);
      expect(
        find.text(
          'تعذر فتح قاعدة البيانات المحلية بأمان. تم الحفاظ على ملفاتك دون تعديل.',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('bootstrap_retry_button')), findsOneWidget);
    });
  });
}
