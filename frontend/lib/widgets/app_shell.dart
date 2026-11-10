import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'vehicle_form_dialog.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const AppShell({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  String _getPageTitle() {
    if (currentLocation.startsWith('/dashboard')) return 'Fleet Dashboard';
    if (currentLocation == '/vehicles/new') return 'Register Vehicle';
    if (currentLocation.contains('/edit')) return 'Edit Vehicle';
    if (currentLocation.startsWith('/vehicles')) return 'Vehicles Directory';
    return 'Stark Fleet Management';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final pageTitle = _getPageTitle();

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            // Left Desktop Sidebar
            SizedBox(
              width: 260,
              child: _buildSidebar(context),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),

            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  _buildDesktopTopBar(context, pageTitle),
                  const Divider(height: 1, thickness: 1, color: AppColors.border),
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tablet & Mobile View with Drawer
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(pageTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s12),
            child: _buildTopBarOutlinedButton(
              onPressed: () => VehicleFormDialog.show(context),
              icon: Icons.add,
              label: 'Register',
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: _buildSidebar(context, isDrawer: true),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: child,
        ),
      ),
    );
  }

  /// Outlined button for the Deep Blue navigation chrome. Screen content
  /// owns the one filled primary action per view, so shell buttons stay
  /// outlined with white text on the dark surface.
  Widget _buildTopBarOutlinedButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.onDarkBorder),
      ),
    );
  }

  Widget _buildDesktopTopBar(BuildContext context, String title) {
    return Container(
      height: 68,
      color: AppColors.deepBlue,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          _buildTopBarOutlinedButton(
            onPressed: () => context.go('/'),
            icon: Icons.home_outlined,
            label: 'Public Site',
          ),
          const SizedBox(width: AppSpacing.s12),
          _buildTopBarOutlinedButton(
            onPressed: () => VehicleFormDialog.show(context),
            icon: Icons.add,
            label: 'Register Vehicle',
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, {bool isDrawer = false}) {
    return Container(
      color: AppColors.deepBlue,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Brand Wordmark
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Row(
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
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STARK VMS',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Fleet Portal',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.onDarkSubtle,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: AppColors.onDarkBorder),
            const SizedBox(height: AppSpacing.s16),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    isSelected: currentLocation.startsWith('/dashboard'),
                    onTap: () {
                      if (isDrawer) Navigator.of(context).pop();
                      context.go('/dashboard');
                    },
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _buildNavItem(
                    context: context,
                    icon: Icons.directions_car_outlined,
                    activeIcon: Icons.directions_car_rounded,
                    label: 'Vehicles',
                    isSelected: currentLocation.startsWith('/vehicles'),
                    onTap: () {
                      if (isDrawer) Navigator.of(context).pop();
                      context.go('/vehicles');
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s8,
                    ),
                    child: Text(
                      'UPCOMING MODULES',
                      style: AppTextStyles.micro.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.onDarkSubtle,
                      ),
                    ),
                  ),
                  _buildDisabledNavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Drivers',
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _buildDisabledNavItem(
                    icon: Icons.build_outlined,
                    label: 'Maintenance',
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _buildDisabledNavItem(
                    icon: Icons.description_outlined,
                    label: 'Documents',
                  ),
                ],
              ),
            ),

            // Footer Link
            const Divider(height: 1, thickness: 1, color: AppColors.onDarkBorder),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s12),
              child: _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Public Landing',
                isSelected: false,
                onTap: () {
                  if (isDrawer) Navigator.of(context).pop();
                  context.go('/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Selected navigation is a Corporate Blue fill with white text.
    return Material(
      color: isSelected ? AppColors.primary : AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.input),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.input),
        hoverColor: isSelected
            ? AppColors.white.withAlpha(26)
            : AppColors.white.withAlpha(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected ? AppColors.white : AppColors.onDarkSubtle,
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledNavItem({
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onDarkSubtle),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.onDarkSubtle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(16),
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.white.withAlpha(24)),
            ),
            child: Text(
              'Soon',
              style: AppTextStyles.micro.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onDarkSubtle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
