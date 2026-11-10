import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/feature_card.dart';
import '../widgets/footer/site_footer.dart';
import '../widgets/hero_mock_dashboard.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/landing_nav_bar.dart';
import '../widgets/stat_statement_card.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 20;
    if (scrolled != _isScrolled) {
      setState(() {
        _isScrolled = scrolled;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Spacing that clears the sticky top bar.
                const SizedBox(height: LandingNavBar.height + AppSpacing.s4),

                // 1. Hero Section with subtle gradient
                _buildHeroSection(context, isDesktop, reduceMotion),

                // 2. Stats Strip (3 text-only value claims)
                _buildStatsStrip(isDesktop, isTablet),

                // 3. Features Section (6 cards)
                _buildFeaturesSection(isDesktop, isTablet),

                // 4. How It Works Section (3 steps)
                _buildHowItWorksSection(),

                // 5. Final CTA Banner
                _buildCtaBanner(context),

                // 6. Modern Polished Footer
                SiteFooter(
                  onBackToTop: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    );
                  },
                ),
              ],
            ),
          ),

          // Sticky Glassmorphism Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingNavBar(
              isScrolled: _isScrolled,
              onScrollToFeatures: () => _scrollToKey(_featuresKey),
              onScrollToHowItWorks: () => _scrollToKey(_howItWorksKey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop, bool reduceMotion) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            borderRadius: BorderRadius.circular(AppRadius.input),
            border: Border.all(color: AppColors.primaryTintBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined, size: 14, color: AppColors.primary),
              const SizedBox(width: AppSpacing.s4),
              Text(
                'Next-Gen Fleet Operations',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s16),

        // Headline
        const Text(
          'Enterprise Fleet Control Built for Stark Group',
          style: AppTextStyles.display,
        ),
        const SizedBox(height: AppSpacing.s16),

        // Subtext
        Text(
          'A centralized, intelligent vehicle management platform ensuring fleet compliance, real-time asset tracking, and proactive maintenance.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s32),

        // Buttons: one filled primary action plus a secondary outlined one.
        // Colors, text styles and padding come from the button theme.
        Wrap(
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s12,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(Icons.dashboard_rounded, size: 18),
              label: const Text('Go to Dashboard'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.go('/vehicles'),
              icon: const Icon(Icons.directions_car_outlined, size: 18),
              label: const Text('View Vehicles'),
            ),
          ],
        ),
      ],
    );

    final heroWidgets = isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: reduceMotion
                    ? textContent
                    : textContent
                        .animate()
                        .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.08, end: 0, duration: 450.ms),
              ),
              const SizedBox(width: AppSpacing.s48),
              const Expanded(
                flex: 5,
                child: HeroMockDashboard(),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              reduceMotion
                  ? textContent
                  : textContent
                      .animate()
                      .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.08, end: 0, duration: 450.ms),
              const SizedBox(height: AppSpacing.s32),
              const Center(child: HeroMockDashboard()),
            ],
          );

    return Container(
      decoration: BoxDecoration(gradient: AppColors.heroGradient),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.s48 : AppSpacing.s24,
        vertical: isDesktop ? AppSpacing.s48 : AppSpacing.s32,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: heroWidgets,
        ),
      ),
    );
  }

  Widget _buildStatsStrip(bool isDesktop, bool isTablet) {
    final claims = [
      const StatStatementCard(
        title: 'Track every vehicle',
        description: 'Complete centralized registry with vehicle numbers, categories, specifications, and live status.',
        icon: Icons.checklist_rounded,
      ),
      const StatStatementCard(
        title: 'Never miss an expiry',
        description: 'Proactive tracking for tax tokens, fitness certificates, and insurance renewals before expiration.',
        icon: Icons.notification_important_outlined,
      ),
      const StatStatementCard(
        title: 'One place for your fleet',
        description: 'Unified management linking vehicles, driver assignments, and verified workshop service history.',
        icon: Icons.hub_outlined,
      ),
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.s48 : AppSpacing.s24,
          vertical: AppSpacing.s32,
        ),
        child: isDesktop
            ? Row(
                children: [
                  Expanded(child: claims[0]),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(child: claims[1]),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(child: claims[2]),
                ],
              )
            : Column(
                children: [
                  claims[0],
                  const SizedBox(height: AppSpacing.s16),
                  claims[1],
                  const SizedBox(height: AppSpacing.s16),
                  claims[2],
                ],
              ),
      ),
    );
  }

  Widget _buildFeaturesSection(bool isDesktop, bool isTablet) {
    final features = [
      const FeatureCard(
        title: 'Vehicle Registry',
        description: 'Store, inspect, edit, and organize all vehicles with real-time unique registration number validation.',
        icon: Icons.directions_car_filled,
        isComingSoon: false,
      ),
      const FeatureCard(
        title: 'Documents & Expiry Tracking',
        description: 'Upload and monitor registration, tax token, insurance, and fitness certificates with renewal badges.',
        icon: Icons.document_scanner_outlined,
        isComingSoon: true,
      ),
      const FeatureCard(
        title: 'Maintenance History',
        description: 'Track complete maintenance records, workshop costs, scheduled servicing, and part replacements.',
        icon: Icons.car_repair_outlined,
        isComingSoon: true,
      ),
      const FeatureCard(
        title: 'Driver Assignment',
        description: 'Assign certified drivers to fleet vehicles with active status monitoring and driver profiles.',
        icon: Icons.badge_outlined,
        isComingSoon: true,
      ),
      const FeatureCard(
        title: 'Search & Server Filters',
        description: 'Instantly find vehicles by registration number, type, brand, and sort server-side across thousands of assets.',
        icon: Icons.search_rounded,
        isComingSoon: true,
      ),
      const FeatureCard(
        title: 'Dashboard Insights',
        description: 'Visual analytics on fleet availability, vehicles under maintenance, and immediate operational statistics.',
        icon: Icons.bar_chart_rounded,
        isComingSoon: true,
      ),
    ];

    return Center(
      key: _featuresKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.s48 : AppSpacing.s24,
          vertical: AppSpacing.s48,
        ),
        child: Column(
          children: [
            Text(
              'POWERFUL CAPABILITIES',
              style: AppTextStyles.micro.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            const Text('Engineered for Modern Fleet Control', style: AppTextStyles.h1),
            const SizedBox(height: AppSpacing.s12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: const Text(
                'Everything Stark Group needs to manage vehicles, reduce downtime, and maintain compliance.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                mainAxisSpacing: AppSpacing.s16,
                crossAxisSpacing: AppSpacing.s16,
                mainAxisExtent: 270,
              ),
              itemBuilder: (context, index) => features[index],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Center(
      key: _howItWorksKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32, vertical: AppSpacing.s48),
        child: Column(
          children: [
            Text(
              'WORKFLOW',
              style: AppTextStyles.micro.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            const Text('How Stark VMS Works', style: AppTextStyles.h1),
            const SizedBox(height: AppSpacing.s12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: const Text(
                'Three simple steps to transition from scattered spreadsheets to an enterprise fleet control system.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const HowItWorksSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCtaBanner(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s24,
          vertical: AppSpacing.s48,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s48,
        ),
        decoration: BoxDecoration(
          // Deep Blue / Corporate Blue blend (the allowed gradient pair).
          gradient: AppColors.ctaGradient,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.cardHover,
        ),
        child: Column(
          children: [
            Text(
              'Ready to Streamline Your Fleet Operations?',
              textAlign: TextAlign.center,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'Access the live fleet dashboard, view registered corporate assets, and manage vehicles today.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.onDarkSubtle),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            // White-filled CTA on the gradient; Corporate Blue label text.
            ElevatedButton.icon(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Open Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.w800),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s24,
                  vertical: AppSpacing.s16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
