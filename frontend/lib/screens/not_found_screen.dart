import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(AppSpacing.s32),
          margin: const EdgeInsets.all(AppSpacing.s24),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.dangerTint,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
                child: Text(
                  '404 ERROR',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Page Not Found',
                style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                'The URL you requested does not exist or may have been moved. Return to the Stark Fleet Portal home page.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.s24),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
