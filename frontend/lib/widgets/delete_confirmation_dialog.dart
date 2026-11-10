import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'destructive_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Vehicle vehicle;

  const DeleteConfirmationDialog({super.key, required this.vehicle});

  static Future<bool?> show(BuildContext context, Vehicle vehicle) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(vehicle: vehicle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s8),
            decoration: const BoxDecoration(
              color: AppColors.dangerTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 24),
          ),
          const SizedBox(width: AppSpacing.s12),
          const Text('Delete Vehicle?'),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to permanently remove this vehicle from the Stark Fleet database?',
            ),
            const SizedBox(height: AppSpacing.s16),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: AppColors.neutralTint,
                borderRadius: BorderRadius.circular(AppRadius.input),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.vehicleNumber,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${vehicle.brand} ${vehicle.model} • ${vehicle.company}',
                          style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s16,
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        DestructiveButton(
          onPressed: () => Navigator.of(context).pop(true),
          icon: Icons.delete,
          label: const Text('Delete Vehicle'),
        ),
      ],
    );
  }
}
