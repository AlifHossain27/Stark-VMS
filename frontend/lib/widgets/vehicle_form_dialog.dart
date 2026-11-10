import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../services/api_exception.dart';
import '../theme/app_colors.dart';

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
  late final TextEditingController _yearController;
  late final TextEditingController _colorController;

  String? _selectedVehicleType;
  bool _isSubmitting = false;
  Map<String, String> _serverFieldErrors = {};

  static const List<String> _vehicleTypes = [
    'CAR',
    'VAN',
    'TRUCK',
    'BUS',
    'MOTORCYCLE',
    'SUV',
    'PICKUP',
  ];

  bool get isEditMode => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _vehicleNumberController = TextEditingController(text: v?.vehicleNumber ?? '');
    _brandController = TextEditingController(text: v?.brand ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _yearController = TextEditingController(
      text: v != null ? v.manufactureYear.toString() : '',
    );
    _colorController = TextEditingController(text: v?.color ?? '');

    if (v != null) {
      final upperType = v.vehicleType.toUpperCase();
      if (_vehicleTypes.contains(upperType)) {
        _selectedVehicleType = upperType;
      } else {
        _selectedVehicleType = v.vehicleType;
      }
    } else {
      _selectedVehicleType = 'CAR';
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
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
      'manufactureYear': int.parse(_yearController.text.trim()),
      'vehicleType': _selectedVehicleType ?? 'CAR',
      if (_colorController.text.trim().isNotEmpty)
        'color': _colorController.text.trim(),
    };

    final provider = context.read<VehicleProvider>();

    try {
      if (isEditMode) {
        await provider.updateVehicle(widget.vehicle!.id, vehicleData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vehicle ${widget.vehicle!.vehicleNumber} updated successfully!'),
              backgroundColor: Colors.green.shade700,
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
              backgroundColor: Colors.green.shade700,
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
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red.shade700,
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
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 580,
        constraints: const BoxConstraints(maxHeight: 740),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isEditMode ? Icons.edit_note_rounded : Icons.directions_car_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    tooltip: 'Close',
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                      hoverColor: AppColors.surfaceSubtle,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.border),

            // Scrollable Form Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
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
                        decoration: InputDecoration(
                          hintText: 'e.g. DHAKA-METRO-GA-11-2233',
                          prefixIcon: const Icon(Icons.pin_outlined, size: 18),
                          helperText: 'Unique identifier, uppercase only',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                      const SizedBox(height: 18),

                      // 2. Brand & Model (2 Columns)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Brand / Make *'),
                                TextFormField(
                                  controller: _brandController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Toyota, Hino',
                                    prefixIcon: const Icon(Icons.business_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  validator: (val) {
                                    final serverErr = _serverFieldErrors['brand'];
                                    if (serverErr != null) return serverErr;
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Brand is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Model *'),
                                TextFormField(
                                  controller: _modelController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Hiace, Coaster',
                                    prefixIcon: const Icon(Icons.directions_car_filled_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  validator: (val) {
                                    final serverErr = _serverFieldErrors['model'];
                                    if (serverErr != null) return serverErr;
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Model is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // 3. Manufacture Year & Vehicle Type (2 Columns)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Manufacture Year *'),
                                TextFormField(
                                  controller: _yearController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 2023',
                                    prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  validator: (val) {
                                    final serverErr = _serverFieldErrors['manufactureYear'];
                                    if (serverErr != null) return serverErr;
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Year is required';
                                    }
                                    final y = int.tryParse(val.trim());
                                    final currentYear = DateTime.now().year + 1;
                                    if (y == null || y < 1900 || y > currentYear) {
                                      return 'Enter valid year (1900-$currentYear)';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Vehicle Type *'),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedVehicleType,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.category_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  items: _vehicleTypes.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type, style: const TextStyle(fontSize: 14)),
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
                        ],
                      ),
                      const SizedBox(height: 18),

                      // 4. Color (Optional)
                      _buildLabel('Vehicle Exterior Color (Optional)'),
                      TextFormField(
                        controller: _colorController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Metallic Black, Alpine White',
                          prefixIcon: const Icon(Icons.palette_outlined, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (val) {
                          final serverErr = _serverFieldErrors['color'];
                          if (serverErr != null) return serverErr;
                          if (val != null && val.trim().length > 30) {
                            return 'Color cannot exceed 30 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modal Footer
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(isEditMode ? Icons.check_rounded : Icons.add_rounded, size: 18),
                    label: Text(
                      _isSubmitting
                          ? 'Saving...'
                          : (isEditMode ? 'Update Vehicle' : 'Register Vehicle'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
