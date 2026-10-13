import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/app.dart';
import 'package:offline_quotes/app/bootstrap/initialization_controller.dart';
import 'package:offline_quotes/app/bootstrap/initialization_state.dart';
import 'package:offline_quotes/app/bootstrap/providers.dart';
import 'package:offline_quotes/features/home/presentation/home_screen.dart';
import 'package:offline_quotes/features/settings/domain/app_settings.dart';
import 'package:offline_quotes/features/settings/domain/settings_repository.dart';

import 'support/fake_dashboard_repository.dart';

class FakeSettingsRepo implements SettingsRepository {
  AppSettings current = AppSettings.defaults();

  @override
  Future<AppSettings> load() async => current;

  @override
  Stream<AppSettings> watch() => Stream.value(current);

  @override
  Future<AppSettings> setThemeMode(String mode) async {
    current = current.copyWith(themeMode: mode, revision: current.revision + 1);
    return current;
  }
}

void main() {
  testWidgets(
    'OfflineQuotesApp smoke test mounts and unmounts without network',
    (tester) async {
      final controller = InitializationController();
      controller.state = ApplicationInitializationState.ready(
        settings: AppSettings.defaults(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initializationControllerProvider.overrideWith((ref) => controller),
            settingsRepositoryProvider.overrideWithValue(FakeSettingsRepo()),
            dashboardRepositoryProvider.overrideWithValue(
              FakeDashboardRepository(),
            ),
          ],
          child: const OfflineQuotesApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}
