import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../services/api_exception.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class VehicleFormScreen extends StatefulWidget {
  final Vehicle? vehicle;
  final bool showAppBar;

  const VehicleFormScreen({
    super.key,
    this.vehicle,
    this.showAppBar = true,
  });

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _vehicleNumberController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _companyController;

  String? _selectedVehicleType;
  String? _selectedStatus;
  bool _isSubmitting = false;
  Map<String, String> _serverFieldErrors = {};

  static const List<String> _vehicleTypes = [
    'CAR',
    'VAN',
    'TRUCK',
    'BUS',
    'MOTORCYCLE',
    'OTHER',
  ];

  static const List<String> _statusValues = [
    'ACTIVE',
    'INACTIVE',
    'MAINTENANCE',
  ];

  bool get isEditMode => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _vehicleNumberController = TextEditingController(text: v?.vehicleNumber ?? '');
    _brandController = TextEditingController(text: v?.brand ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _companyController = TextEditingController(text: v?.company ?? '');

    if (v != null) {
      final upperType = v.vehicleType.toUpperCase();
      _selectedVehicleType = _vehicleTypes.contains(upperType) ? upperType : 'OTHER';

      final upperStatus = v.status.toUpperCase();
      _selectedStatus = _statusValues.contains(upperStatus) ? upperStatus : 'ACTIVE';
    } else {
      _selectedVehicleType = 'CAR';
      _selectedStatus = 'ACTIVE';
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    setState(() {
      _serverFieldErrors = {};
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final vehicleData = {
      'vehicleNumber': _vehicleNumberController.text.trim().toUpperCase(),
      'brand': _brandController.text.trim(),
      'model': _modelController.text.trim(),
      'company': _companyController.text.trim(),
      'vehicleType': _selectedVehicleType ?? 'CAR',
      'status': _selectedStatus ?? 'ACTIVE',
    };

    final provider = context.read<VehicleProvider>();

    try {
      if (isEditMode) {
        await provider.updateVehicle(widget.vehicle!.id, vehicleData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vehicle ${widget.vehicle!.vehicleNumber} updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go('/vehicles');
          }
        }
      } else {
        final created = await provider.createVehicle(vehicleData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vehicle ${created.vehicleNumber} registered successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go('/vehicles');
          }
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _serverFieldErrors = e.fieldErrors;
        });
        _formKey.currentState!.validate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isEditMode ? 'Edit Vehicle' : 'Register New Vehicle';
    final subtitle = isEditMode
        ? 'Update specifications for ${widget.vehicle!.vehicleNumber}'
        : 'Add a new vehicle asset to the Stark Group fleet';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.showAppBar
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/dashboard');
                  }
                },
              ),
              title: Text(title),
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s32,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 680),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            padding: const EdgeInsets.all(AppSpacing.s32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.s4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppSpacing.s24),

                  // 1. Vehicle Number Field
                  _buildSectionLabel('Vehicle Registration Number *'),
                  TextFormField(
                    controller: _vehicleNumberController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. DHAKA-METRO-GA-11-2233',
                      prefixIcon: Icon(Icons.pin_outlined, size: 20),
                      helperText: 'Must be 3-30 characters, stored in uppercase',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (val) {
                      final serverErr = _serverFieldErrors['vehicleNumber'];
                      if (serverErr != null) return serverErr;

                      final trimmed = val?.trim() ?? '';
                      if (trimmed.isEmpty) {
                        return 'Vehicle number is required';
                      }
                      if (trimmed.length < 3 || trimmed.length > 30) {
                        return 'Vehicle number must be between 3 and 30 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),

                  // 2. Brand & Model Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Brand *'),
                            TextFormField(
                              controller: _brandController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Toyota, Hino',
                                prefixIcon: Icon(Icons.business, size: 20),
                              ),
                              validator: (val) {
                                final serverErr = _serverFieldErrors['brand'];
                                if (serverErr != null) return serverErr;

                                final trimmed = val?.trim() ?? '';
                                if (trimmed.isEmpty) return 'Brand is required';
                                if (trimmed.length > 50) return 'Brand cannot exceed 50 characters';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Model *'),
                            TextFormField(
                              controller: _modelController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Hiace, Civic',
                                prefixIcon: Icon(Icons.drive_eta, size: 20),
                              ),
                              validator: (val) {
                                final serverErr = _serverFieldErrors['model'];
                                if (serverErr != null) return serverErr;

                                final trimmed = val?.trim() ?? '';
                                if (trimmed.isEmpty) return 'Model is required';
                                if (trimmed.length > 50) return 'Model cannot exceed 50 characters';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),

                  // 3. Company Field
                  _buildSectionLabel('Company / Operating Entity *'),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Stark Logistics, Stark Transit',
                      prefixIcon: Icon(Icons.corporate_fare_outlined, size: 20),
                    ),
                    validator: (val) {
                      final serverErr = _serverFieldErrors['company'];
                      if (serverErr != null) return serverErr;

                      final trimmed = val?.trim() ?? '';
                      if (trimmed.isEmpty) return 'Company is required';
                      if (trimmed.length > 100) return 'Company cannot exceed 100 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),

                  // 4. Vehicle Type & Status Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Vehicle Type *'),
                            DropdownButtonFormField<String>(
                              initialValue: _vehicleTypes.contains(_selectedVehicleType)
                                  ? _selectedVehicleType
                                  : _vehicleTypes.first,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.commute, size: 20),
                              ),
                              items: _vehicleTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedVehicleType = val;
                                });
                              },
                              validator: (val) {
                                final serverErr = _serverFieldErrors['vehicleType'];
                                if (serverErr != null) return serverErr;
                                if (val == null || val.isEmpty) return 'Select vehicle type';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Status *'),
                            DropdownButtonFormField<String>(
                              initialValue: _statusValues.contains(_selectedStatus)
                                  ? _selectedStatus
                                  : _statusValues.first,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.toggle_on_outlined, size: 20),
                              ),
                              items: _statusValues.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedStatus = val;
                                });
                              },
                              validator: (val) {
                                final serverErr = _serverFieldErrors['status'];
                                if (serverErr != null) return serverErr;
                                if (val == null || val.isEmpty) return 'Select status';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s32),

                  // 5. Submit and Cancel Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/dashboard');
                                }
                              },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submitForm,
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Icon(isEditMode ? Icons.check : Icons.add, size: 18),
                        label: Text(
                          _isSubmitting
                              ? 'Saving...'
                              : (isEditMode ? 'Update Vehicle' : 'Register Vehicle'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Text(label, style: AppTextStyles.label),
    );
  }
}
