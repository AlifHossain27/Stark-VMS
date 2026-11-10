import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Destructive button from docs/design-guidelines.md:
/// "Buttons: Filled (primary), Outlined (secondary), Text,
/// Destructive (danger, delete only)."
/// Use ONLY for delete actions.
class DestructiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget label;
  final IconData? icon;

  const DestructiveButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: AppColors.danger,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.dangerTint,
      disabledForegroundColor: AppColors.white,
    );

    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, size: 16),
        label: label,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: label,
    );
  }
}
