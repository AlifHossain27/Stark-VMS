import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/delete_confirmation_dialog.dart';
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
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete vehicle: $e'),
              backgroundColor: AppColors.error,
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

  Color _typeBadgeColor(String type) {
    switch (type.toUpperCase()) {
      case 'CAR':
        return const Color(0xFF2563EB);
      case 'VAN':
        return const Color(0xFF0D9488);
      case 'TRUCK':
        return const Color(0xFFD97706);
      case 'BUS':
        return const Color(0xFF4F46E5);
      case 'MOTORCYCLE':
        return const Color(0xFF9333EA);
      case 'OTHER':
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildStatusBadge(String status) {
    final Color color;
    final String label = status.toUpperCase();
    switch (label) {
      case 'ACTIVE':
        color = AppColors.success;
        break;
      case 'MAINTENANCE':
        color = AppColors.amberAccent;
        break;
      case 'INACTIVE':
      default:
        color = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Directory Header with Actions
              _buildDirectoryHeader(context, provider, isDesktop),
              const SizedBox(height: 20),

              // 2. Search & Filter Bar
              _buildFilterBar(context, provider.vehicles.length, filteredVehicles.length, isDesktop),
              const SizedBox(height: 20),

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
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          const Text(
                            'Fleet Directory',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${provider.vehicles.length} assets',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Inspect, search, edit specifications, and manage Stark fleet database records.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _buildHeaderButtons(context, provider),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    const Text(
                      'Fleet Directory',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${provider.vehicles.length} assets',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Inspect, search, edit specifications, and manage Stark fleet database records.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                _buildHeaderButtons(context, provider),
              ],
            ),
    );
  }

  Widget _buildHeaderButtons(BuildContext context, VehicleProvider provider) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => provider.fetchVehicles(),
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Refresh'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _openFormModal(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Register vehicle'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Search Input
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by vehicle number, brand, model, or company...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Showing $filteredCount of $totalCount',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Filter Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterTypes.map((type) {
                final isSelected = _selectedTypeFilter == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedTypeFilter = type;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    backgroundColor: AppColors.surfaceSubtle,
                    checkmarkColor: Colors.white,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2.5),
            SizedBox(height: 16),
            Text(
              'Loading fleet assets from Spring Boot database...',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (provider.hasError && provider.vehicles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 14),
              const Text(
                'Unable to Load Fleet Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  provider.errorMessage ?? 'Connection to database server timed out.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => provider.fetchVehicles(),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry connection'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (vehicles.isEmpty) {
      final isFiltered = _searchController.text.isNotEmpty || _selectedTypeFilter != 'ALL';
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
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
              Text(
                isFiltered ? 'No matching vehicles found' : 'No vehicles registered yet',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                isFiltered
                    ? 'Try clearing your search query or switching the category filter.'
                    : 'Get started by adding your first vehicle asset to the Stark Group fleet.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
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
                ElevatedButton.icon(
                  onPressed: () => _openFormModal(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Register vehicle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dynamicSpacing = ((constraints.maxWidth - 720) / 6).clamp(20.0, 60.0);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.surfaceSubtle),
                  horizontalMargin: 24,
                  columnSpacing: dynamicSpacing,
                  dataRowMinHeight: 58,
                  dataRowMaxHeight: 58,
                  dividerThickness: 1,
                  headingTextStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
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
                    final badgeColor = _typeBadgeColor(v.vehicleType);
                    return DataRow(
                      cells: [
                        // Vehicle Number
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              v.vehicleNumber,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppColors.textPrimary,
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
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                v.brand,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Model
                        DataCell(
                          Text(
                            v.model,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Company
                        DataCell(
                          Text(
                            v.company,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        // Type Badge
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: badgeColor.withAlpha(60)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: badgeColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  v.vehicleType,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: badgeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Status Badge
                        DataCell(
                          _buildStatusBadge(v.status),
                        ),
                        // Action Buttons
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                tooltip: 'Edit Vehicle',
                                color: AppColors.accent,
                                hoverColor: AppColors.accent.withAlpha(20),
                                onPressed: () => _openFormModal(context, v),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                tooltip: 'Delete Vehicle',
                                color: AppColors.error,
                                hoverColor: AppColors.error.withAlpha(20),
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
