import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class BackToTopButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const BackToTopButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? AppColors.white : AppColors.onDarkSubtle;

    return Semantics(
      label: 'Scroll back to the top of the page',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.white.withAlpha(16) : AppColors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(
                color: _isHovered ? AppColors.onDarkBorder : AppColors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Back to top',
                  style: AppTextStyles.label.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 15,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
