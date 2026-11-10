import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/page_header.dart';
import '../widgets/status_badge.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_form_dialog.dart';

class VehicleListScreen extends StatefulWidget {
  final void Function(BuildContext context, [Vehicle? vehicle])? onNavigateToForm;
  final void Function(BuildContext context, Vehicle vehicle)? onDeleteVehicle;
  final bool showNavBar;

  const VehicleListScreen({
    super.key,
    this.onNavigateToForm,
    this.onDeleteVehicle,
    this.showNavBar = true,
  });

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTypeFilter = 'ALL';

  static const List<String> _filterTypes = [
    'ALL',
    'CAR',
    'VAN',
    'TRUCK',
    'BUS',
    'MOTORCYCLE',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFormModal(BuildContext context, [Vehicle? vehicle]) {
    if (widget.onNavigateToForm != null) {
      widget.onNavigateToForm!(context, vehicle);
    } else {
      VehicleFormDialog.show(context, vehicle);
    }
  }

  Future<void> _handleDelete(BuildContext context, Vehicle vehicle) async {
    if (widget.onDeleteVehicle != null) {
      widget.onDeleteVehicle!(context, vehicle);
      return;
    }

    final confirmed = await DeleteConfirmationDialog.show(context, vehicle);
    if (confirmed == true && context.mounted) {
      final provider = context.read<VehicleProvider>();
      try {
        await provider.deleteVehicle(vehicle.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vehicle ${vehicle.vehicleNumber} was removed from the fleet.'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete vehicle: $e'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      }
    }
  }

  List<Vehicle> _filterVehicles(List<Vehicle> allVehicles) {
    final query = _searchController.text.trim().toLowerCase();
    return allVehicles.where((v) {
      final matchesType = _selectedTypeFilter == 'ALL' ||
          v.vehicleType.toUpperCase() == _selectedTypeFilter;
      final matchesQuery = query.isEmpty ||
          v.vehicleNumber.toLowerCase().contains(query) ||
          v.brand.toLowerCase().contains(query) ||
          v.model.toLowerCase().contains(query) ||
          v.company.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList();
  }

  /// Neutral type chip (CAR/VAN/TRUCK/...): neutral tint with secondary
  /// text. Type categories are not status, so they stay neutral.
  Widget _buildTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutralTint,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          Text(
            type,
            style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    final filteredVehicles = _filterVehicles(provider.vehicles);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => provider.fetchVehicles(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? AppSpacing.s32 : AppSpacing.s16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Directory Header with Actions
              _buildDirectoryHeader(context, provider, isDesktop),
              const SizedBox(height: AppSpacing.s16),

              // 2. Search & Filter Bar
              _buildFilterBar(context, provider.vehicles.length, filteredVehicles.length, isDesktop),
              const SizedBox(height: AppSpacing.s16),

              // 3. Main Directory Body
              _buildDirectoryBody(context, provider, filteredVehicles, isDesktop, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectoryHeader(
    BuildContext context,
    VehicleProvider provider,
    bool isDesktop,
  ) {
    return PageHeader(
      title: 'Fleet Directory',
      subtitle: 'Inspect, search, edit specifications, and manage Stark fleet database records.',
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryTint,
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Text(
          '${provider.vehicles.length} assets',
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
      actions: _buildHeaderButtons(context, provider),
    );
  }

  Widget _buildHeaderButtons(BuildContext context, VehicleProvider provider) {
    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s8,
      children: [
        OutlinedButton.icon(
          onPressed: () => provider.fetchVehicles(),
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Refresh'),
        ),
        // The one primary action of this view.
        ElevatedButton.icon(
          onPressed: () => _openFormModal(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Register vehicle'),
        ),
      ],
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    int totalCount,
    int filteredCount,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Search Input (fill, borders and focus colors from the theme)
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by vehicle number, brand, model, or company...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                'Showing $filteredCount of $totalCount',
                style: AppTextStyles.label,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),

          // Filter Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterTypes.map((type) {
                final isSelected = _selectedTypeFilter == type;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.s8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedTypeFilter = type;
                      });
                    },
                    labelStyle: isSelected
                        ? AppTextStyles.label.copyWith(color: AppColors.white)
                        : AppTextStyles.label,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectoryBody(
    BuildContext context,
    VehicleProvider provider,
    List<Vehicle> vehicles,
    bool isDesktop,
    bool isTablet,
  ) {
    if (provider.isLoading && provider.vehicles.isEmpty) {
      return Container(
        height: 320,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2.5),
            SizedBox(height: AppSpacing.s16),
            Text(
              'Loading fleet assets from Spring Boot database...',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    if (provider.hasError && provider.vehicles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.s48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.danger),
              const SizedBox(height: AppSpacing.s12),
              const Text(
                'Unable to Load Fleet Data',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppSpacing.s4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  provider.errorMessage ?? 'Connection to database server timed out.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              OutlinedButton.icon(
                onPressed: () => provider.fetchVehicles(),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry connection'),
              ),
            ],
          ),
        ),
      );
    }

    if (vehicles.isEmpty) {
      final isFiltered = _searchController.text.isNotEmpty || _selectedTypeFilter != 'ALL';
      return Container(
        padding: const EdgeInsets.all(AppSpacing.s48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
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
              Text(
                isFiltered ? 'No matching vehicles found' : 'No vehicles registered yet',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                isFiltered
                    ? 'Try clearing your search query or switching the category filter.'
                    : 'Get started by adding your first vehicle asset to the Stark Group fleet.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.s16),
              if (isFiltered)
                OutlinedButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedTypeFilter = 'ALL';
                    });
                  },
                  child: const Text('Clear filters'),
                )
              else
                OutlinedButton.icon(
                  onPressed: () => _openFormModal(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Register vehicle'),
                ),
            ],
          ),
        ),
      );
    }

    // Modern Responsive Data Display
    return isDesktop
        ? _buildModernDesktopTable(context, vehicles)
        : _buildModernCardList(context, vehicles);
  }

  Widget _buildModernDesktopTable(BuildContext context, List<Vehicle> vehicles) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dynamicSpacing = ((constraints.maxWidth - 720) / 6).clamp(20.0, 60.0);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  horizontalMargin: AppSpacing.s24,
                  columnSpacing: dynamicSpacing,
                  dataRowMinHeight: 58,
                  dataRowMaxHeight: 58,
                  columns: const [
                    DataColumn(label: Text('VEHICLE NUMBER')),
                    DataColumn(label: Text('BRAND')),
                    DataColumn(label: Text('MODEL')),
                    DataColumn(label: Text('COMPANY')),
                    DataColumn(label: Text('TYPE')),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('ACTIONS')),
                  ],
                  rows: vehicles.map((v) {
                    return DataRow(
                      cells: [
                        // Vehicle Number
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s8,
                              vertical: AppSpacing.s4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neutralTint,
                              borderRadius: BorderRadius.circular(AppRadius.input),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              v.vehicleNumber,
                              style: AppTextStyles.label.copyWith(
                                fontFamily: 'monospace',
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        // Brand
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.s8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTint,
                                  borderRadius: BorderRadius.circular(AppRadius.input),
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              Text(
                                v.brand,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Model
                        DataCell(
                          Text(
                            v.model,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Company
                        DataCell(
                          Text(
                            v.company,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Type Badge
                        DataCell(_buildTypeChip(v.vehicleType)),
                        // Status Badge
                        DataCell(StatusBadge(status: v.status)),
                        // Action Buttons
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                tooltip: 'Edit Vehicle',
                                color: AppColors.primary,
                                hoverColor: AppColors.primaryTint,
                                onPressed: () => _openFormModal(context, v),
                              ),
                              const SizedBox(width: AppSpacing.s4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                tooltip: 'Delete Vehicle',
                                color: AppColors.danger,
                                hoverColor: AppColors.dangerTint,
                                onPressed: () => _handleDelete(context, v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernCardList(BuildContext context, List<Vehicle> vehicles) {
    return Column(
      children: vehicles.map((v) {
        return VehicleCard(
          vehicle: v,
          onEdit: () => _openFormModal(context, v),
          onDelete: () => _handleDelete(context, v),
        );
      }).toList(),
    );
  }
}
