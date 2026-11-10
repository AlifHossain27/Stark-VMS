import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Status badge, mapped exactly from docs/design-guidelines.md:
///
/// | Status     | Background     | Text        |
/// |------------|----------------|-------------|
/// | ACTIVE     | success tint   | success     |
/// | INACTIVE   | neutral tint   | textPrimary |
/// | MAINTENANCE| primary tint   | primary     |
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final label = status.toUpperCase();

    final Color foreground;
    final Color background;
    final Color border;
    switch (label) {
      case 'ACTIVE':
        foreground = AppColors.success;
        background = AppColors.successTint;
        border = AppColors.successTintBorder;
        break;
      case 'MAINTENANCE':
        foreground = AppColors.primary;
        background = AppColors.primaryTint;
        border = AppColors.primaryTintBorder;
        break;
      case 'INACTIVE':
      default:
        foreground = AppColors.textPrimary;
        background = AppColors.neutralTint;
        border = AppColors.border;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
