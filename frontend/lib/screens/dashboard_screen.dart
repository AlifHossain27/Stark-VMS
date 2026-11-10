import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/page_header.dart';
import '../widgets/status_badge.dart';
import '../widgets/vehicle_form_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VehicleProvider?>(context, listen: false);
      provider?.fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final provider = Provider.of<VehicleProvider?>(context);

    return Material(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? AppSpacing.s32 : AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Operations Header & Quick Actions
            _buildHeader(context, isDesktop),
            const SizedBox(height: AppSpacing.s24),

            // 2. Metric Summary Cards
            _buildMetricsGrid(context, provider, isDesktop, isTablet),
            const SizedBox(height: AppSpacing.s32),

            // 3. Recent Vehicles Panel
            _buildRecentVehiclesPanel(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return PageHeader(
      title: 'Operations Command',
      subtitle: 'Real-time Stark Group fleet registry statistics and operational metrics.',
      actions: _buildQuickActions(context),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s8,
      children: [
        // The one primary action of this view.
        ElevatedButton.icon(
          onPressed: () => VehicleFormDialog.show(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Register vehicle'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/vehicles'),
          icon: const Icon(Icons.directions_car_outlined, size: 18),
          label: const Text('View vehicles'),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    VehicleProvider? provider,
    bool isDesktop,
    bool isTablet,
  ) {
    final cards = [
      _buildRealTotalVehiclesCard(provider),
      _buildMutedPlaceholderCard(
        title: 'Active vehicles',
        icon: Icons.check_circle_outline_rounded,
        subtext: 'Operational status tracking',
      ),
      _buildMutedPlaceholderCard(
        title: 'Under maintenance',
        icon: Icons.car_repair_rounded,
        subtext: 'Workshop & repairs',
      ),
      _buildMutedPlaceholderCard(
        title: 'Documents expiring soon',
        icon: Icons.warning_amber_rounded,
        subtext: 'Tax, fitness, insurance',
      ),
      _buildMutedPlaceholderCard(
        title: 'Maintenance this month',
        icon: Icons.calendar_month_outlined,
        subtext: 'Scheduled fleet servicing',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: AppSpacing.s16,
        crossAxisSpacing: AppSpacing.s16,
        mainAxisExtent: 160,
      ),
      itemBuilder: (context, index) => cards[index],
    );
  }

  Widget _buildRealTotalVehiclesCard(VehicleProvider? provider) {
    final isLoading = provider?.isLoading ?? false;
    final hasError = provider?.hasError ?? false;
    final count = provider?.vehicles.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        // Featured card: slightly stronger primary border than the standard
        // border token.
        border: Border.all(color: AppColors.primaryTintBorder, width: 1.5),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  border: Border.all(color: AppColors.primaryTintBorder),
                ),
                child: Text(
                  'Live Data',
                  style: AppTextStyles.micro.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isLoading)
            const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else if (hasError)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Failed to load',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => provider?.fetchVehicles(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 24),
                  ),
                  child: Text('Retry', style: AppTextStyles.label),
                ),
              ],
            )
          else
            Text(
              '$count',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          const SizedBox(height: 2),
          Text('Total vehicles', style: AppTextStyles.label),
        ],
      ),
    );
  }

  Widget _buildMutedPlaceholderCard({
    required String title,
    required IconData icon,
    required String subtext,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        // Muted placeholder: neutral tint instead of a white surface.
        color: AppColors.neutralTint,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(icon, color: AppColors.textSecondary, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'Coming soon',
                  style: AppTextStyles.micro.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '--',
            style: AppTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVehiclesPanel(BuildContext context, VehicleProvider? provider) {
    final isLoading = provider?.isLoading ?? false;
    final hasError = provider?.hasError ?? false;
    final vehicles = provider?.vehicles ?? [];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with View All link
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s16,
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 22, color: AppColors.primary),
                const SizedBox(width: AppSpacing.s8),
                const Expanded(
                  child: Text(
                    'Recent Vehicles',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/vehicles'),
                  label: Text(
                    'View all',
                    style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w700),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content States
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.s48),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (hasError)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s48),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 40, color: AppColors.danger),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      provider?.errorMessage ?? 'Unable to connect to vehicle database',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    OutlinedButton.icon(
                      onPressed: () => provider?.fetchVehicles(),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (vehicles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s48,
                horizontal: AppSpacing.s24,
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: const BoxDecoration(
                        color: AppColors.neutralTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_car_outlined,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const Text(
                      'No vehicles registered yet',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    const Text(
                      'Get started by adding your first vehicle asset to the Stark Group fleet.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    OutlinedButton.icon(
                      onPressed: () => VehicleFormDialog.show(context),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add vehicle'),
                    ),
                  ],
                ),
              ),
            )
          else
            _buildRecentVehiclesList(context, vehicles),
        ],
      ),
    );
  }

  Widget _buildRecentVehiclesList(BuildContext context, List<Vehicle> allVehicles) {
    // Show up to the last 5 registered vehicles (newest first)
    final recent = allVehicles.reversed.take(5).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final vehicle = recent[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s8,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s4,
            children: [
              Text(
                '${vehicle.brand} ${vehicle.model}',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              StatusBadge(status: vehicle.status),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s4),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s4,
              children: [
                Text(
                  vehicle.vehicleNumber,
                  style: AppTextStyles.label.copyWith(fontFamily: 'monospace'),
                ),
                Text(
                  vehicle.company,
                  style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          trailing: OutlinedButton(
            onPressed: () => VehicleFormDialog.show(context, vehicle),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s4,
              ),
              minimumSize: const Size(60, 32),
            ),
            child: Text('Edit', style: AppTextStyles.label),
          ),
        );
      },
    );
  }
}
