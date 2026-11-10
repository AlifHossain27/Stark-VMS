import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String routePath;
  final String? subtitle;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.routePath,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        padding: const EdgeInsets.all(AppSpacing.s32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s16),
              decoration: const BoxDecoration(
                color: AppColors.neutralTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.construction_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(title, style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.s8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s4,
              ),
              decoration: BoxDecoration(
                color: AppColors.neutralTint,
                borderRadius: BorderRadius.circular(AppRadius.input),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                routePath,
                style: AppTextStyles.label.copyWith(
                  fontFamily: 'monospace',
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              subtitle ??
                  'This section is part of the Stark Fleet Management System shell. The CRUD functionality will be connected here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppSpacing.s24),
            Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_outlined, size: 18),
                  label: const Text('Back to Landing'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.dashboard_outlined, size: 18),
                  label: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
