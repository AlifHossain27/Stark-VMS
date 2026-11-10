import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../vehicle_form_dialog.dart';
import 'back_to_top_button.dart';
import 'footer_link_data.dart';
import 'footer_link_group.dart';

class SiteFooter extends StatelessWidget {
  final VoidCallback? onBackToTop;

  const SiteFooter({
    super.key,
    this.onBackToTop,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isMobile = screenWidth < 600;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final productLinks = FooterLinkData.getProductLinks(
      onOpenRegisterModal: () => VehicleFormDialog.show(context),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Thin Accent Gradient Top Line
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.accent,
                AppColors.tealAccent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        // 2. Main Footer Body
        Container(
          color: AppColors.primaryDark,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : (isTablet ? 32 : 20),
            vertical: isDesktop ? 64 : 40,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Columns Section
                  if (isDesktop)
                    _buildDesktopColumns(context, productLinks)
                  else if (isTablet)
                    _buildTabletColumns(context, productLinks)
                  else
                    _buildMobileColumns(context, productLinks),

                  const SizedBox(height: 48),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.white.withAlpha(20),
                  ),
                  const SizedBox(height: 24),

                  // 3. Bottom Bar
                  _buildBottomBar(isMobile),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (reduceMotion) {
      return content;
    }

    return content
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400), curve: Curves.easeOut)
        .slideY(begin: 0.04, end: 0, duration: const Duration(milliseconds: 400));
  }

  Widget _buildBrandBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wordmark & Icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_boat_filled,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'STARK VMS',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: const Text(
            'Enterprise fleet control, vehicle asset tracking, and compliance management portal built for Stark Group.',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.dashboard_outlined, size: 16),
          label: const Text('Open Dashboard'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withAlpha(50)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopColumns(BuildContext context, List<FooterLinkItem> productLinks) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: _buildBrandBlock(context),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 2,
          child: FooterLinkGroup(
            title: 'Product',
            links: productLinks,
          ),
        ),
        const SizedBox(width: 32),
        const Expanded(
          flex: 3,
          child: FooterLinkGroup(
            title: 'Features',
            links: FooterLinkData.featureLinks,
          ),
        ),
        const SizedBox(width: 32),
        const Expanded(
          flex: 3,
          child: FooterLinkGroup(
            title: 'Resources',
            links: FooterLinkData.resourceLinks,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletColumns(BuildContext context, List<FooterLinkItem> productLinks) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBrandBlock(context)),
            const SizedBox(width: 32),
            Expanded(
              child: FooterLinkGroup(
                title: 'Product',
                links: productLinks,
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FooterLinkGroup(
                title: 'Features',
                links: FooterLinkData.featureLinks,
              ),
            ),
            SizedBox(width: 32),
            Expanded(
              child: FooterLinkGroup(
                title: 'Resources',
                links: FooterLinkData.resourceLinks,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileColumns(BuildContext context, List<FooterLinkItem> productLinks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandBlock(context),
        const SizedBox(height: 36),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FooterLinkGroup(
                title: 'Product',
                links: productLinks,
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(
              child: FooterLinkGroup(
                title: 'Features',
                links: FooterLinkData.featureLinks,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const FooterLinkGroup(
          title: 'Resources',
          links: FooterLinkData.resourceLinks,
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    final year = DateTime.now().year;
    final copyrightText = '© $year Stark Group VMS.';

    if (isMobile) {
      return Column(
        children: [
          Text(
            copyrightText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          BackToTopButton(onPressed: onBackToTop),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          copyrightText,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        BackToTopButton(onPressed: onBackToTop),
      ],
    );
  }
}
