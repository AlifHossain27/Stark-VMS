import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'footer_link.dart';
import 'footer_link_data.dart';

class FooterLinkGroup extends StatelessWidget {
  final String title;
  final List<FooterLinkItem> links;

  const FooterLinkGroup({
    super.key,
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: AppColors.surface,
          ),
        ),
        const SizedBox(height: 14),
        ...links.map((link) => FooterLink(item: link)),
      ],
    );
  }
}

