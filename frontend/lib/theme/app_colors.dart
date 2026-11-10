import 'package:flutter/material.dart';

/// Color tokens from docs/design-guidelines.md ("Color palette").
///
/// This is the ONLY file in the codebase where hex color values may appear.
/// Widgets must reference these tokens (or derived tints below) and never
/// hard-code colors.
class AppColors {
  AppColors._();

  // ------------------------------------------------------------------
  // Palette (the only colors the UI may use).
  // ------------------------------------------------------------------

  /// Deep Blue - navigation (sidebar, top bar, footer), headings.
  static const Color deepBlue = Color(0xFF0B2545);

  /// Corporate Blue - primary actions, links, highlights, focus, selected nav.
  static const Color primary = Color(0xFF1D5FD1);

  /// Soft Gray - page background.
  static const Color background = Color(0xFFF4F6F9);

  /// White - cards, forms, tables, dialogs.
  static const Color surface = Color(0xFFFFFFFF);

  /// Charcoal - main body text.
  static const Color textPrimary = Color(0xFF1F2933);

  /// Charcoal 70% - secondary text, captions, table headers.
  static const Color textSecondary = Color(0xFF5B6670);

  /// Light border - dividers, card and input borders.
  static const Color border = Color(0xFFE1E6EC);

  /// Green - success messages, ACTIVE status.
  static const Color success = Color(0xFF15803D);

  /// Red - delete actions and errors ONLY.
  static const Color danger = Color(0xFFD92D20);

  // ------------------------------------------------------------------
  // Roles implied by the rules of use.
  // ------------------------------------------------------------------

  /// "Text and icons on Deep Blue or Corporate Blue are White."
  static const Color white = Color(0xFFFFFFFF);

  /// Invisible color (e.g. no-hover states). Not a visible palette color.
  static const Color transparent = Color(0x00000000);

  // ------------------------------------------------------------------
  // Derived tints.
  // "Tints (e.g. primary at 10% for a badge background) may be derived
  // from these tokens. No new hues."
  //
  // These are pre-computed blends of a palette color over white (or over
  // Deep Blue for the on-dark tints), expressed as const colors so they
  // can be used in const widget constructors. Tint strengths are chosen
  // so token text on its tint meets WCAG AA 4.5:1.
  // ------------------------------------------------------------------

  /// Corporate Blue at ~10% over white. Primary text on it: 5.03:1 (AA).
  static const Color primaryTint = Color(0xFFE8EFFA);

  /// Corporate Blue at ~18% over white, for borders of primary-tinted
  /// elements.
  static const Color primaryTintBorder = Color(0xFFD6E2F7);

  /// Green at ~8% over white. Success text on it: 4.52:1 (AA).
  static const Color successTint = Color(0xFFEDF5F0);

  /// Green at ~31% over white, for borders of success-tinted elements.
  static const Color successTintBorder = Color(0xFFB6D7C2);

  /// Red at ~10% over white. Danger text on it is 4.15:1, so it is used
  /// for icon/decoration chips only (WCAG 3:1 for graphics), never for
  /// danger body text - danger text goes on white surfaces.
  static const Color dangerTint = Color(0xFFFBEAE8);

  /// Subtle gray tint for table headers and neutral badges (on white
  /// surfaces this reads as the background token).
  static const Color neutralTint = background;

  /// Secondary text on Deep Blue: 70% white, 8.20:1 on deepBlue (AA).
  static const Color onDarkSubtle = Color(0xFFB6BEC8);

  /// Dividers / subtle borders on Deep Blue surfaces: 20% white.
  static const Color onDarkBorder = Color(0xFF3C516A);

  // ------------------------------------------------------------------
  // Gradients.
  // "Gradients: only subtle blends of Deep Blue and Corporate Blue
  // (landing hero, CTA banner)."
  // ------------------------------------------------------------------

  /// Subtle blend of Corporate Blue into Deep Blue for the landing hero.
  static LinearGradient get heroGradient => LinearGradient(
        colors: [primary.withAlpha(20), deepBlue.withAlpha(14)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  /// Deep Blue into Corporate Blue blend for the landing CTA banner.
  static const LinearGradient ctaGradient = LinearGradient(
        colors: [deepBlue, primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
