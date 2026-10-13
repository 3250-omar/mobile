import 'package:flutter/material.dart';
import 'package:offline_quotes/app/theme/tokens/app_spacing.dart';
import 'package:offline_quotes/shared/widgets/app_button.dart';
import 'package:offline_quotes/shared/widgets/app_card.dart';
import 'package:offline_quotes/shared/widgets/app_empty_state.dart';
import 'package:offline_quotes/shared/widgets/app_error_state.dart';
import 'package:offline_quotes/shared/widgets/app_loading_state.dart';
import 'package:offline_quotes/shared/widgets/app_text_field.dart';

/// Test showcase mounting all foundation design system components.
class FoundationComponentShowcase extends StatelessWidget {
  const FoundationComponentShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معرض المكونات الأساسية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أزرار النظام',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(label: 'زر أساسي', onPressed: () {}),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'زر ثانوي',
                    isSecondary: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: AppTextField(
                label: 'رمز المنتج (Bidi)',
                hintText: 'PRD-1024',
                isBidiIsolated: true,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: AppLoadingState(message: 'جاري تحميل البيانات...'),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: AppEmptyState(
                title: 'قائمة فارغة',
                message: 'لا توجد بيانات مسجلة حالياً',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: AppErrorState(
                title: 'حالة خطأ',
                message: 'تعذر حفظ السجل في قاعدة البيانات',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
