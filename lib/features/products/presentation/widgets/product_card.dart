import 'package:flutter/material.dart';

import '../../../../app/localization/bidi_text.dart';
import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_shapes.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/product.dart';

/// Reusable card displaying an individual plumbing catalog product.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: onTap ?? onEdit,
        borderRadius: AppShapes.roundedMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Code badge + category + action menu
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isDark
                                  ? AppColors.darkAction
                                  : AppColors.lightAction)
                              .withValues(alpha: 0.12),
                      borderRadius: AppShapes.roundedSm,
                    ),
                    child: Text(
                      BidiText.wrapLtr(product.code),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkAction
                            : AppColors.lightAction,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    product.category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkMutedText
                          : AppColors.lightMutedText,
                    ),
                  ),
                  const Spacer(),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (val) {
                        if (val == 'edit') onEdit?.call();
                        if (val == 'delete') onDelete?.call();
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('تعديل'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'حذف',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Product Name
              Text(
                product.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Bottom row: Unit and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الوحدة: ${product.unit}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkMutedText
                          : AppColors.lightMutedText,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        product.formattedPriceEgp,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkAction
                              : AppColors.lightAction,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ج.م',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
