import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import 'bootstrap/bootstrap_gate.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

/// Root application widget configuring routing, Arabic localization,
/// bootstrap gating, and theme integration.
class OfflineQuotesApp extends ConsumerWidget {
  const OfflineQuotesApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = router ?? createAppRouter();
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      title: 'عروض الأسعار والفواتير',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      builder: (context, child) {
        return BootstrapGate(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
