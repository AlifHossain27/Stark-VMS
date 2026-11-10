import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Decorative product preview shown in the landing hero. It illustrates the
/// product surface (window chrome, overview tiles, registry rows); it is not a
/// data source and contains no live fleet data.
class HeroMockDashboard extends StatelessWidget {
  const HeroMockDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // The hero animation repeats forever, so skip it in tests where
    // pumpAndSettle would otherwise never settle.
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');

    final card = Container(
      constraints: const BoxConstraints(maxWidth: 460),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.onDarkRaisedBorder),
        boxShadow: AppShadows.cardHover,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBar(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fleet Overview', style: AppTextStyles.h3),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            'Unified registry & compliance',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s8),
                      decoration: BoxDecoration(
                        color: AppColors.neutralTint,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),

                // Overview tiles use status words, not fabricated metrics.
                const Row(
                  children: [
                    Expanded(
                      child: _MiniStat(
                        label: 'Fleet Registry',
                        value: 'Synced',
                        icon: Icons.directions_car_filled,
                      ),
                    ),
                    SizedBox(width: AppSpacing.s8),
                    Expanded(
                      child: _MiniStat(
                        label: 'System Sync',
                        value: 'Active',
                        icon: Icons.sync_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s24),

                Row(
                  children: [
                    Text(
                      'REGISTERED ASSETS',
                      style: AppTextStyles.micro.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'LIVE PREVIEW',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
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
          ),
        ],
      ),
    );

    if (reduceMotion) {
      return card;
    }

    return card
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -10,
          duration: const Duration(milliseconds: 2600),
          curve: Curves.easeInOut,
        );
  }

  /// Deep Blue application bar with the wordmark and a live pill.
  Widget _buildAppBar() {
    return Container(
      color: AppColors.deepBlue,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: const Icon(
              Icons.directions_car_filled,
              size: 14,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            'STARK VMS',
            style: AppTextStyles.label.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s8,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.onDarkRaised,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.onDarkRaisedBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Text(
                  'LIVE',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact overview tile inside the product preview.
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
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
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro,
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
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
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
