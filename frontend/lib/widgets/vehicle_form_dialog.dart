import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../services/api_exception.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class VehicleFormDialog extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormDialog({super.key, this.vehicle});

  static Future<bool?> show(BuildContext context, [Vehicle? vehicle]) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => VehicleFormDialog(vehicle: vehicle),
    );
  }

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
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
          Navigator.of(context).pop(true);
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
          Navigator.of(context).pop(true);
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
    final title = isEditMode ? 'Edit Vehicle' : 'Register Vehicle';
    final subtitle = isEditMode
        ? 'Update fleet asset details for ${widget.vehicle!.vehicleNumber}'
        : 'Enter vehicle asset details to add to the Stark fleet database.';

    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s24,
      ),
      child: Container(
        width: 580,
        constraints: const BoxConstraints(maxHeight: 740),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.cardHover,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s24,
                AppSpacing.s16,
                AppSpacing.s16,
                AppSpacing.s16,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                    child: Icon(
                      isEditMode ? Icons.edit_note_rounded : Icons.directions_car_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.h3),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    tooltip: 'Close',
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      hoverColor: AppColors.neutralTint,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Form Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Vehicle Registration Number
                      _buildLabel('Vehicle Registration Number *'),
                      TextFormField(
                        controller: _vehicleNumberController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: 'e.g. DHAKA-METRO-GA-11-2233',
                          prefixIcon: Icon(Icons.pin_outlined, size: 18),
                          helperText: 'Unique identifier, 3-20 characters',
                        ),
                        validator: (val) {
                          final serverErr = _serverFieldErrors['vehicleNumber'];
                          if (serverErr != null) return serverErr;
                          if (val == null || val.trim().isEmpty) {
                            return 'Vehicle registration number is required';
                          }
                          if (val.trim().length < 3 || val.trim().length > 30) {
                            return 'Number must be between 3 and 30 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // 2. Brand & Model (2 Columns)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Brand *'),
                                TextFormField(
                                  controller: _brandController,
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. Toyota, Hino',
                                    prefixIcon: Icon(Icons.business_outlined, size: 18),
                                  ),
                                  validator: (val) {
                                    final serverErr = _serverFieldErrors['brand'];
                                    if (serverErr != null) return serverErr;
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Brand is required';
                                    }
                                    if (val.trim().length > 50) {
                                      return 'Brand cannot exceed 50 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Model *'),
                                TextFormField(
                                  controller: _modelController,
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. Hiace, Coaster',
                                    prefixIcon: Icon(Icons.directions_car_filled_outlined, size: 18),
                                  ),
                                  validator: (val) {
                                    final serverErr = _serverFieldErrors['model'];
                                    if (serverErr != null) return serverErr;
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Model is required';
                                    }
                                    if (val.trim().length > 50) {
                                      return 'Model cannot exceed 50 characters';
                                    }
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
                      _buildLabel('Company / Operating Entity *'),
                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Stark Logistics, Stark Transit',
                          prefixIcon: Icon(Icons.corporate_fare_outlined, size: 18),
                        ),
                        validator: (val) {
                          final serverErr = _serverFieldErrors['company'];
                          if (serverErr != null) return serverErr;
                          if (val == null || val.trim().isEmpty) {
                            return 'Company is required';
                          }
                          if (val.trim().length > 100) {
                            return 'Company cannot exceed 100 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // 4. Vehicle Type & Status Row (2 Columns)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Vehicle Type *'),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedVehicleType,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.category_outlined, size: 18),
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
                                    if (val == null || val.isEmpty) {
                                      return 'Select a vehicle type';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Status *'),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedStatus,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.toggle_on_outlined, size: 18),
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
                                    if (val == null || val.isEmpty) {
                                      return 'Select status';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modal Footer
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
                vertical: AppSpacing.s16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.s12),
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
                        : Icon(isEditMode ? Icons.check_rounded : Icons.add_rounded, size: 18),
                    label: Text(
                      _isSubmitting
                          ? 'Saving...'
                          : (isEditMode ? 'Update Vehicle' : 'Register Vehicle'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Text(label, style: AppTextStyles.label),
    );
  }
}
