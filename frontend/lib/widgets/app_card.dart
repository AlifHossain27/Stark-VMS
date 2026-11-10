import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared card container from docs/design-guidelines.md:
/// "Cards, forms, tables and dialogs are White with a 1px border and a
/// soft shadow" and "Radius: ... 16 for cards".
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s24),
    this.margin,
    this.boxShadow,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: border ?? Border.all(color: AppColors.border),
        boxShadow: boxShadow ?? AppShadows.card,
      ),
      child: child,
    );
  }
}
