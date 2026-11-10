import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

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
    final color = _isHovered ? Colors.white : AppColors.textMuted;

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white.withAlpha(16) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isHovered ? Colors.white.withAlpha(30) : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Back to top',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(width: 6),
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

