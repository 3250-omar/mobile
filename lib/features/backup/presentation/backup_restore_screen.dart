import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/backup_result.dart';
import 'widgets/backup_card.dart';
import 'widgets/password_prompt_dialog.dart';
import 'widgets/restore_card.dart';

/// Full screen for managing local backup export and validated restoration.
class BackupRestoreScreen extends ConsumerWidget {
  const BackupRestoreScreen({super.key});

  Future<void> _handleCreateBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Prompt for optional password
    final password = await showDialog<String?>(
      context: context,
      builder: (ctx) => const PasswordPromptDialog(
        title: 'حماية النسخة الاحتياطية',
        message: 'يمكنك اختيار كلمة مرور لحماية ملف النسخة الاحتياطية وتشفير الأسعار والمبيعات، أو تركها فارغة للنسخ المباشر.',
        isOptional: true,
      ),
    );

    final result = await ref
        .read(backupRestoreControllerProvider.notifier)
        .createBackup(password: password);

    if (result != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${l10n.backupSuccess}\nالمسار: ${result.filePath}'),
          backgroundColor: Colors.green.shade800,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _handlePickAndRestore(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    final files = await FilePicker.pickFiles(type: FileType.any);

    if (files.isEmpty || files.first.path == null) {
      return;
    }

    final filePath = files.first.path!;
    final controller = ref.read(backupRestoreControllerProvider.notifier);

    // 1. Initial validation
    var validation = await controller.validateBackupFile(filePath);

    String? password;
    if (validation.error == RestoreValidationError.passwordRequired ||
        validation.error == RestoreValidationError.invalidPassword) {
      if (!context.mounted) return;
      password = await showDialog<String?>(
        context: context,
        builder: (ctx) => const PasswordPromptDialog(
          title: 'فك تشفير النسخة الاحتياطية',
          message:
              'هذا الملف محمي بكلمة مرور. يرجى إدخال كلمة المرور للمتابعة.',
          isOptional: false,
        ),
      );

      if (password == null) return;
      validation = await controller.validateBackupFile(
        filePath,
        password: password,
      );
    }

    if (!validation.isValid || validation.metadata == null) {
      final errorMsg =
          validation.error?.arabicDescription ??
          'تعذر قراءة ملف النسخة الاحتياطية';
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('خطأ: $errorMsg'), backgroundColor: errorColor),
      );
      return;
    }

    // 2. Confirmation dialog showing contents
    final meta = validation.metadata!;
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد استعادة النسخة الاحتياطية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تم التحقق من سلامة الملف ورمز SHA-256 بنجاح.\nستتم استعادة البيانات التالية:',
            ),
            const SizedBox(height: 12),
            Text('• الأصناف: ${meta.totalProductsCount} صنف'),
            Text('• عروض الأسعار: ${meta.totalQuotationsCount} عرض'),
            Text('• الفواتير: ${meta.totalInvoicesCount} فاتورة'),
            const SizedBox(height: 16),
            const Text(
              'تحذير: سيتم استبدال البيانات الحالية. هل ترغب في المتابعة؟',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'تأكيد الاستعادة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await controller.restoreBackup(
        filePath,
        password: password,
      );
      if (success) {
        // Refresh dashboard metrics
        await ref.read(dashboardControllerProvider.notifier).refresh();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.restoreSuccess),
            backgroundColor: Colors.green.shade800,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(backupRestoreControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle), centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isBusy && state.currentStage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            state.currentStage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 1. Local Backup Card
              BackupCard(
                lastBackupAt: state.lastBackupAt,
                isBusy: state.isBusy,
                onCreateBackup: () => _handleCreateBackup(context, ref),
              ),
              const SizedBox(height: 20),

              // 2. Local Restore Card
              RestoreCard(
                isBusy: state.isBusy,
                onPickAndRestore: () => _handlePickAndRestore(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
