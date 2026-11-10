import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import 'footer_link_data.dart';

class FooterLink extends StatefulWidget {
  final FooterLinkItem item;

  const FooterLink({
    super.key,
    required this.item,
  });

  @override
  State<FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<FooterLink> {
  bool _isHovered = false;
  bool _isFocused = false;

  void _handleTap() {
    if (widget.item.isSoon) return;

    if (widget.item.onCustomTap != null) {
      widget.item.onCustomTap!();
      return;
    }

    if (widget.item.route != null) {
      context.go(widget.item.route!);
      return;
    }

    if (widget.item.externalUrl != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('External Link: ${widget.item.externalUrl}'),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSoon = widget.item.isSoon;

    if (isSoon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.item.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted.withAlpha(160),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withAlpha(24)),
              ),
              child: const Text(
                'Soon',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final textColor = _isHovered || _isFocused
        ? Colors.white
        : AppColors.textMuted;

    return FocusableActionDetector(
      onShowFocusHighlight: (val) => setState(() => _isFocused = val),
      onShowHoverHighlight: (val) => setState(() => _isHovered = val),
      mouseCursor: SystemMouseCursors.click,
      actions: {
        ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => _handleTap()),
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.item.icon != null) ...[
                  Icon(
                    widget.item.icon,
                    size: 14,
                    color: textColor,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationThickness: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
