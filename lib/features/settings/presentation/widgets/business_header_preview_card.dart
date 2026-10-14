import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/localization/bidi_text.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../domain/business_profile.dart';

/// Live visual preview card of how the merchant's business header
/// will look on printed PDF quotations and invoices.
class BusinessHeaderPreviewCard extends StatelessWidget {
  const BusinessHeaderPreviewCard({super.key, required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'معاينة الترويسة المطبوعة',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.print_outlined,
                size: 18,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo thumbnail
              _buildLogoAvatar(context),
              const SizedBox(width: AppSpacing.md),

              // Business and contact details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.businessName.isNotEmpty
                          ? profile.businessName
                          : 'اسم المنشأة أو المحل',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (profile.ownerName != null &&
                        profile.ownerName!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'بإدارة: ${profile.ownerName!}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    if (profile.phonePrimary.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            BidiText.wrapLtr(profile.phonePrimary),
                            style: theme.textTheme.bodySmall,
                          ),
                          if (profile.phoneSecondary != null &&
                              profile.phoneSecondary!.trim().isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              BidiText.wrapLtr(profile.phoneSecondary!),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    if (profile.address != null || profile.city != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              [
                                if (profile.city != null &&
                                    profile.city!.isNotEmpty)
                                  profile.city,
                                if (profile.address != null &&
                                    profile.address!.isNotEmpty)
                                  profile.address,
                              ].join(' - '),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Legal credentials row if present
          if (profile.hasTaxCredentials) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (profile.commercialRegister != null &&
                    profile.commercialRegister!.isNotEmpty)
                  Text(
                    'س.ت: ${BidiText.wrapLtr(profile.commercialRegister!)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                if (profile.taxNumber != null && profile.taxNumber!.isNotEmpty)
                  Text(
                    'ب.ض: ${BidiText.wrapLtr(profile.taxNumber!)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogoAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final logoPath = profile.logoPath;

    if (logoPath != null && logoPath.isNotEmpty) {
      final file = File(logoPath);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildFallbackIcon(theme),
          ),
        );
      }
    }

    return _buildFallbackIcon(theme);
  }

  Widget _buildFallbackIcon(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.storefront_outlined,
        color: theme.colorScheme.outline,
        size: 28,
      ),
    );
  }
}
