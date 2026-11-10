import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 860;

    final steps = [
      _StepData(
        number: '01',
        title: 'Register vehicles',
        description: 'Input registration numbers, specifications, vehicle categories, and color attributes into the secure central database.',
        icon: Icons.app_registration_rounded,
      ),
      _StepData(
        number: '02',
        title: 'Track documents & service',
        description: 'Attach registration certificates, fitness, and tax tokens with scheduled expiry monitors and maintenance logs.',
        icon: Icons.verified_user_outlined,
      ),
      _StepData(
        number: '03',
        title: 'Monitor from the dashboard',
        description: 'Review real-time fleet health, active asset distribution, and maintenance alerts from one unified control center.',
        icon: Icons.analytics_outlined,
      ),
    ];

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildStepItem(steps[0])),
          _buildDesktopConnector(),
          Expanded(child: _buildStepItem(steps[1])),
          _buildDesktopConnector(),
          Expanded(child: _buildStepItem(steps[2])),
        ],
      );
    }

    return Column(
      children: [
        _buildStepItem(steps[0]),
        _buildMobileConnector(),
        _buildStepItem(steps[1]),
        _buildMobileConnector(),
        _buildStepItem(steps[2]),
      ],
    );
  }

  Widget _buildStepItem(_StepData step) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  step.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              Icon(step.icon, size: 24, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 18),
          Text(step.title, style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
          const SizedBox(height: 8),
          Text(
            step.description,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopConnector() {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: Container(
        height: 2,
        color: AppColors.border,
      ),
    );
  }

  Widget _buildMobileConnector() {
    return Container(
      height: 24,
      width: 2,
      color: AppColors.border,
    );
  }
}

class _StepData {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  _StepData({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}

