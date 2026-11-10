import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class HeroMockDashboard extends StatelessWidget {
  const HeroMockDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');

    final card = Container(
      width: 440,
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.cardHover,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: AppColors.border, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.s4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: AppColors.border, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.s4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: AppColors.border, shape: BoxShape.circle),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutralTint,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 12, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      'Stark Fleet Live',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),

          // Mini Metric Cards
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  label: 'Fleet Size',
                  value: 'Live DB',
                  icon: Icons.directions_car,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _buildMiniStat(
                  label: 'System Sync',
                  value: 'Active',
                  icon: Icons.sync,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),

          // Mock Vehicle Rows
          Text(
            'ACTIVE ASSETS PREVIEW',
            style: AppTextStyles.micro.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          const _MockVehicleRow(
            number: 'DHAKA-METRO-GA-11-2233',
            name: 'Toyota Hiace',
            type: 'VAN',
          ),
          const SizedBox(height: AppSpacing.s8),
          const _MockVehicleRow(
            number: 'DHAKA-METRO-BA-12-3456',
            name: 'Hino 1J Bus',
            type: 'BUS',
          ),
        ],
      ),
    );

    if (reduceMotion) {
      return card;
    }

    return card
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: const Duration(milliseconds: 2600), curve: Curves.easeInOut);
  }

  Widget _buildMiniStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutralTint,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Icon(icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.micro,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mock vehicle row for the hero illustration. The green dot denotes the
/// ACTIVE status of the illustrated assets (green = ACTIVE only).
class _MockVehicleRow extends StatelessWidget {
  final String number;
  final String name;
  final String type;

  const _MockVehicleRow({
    required this.number,
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutralTint,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              type,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  number,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
