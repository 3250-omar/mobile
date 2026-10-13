import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/navigation/route_names.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';

/// Foundational root screen for Settings, allowing transactional theme selection
/// and showing offline status.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsControllerProvider);
    final backupState = ref.watch(backupRestoreControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              l10n.settingsThemeSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            settingsAsync.when(
              data: (settings) {
                return AppCard(
                  padding: EdgeInsets.zero,
                  child: RadioGroup<String>(
                    groupValue: settings.themeMode,
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .setThemeMode(val);
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          key: const Key('theme_mode_system'),
                          title: Text(l10n.themeModeSystem),
                          value: 'system',
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          key: const Key('theme_mode_light'),
                          title: Text(l10n.themeModeLight),
                          value: 'light',
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          key: const Key('theme_mode_dark'),
                          title: Text(l10n.themeModeDark),
                          value: 'dark',
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'حدث خطأ أثناء تحميل الإعدادات',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.backupTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                key: const Key('settings_backup_tile'),
                leading: const Icon(Icons.backup_outlined),
                title: Text(l10n.backupTitle),
                subtitle: Text(
                  backupState.lastBackupAt != null
                      ? '${l10n.backupLastDate}: ${backupState.lastBackupAt!.day}/${backupState.lastBackupAt!.month}/${backupState.lastBackupAt!.year}'
                      : l10n.backupNever,
                ),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => context.push(RouteNames.backupPath),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.settingsAboutSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.appVersion),
                    subtitle: Text(l10n.offlineStatus),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.settingsLanguageSection),
                    subtitle: Text(l10n.languageArabic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
