import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Page header used by dashboard/directory screens: an AppCard with a
/// deepBlue h2 title, a textSecondary subtitle and an optional actions
/// slot (row on desktop, stacked on narrow screens).
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? actions;
  final Widget? trailing;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    final titleRow = Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTextStyles.h2,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.s12),
          Flexible(child: trailing!),
        ],
      ],
    );

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleRow,
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(subtitle!, style: AppTextStyles.bodySmall),
        ],
      ],
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(child: textColumn),
                ?actions,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textColumn,
                if (actions != null) ...[
                  const SizedBox(height: AppSpacing.s16),
                  actions!,
                ],
              ],
            ),
    );
  }
}
