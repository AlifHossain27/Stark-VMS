import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens from docs/design-guidelines.md ("Typography").
///
/// Scale: display, h1, h2, h3, body, bodySmall, label.
/// Headings use deepBlue, body uses textPrimary, captions use textSecondary.
/// One font family across the app (the platform default; no custom family
/// is specified in the guidelines).
class AppTextStyles {
  AppTextStyles._();

  /// Hero/display headline.
  static const TextStyle display = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.deepBlue,
    letterSpacing: -1.0,
    height: 1.15,
  );

  /// Landing hero headline on the dark gradient (desktop).
  static const TextStyle heroDisplay = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    letterSpacing: -1.4,
    height: 1.08,
  );

  /// Landing hero supporting copy on the dark gradient.
  static const TextStyle heroLead = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.onDarkSubtle,
    height: 1.65,
  );

  /// Section headings, CTA banner title.
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.deepBlue,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Page headers ("Operations Command", "Fleet Directory").
  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.deepBlue,
    letterSpacing: -0.3,
    height: 1.25,
  );

  /// Card and dialog titles.
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.deepBlue,
    height: 1.3,
  );

  /// Main body text.
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Secondary body text and descriptions (caption color per guidelines).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Captions, table headers, field labels and badge text.
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Button labels (component text style; button themes own the colors).
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.4,
  );

  /// Micro captions for dense badges and the landing illustration.
  /// The guidelines name the scale but not the sizes; this keeps the
  /// 10px caption size already used by those elements.
  static const TextStyle micro = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
    height: 1.4,
  );
}
