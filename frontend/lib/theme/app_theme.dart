import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Material 3 theme built ONLY from the tokens in lib/theme/
/// (docs/design-guidelines.md is the source of truth).
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = _colorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // -------------------------------------------------------------
      // Typography
      // -------------------------------------------------------------
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display,
        displayMedium: AppTextStyles.display,
        displaySmall: AppTextStyles.h1,
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        titleLarge: AppTextStyles.h3,
        titleMedium: AppTextStyles.body,
        titleSmall: AppTextStyles.bodySmall,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySmall,
        bodySmall: AppTextStyles.label,
        labelLarge: AppTextStyles.label,
        labelMedium: AppTextStyles.label,
        labelSmall: AppTextStyles.label,
      ),

      // -------------------------------------------------------------
      // Buttons: Filled (primary), Outlined (secondary), Text.
      // ElevatedButton is themed identically to Filled because the
      // existing screens use it; it renders as the "Filled (primary)"
      // button from the guidelines. Destructive is a dedicated widget.
      // -------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primaryTint,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primaryTint,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.border, width: 1.2),
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
        ),
      ),

      // -------------------------------------------------------------
      // Inputs: white fill, border token, primary focus border,
      // danger error border, error text in danger.
      // -------------------------------------------------------------
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s12,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.primary, width: 1.5),
        errorBorder: _inputBorder(AppColors.danger),
        focusedErrorBorder: _inputBorder(AppColors.danger, width: 1.5),
        hintStyle: AppTextStyles.bodySmall,
        helperStyle: AppTextStyles.label.copyWith(letterSpacing: 0.2),
        errorStyle: AppTextStyles.label.copyWith(
          color: AppColors.danger,
          letterSpacing: 0.2,
        ),
      ),

      // -------------------------------------------------------------
      // Cards: white surface, 1px border, radius 16, soft shadow.
      // -------------------------------------------------------------
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // -------------------------------------------------------------
      // Tables: white surface, header row in textSecondary on a subtle
      // gray tint, row dividers, hover highlight.
      // -------------------------------------------------------------
      dataTableTheme: DataTableThemeData(
        headingRowColor: const WidgetStatePropertyAll(AppColors.neutralTint),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primaryTint;
          }
          return AppColors.surface;
        }),
        headingTextStyle: AppTextStyles.label.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w800,
        ),
        dataTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        dividerThickness: 1,
      ),

      // -------------------------------------------------------------
      // Navigation surfaces use Deep Blue with white text.
      // -------------------------------------------------------------
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.deepBlue,
        foregroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: AppTextStyles.h3.copyWith(color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: AppColors.deepBlue,
        surfaceTintColor: AppColors.transparent,
        indicatorColor: AppColors.primary,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.deepBlue,
        surfaceTintColor: AppColors.transparent,
      ),

      // -------------------------------------------------------------
      // Dialogs: white surface, 1px border, radius 16, soft shadow.
      // -------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: 4,
        shadowColor: AppColors.deepBlue.withAlpha(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border),
        ),
        titleTextStyle: AppTextStyles.h3,
        contentTextStyle: AppTextStyles.body,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // -------------------------------------------------------------
      // Snackbars: success uses success, failure uses danger (set per
      // snackbar); plain informational snackbars use Deep Blue.
      // -------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBlue,
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.white),
        actionTextColor: AppColors.white,
        actionBackgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
      ),

      // -------------------------------------------------------------
      // Chips (filter pills): neutral tint, border, radius 8;
      // selected = primary fill.
      // -------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutralTint,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        labelStyle: AppTextStyles.label,
        selectedColor: AppColors.primary,
        checkmarkColor: AppColors.white,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
      ),

      // -------------------------------------------------------------
      // Misc component defaults.
      // -------------------------------------------------------------
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primaryTint,
        selectionHandleColor: AppColors.primary,
      ),
    );
  }

  /// Explicit ColorScheme from the palette tokens.
  static final ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryTint,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.deepBlue,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.neutralTint,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.success,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.successTint,
    onTertiaryContainer: AppColors.success,
    error: AppColors.danger,
    onError: AppColors.white,
    errorContainer: AppColors.dangerTint,
    onErrorContainer: AppColors.danger,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.border,
    shadow: AppColors.deepBlue,
    scrim: AppColors.deepBlue,
    inverseSurface: AppColors.deepBlue,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.white,
    surfaceTint: AppColors.primary,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.neutralTint,
    surfaceContainerHigh: AppColors.neutralTint,
    surfaceContainerHighest: AppColors.neutralTint,
  );

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
