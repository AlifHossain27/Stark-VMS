import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'status_badge.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onEdit,
    this.onDelete,
  });

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
      child: Text(
        type.toUpperCase(),
        style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vehicle Number Badge
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pin_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      vehicle.vehicleNumber,
                      style: AppTextStyles.label.copyWith(
                        fontFamily: 'monospace',
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              // Vehicle Type Chip
              _buildTypeChip(vehicle.vehicleType),
              const SizedBox(width: AppSpacing.s8),
              // Status Badge
              StatusBadge(status: vehicle.status),
              const Spacer(),
              // Action Buttons (Edit and Delete)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Edit Vehicle',
                color: AppColors.primary,
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Delete Vehicle',
                color: AppColors.danger,
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          // Brand & Model
          Text(
            '${vehicle.brand} ${vehicle.model}',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppSpacing.s4),
          // Company
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.corporate_fare_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.s4),
              Text(
                vehicle.company,
                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
