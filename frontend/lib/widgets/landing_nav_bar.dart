import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Landing page top navigation. Deep Blue navigation surface with white
/// text ("Deep Blue: sidebar, top navigation, footer"); the frosted-glass
/// blur on scroll is kept from the existing design.
class LandingNavBar extends StatelessWidget {
  /// Bar height, exposed so the landing screen can clear it below the
  /// sticky header.
  static const double height = 68;

  final bool isScrolled;
  final VoidCallback onScrollToFeatures;
  final VoidCallback onScrollToHowItWorks;

  const LandingNavBar({
    super.key,
    required this.isScrolled,
    required this.onScrollToFeatures,
    required this.onScrollToHowItWorks,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 12 : 0,
          sigmaY: isScrolled ? 12 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? AppSpacing.s32 : AppSpacing.s16),
          decoration: BoxDecoration(
            color: isScrolled
                ? AppColors.deepBlue.withAlpha(235)
                : AppColors.deepBlue.withAlpha(204),
            border: Border(
              bottom: BorderSide(
                color: isScrolled ? AppColors.onDarkBorder : AppColors.transparent,
                width: 1,
              ),
            ),
            boxShadow: isScrolled ? AppShadows.card : const [],
          ),
          child: Row(
            children: [
              // Wordmark & Logo
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                    child: const Icon(
                      Icons.directions_boat_filled,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    'STARK VMS',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Navigation Links (Desktop)
              if (isDesktop) ...[
                TextButton(
                  onPressed: onScrollToFeatures,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                  ),
                  child: Text(
                    'Features',
                    style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: onScrollToHowItWorks,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                  ),
                  child: Text(
                    'How It Works',
                    style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
              ],

              // CTA Button (white fill + primary text on the Deep Blue bar;
              // the filled Corporate Blue primary stays reserved for the
              // hero section's single primary action)
              ElevatedButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.dashboard_rounded, size: 16),
                label: const Text('Open Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? AppSpacing.s16 : AppSpacing.s12,
                    vertical: AppSpacing.s12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
