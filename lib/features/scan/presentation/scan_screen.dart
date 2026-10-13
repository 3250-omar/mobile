import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/bootstrap/providers.dart';
import '../../../app/navigation/route_names.dart';
import '../domain/scanned_line_item.dart';

/// Main screen for acquiring plumbing requisition slips via camera or gallery.
class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanControllerProvider);
    final scanController = ref.read(scanControllerProvider.notifier);
    final theme = Theme.of(context);

    // Auto-navigate to review screen if recognition completed
    ref.listen(scanControllerProvider, (previous, next) {
      if (next.status == ScanSessionStatus.review &&
          next.items.isNotEmpty &&
          previous?.status != ScanSessionStatus.review) {
        try {
          context.pushNamed(RouteNames.scanReview);
        } catch (_) {
          // In isolated unit/widget tests without GoRouter harness
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('المسح الضوئي وخط اليد'),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Offline guarantee badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.offline_pin, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'التعرف الضوئي يعمل بالكامل على جهازك (100% بدون إنترنت)',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Image preview or upload box
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: scanState.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(scanState.imagePath!),
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Center(
                                  child: Icon(
                                    Icons.receipt_long,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              if (scanState.isLoading)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          scanState.status ==
                                                  ScanSessionStatus
                                                      .processingOcr
                                              ? 'جاري استخراج النصوص من الورقة...'
                                              : 'جاري مطابقة الأصناف مع الكتالوج...',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.document_scanner,
                                size: 72,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'مسح ورقة طلبات أو مقايسة سباكة',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  'التقط صورة لورقة السباك المكتوبة بخط اليد لاستخراج الأصناف والكميات ومطابقتها تلقائياً.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              if (scanState.errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          scanState.errorMessage!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Action buttons
              if (scanState.items.isNotEmpty && !scanState.isLoading) ...[
                FilledButton.icon(
                  icon: const Icon(Icons.playlist_add_check),
                  label: Text(
                    'عرض الأصناف المستخرجة (${scanState.items.length})',
                  ),
                  onPressed: () => context.pushNamed(RouteNames.scanReview),
                ),
                const SizedBox(height: 8),
              ],

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('اختيار من المعرض'),
                      onPressed: scanState.isLoading
                          ? null
                          : () => scanController.pickImageAndProcess(
                              fromCamera: false,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('التقاط صورة'),
                      onPressed: scanState.isLoading
                          ? null
                          : () => scanController.pickImageAndProcess(
                              fromCamera: true,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
