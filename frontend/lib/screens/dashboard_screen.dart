import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
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
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Operations Header & Quick Actions
            _buildHeader(context, isDesktop),
            const SizedBox(height: 28),

            // 2. Metric Summary Cards
            _buildMetricsGrid(context, provider, isDesktop, isTablet),
            const SizedBox(height: 36),

            // 3. Recent Vehicles Panel
            _buildRecentVehiclesPanel(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Operations Command',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real-time Stark Group fleet registry statistics and operational metrics.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _buildQuickActions(context),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operations Command',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real-time Stark Group fleet registry statistics and operational metrics.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                _buildQuickActions(context),
              ],
            ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () => VehicleFormDialog.show(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Register vehicle'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/vehicles'),
          icon: const Icon(Icons.directions_car_outlined, size: 18),
          label: const Text('View vehicles'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
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
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(80), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(14),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Live Data',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
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
                    style: TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => provider?.fetchVehicles(),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(40, 24)),
                  child: const Text('Retry', style: TextStyle(fontSize: 12)),
                ),
              ],
            )
          else
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          const SizedBox(height: 2),
          const Text(
            'Total vehicles',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle.withAlpha(160),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.border.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.textMuted, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.border.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coming soon',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '--',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with View All link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 22, color: AppColors.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Recent Vehicles',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/vehicles'),
                  label: const Text('View all', style: TextStyle(fontWeight: FontWeight.w700)),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Content States
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (hasError)
            Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 40, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(
                      provider?.errorMessage ?? 'Unable to connect to vehicle database',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
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
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_car_outlined,
                        size: 40,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No vehicles registered yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Get started by adding your first vehicle asset to the Stark Group fleet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => VehicleFormDialog.show(context),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add vehicle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
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
      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
      itemBuilder: (context, index) {
        final vehicle = recent[index];
        final Color statusColor;
        switch (vehicle.status.toUpperCase()) {
          case 'ACTIVE':
            statusColor = AppColors.success;
            break;
          case 'MAINTENANCE':
            statusColor = AppColors.amberAccent;
            break;
          case 'INACTIVE':
          default:
            statusColor = AppColors.textSecondary;
            break;
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                '${vehicle.brand} ${vehicle.model}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withAlpha(60)),
                ),
                child: Text(
                  vehicle.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  vehicle.vehicleNumber,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  vehicle.company,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          trailing: OutlinedButton(
            onPressed: () => VehicleFormDialog.show(context, vehicle),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(60, 32),
            ),
            child: const Text('Edit', style: TextStyle(fontSize: 12)),
          ),
        );
      },
    );
  }
}
