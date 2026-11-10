import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class LandingNavBar extends StatelessWidget {
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
          height: 68,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16),
          decoration: BoxDecoration(
            color: isScrolled
                ? Colors.white.withAlpha(225)
                : Colors.white.withAlpha(80),
            border: Border(
              bottom: BorderSide(
                color: isScrolled ? AppColors.border : Colors.transparent,
                width: 1,
              ),
            ),
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // Wordmark & Logo
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.directions_boat_filled,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'STARK VMS',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: AppColors.textPrimary,
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
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('Features', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: onScrollToHowItWorks,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('How It Works', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
              ],

              // CTA Button
              ElevatedButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.dashboard_rounded, size: 16),
                label: const Text('Open Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 18 : 12,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
