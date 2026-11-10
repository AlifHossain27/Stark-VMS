import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../vehicle_form_dialog.dart';
import 'back_to_top_button.dart';
import 'footer_link_data.dart';
import 'footer_link_group.dart';

/// Site footer: Deep Blue surface with white text
/// ("Deep Blue: sidebar, top navigation, footer").
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
        // 1. Thin Accent Line (Deep Blue / Corporate Blue blend only)
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.deepBlue,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        // 2. Main Footer Body
        Container(
          color: AppColors.deepBlue,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? AppSpacing.s48 : (isTablet ? AppSpacing.s32 : AppSpacing.s16),
            vertical: isDesktop ? AppSpacing.s48 : AppSpacing.s32,
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

                  const SizedBox(height: AppSpacing.s48),

                  // Divider
                  Container(
                    height: 1,
                    color: AppColors.onDarkBorder,
                  ),
                  const SizedBox(height: AppSpacing.s24),

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
              padding: const EdgeInsets.all(AppSpacing.s8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              child: const Icon(
                Icons.directions_boat_filled,
                color: AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(
              'STARK VMS',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Text(
            'Enterprise fleet control, vehicle asset tracking, and compliance management portal built for Stark Group.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.onDarkSubtle),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        OutlinedButton.icon(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.dashboard_outlined, size: 16),
          label: const Text('Open Dashboard'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.white,
            side: BorderSide(color: AppColors.onDarkBorder),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s8,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.input)),
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
        const SizedBox(width: AppSpacing.s48),
        Expanded(
          flex: 2,
          child: FooterLinkGroup(
            title: 'Product',
            links: productLinks,
          ),
        ),
        const SizedBox(width: AppSpacing.s32),
        const Expanded(
          flex: 3,
          child: FooterLinkGroup(
            title: 'Features',
            links: FooterLinkData.featureLinks,
          ),
        ),
        const SizedBox(width: AppSpacing.s32),
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
            const SizedBox(width: AppSpacing.s32),
            Expanded(
              child: FooterLinkGroup(
                title: 'Product',
                links: productLinks,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s32),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FooterLinkGroup(
                title: 'Features',
                links: FooterLinkData.featureLinks,
              ),
            ),
            SizedBox(width: AppSpacing.s32),
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
        const SizedBox(height: AppSpacing.s32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FooterLinkGroup(
                title: 'Product',
                links: productLinks,
              ),
            ),
            const SizedBox(width: AppSpacing.s24),
            const Expanded(
              child: FooterLinkGroup(
                title: 'Features',
                links: FooterLinkData.featureLinks,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),
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
            style: AppTextStyles.label.copyWith(color: AppColors.onDarkSubtle),
          ),
          const SizedBox(height: AppSpacing.s12),
          BackToTopButton(onPressed: onBackToTop),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          copyrightText,
          style: AppTextStyles.label.copyWith(color: AppColors.onDarkSubtle),
        ),
        BackToTopButton(onPressed: onBackToTop),
      ],
    );
  }
}
