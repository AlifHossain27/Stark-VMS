import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Spacing, radius and shadow tokens from docs/design-guidelines.md
/// ("Spacing, shape, elevation").
///
/// Widgets must use these tokens instead of magic numbers.
class AppSpacing {
  AppSpacing._();

  /// Spacing scale: 4, 8, 12, 16, 24, 32, 48.
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
}

/// Radius tokens: 8 for inputs and buttons, 16 for cards.
class AppRadius {
  AppRadius._();

  /// Inputs, buttons and badges.
  static const double input = 8;

  /// Cards and dialogs.
  static const double card = 16;
}

/// Shadow tokens: "one soft card shadow, one elevated hover shadow".
/// Shadows are Deep Blue tints so no new hues enter the palette.
class AppShadows {
  AppShadows._();

  /// The one soft card shadow.
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.deepBlue.withAlpha(14),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// The one elevated hover shadow (also used for dialogs).
  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: AppColors.deepBlue.withAlpha(26),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}
