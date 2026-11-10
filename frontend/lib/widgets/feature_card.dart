import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isComingSoon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isComingSoon = false,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: _isHovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(AppSpacing.s8),
                  decoration: BoxDecoration(
                    color: _isHovered ? AppColors.primary : AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(AppRadius.input),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: _isHovered ? AppColors.white : AppColors.primary,
                  ),
                ),
                const Spacer(),
                if (widget.isComingSoon)
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
                      'Coming soon',
                      style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s8,
                      vertical: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successTint,
                      borderRadius: BorderRadius.circular(AppRadius.input),
                      border: Border.all(color: AppColors.successTintBorder),
                    ),
                    child: Text(
                      'Active',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(widget.title, style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.s4),
            Expanded(
              child: Text(
                widget.description,
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
