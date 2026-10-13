import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Card displaying backup creation action and last backup date.
class BackupCard extends StatelessWidget {
  const BackupCard({
    super.key,
    required this.lastBackupAt,
    required this.isBusy,
    required this.onCreateBackup,
  });

  final DateTime? lastBackupAt;
  final bool isBusy;
  final VoidCallback onCreateBackup;

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final isOld =
        lastBackupAt == null ||
        DateTime.now().difference(lastBackupAt!).inDays >= 7;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_download_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.backupSectionExport,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lastBackupAt != null
                            ? '${l10n.backupLastDate}: ${_formatDateTime(lastBackupAt!)}'
                            : l10n.backupNever,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOld
                              ? Colors.orange.shade800
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: isOld
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'يقوم بحفظ وتأمين كامل بيانات الكتالوج وعروض الأسعار والفواتير في ملف محلي مشفر ومحمي برمز تحقق SHA-256.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isBusy ? null : onCreateBackup,
              icon: isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.archive_outlined),
              label: Text(l10n.backupCreateButton),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
