import 'package:flutter/material.dart';
import '../../config/links.dart';

class FooterLinkItem {
  final String label;
  final String? route;
  final String? externalUrl;
  final bool isSoon;
  final IconData? icon;
  final VoidCallback? onCustomTap;

  const FooterLinkItem({
    required this.label,
    this.route,
    this.externalUrl,
    this.isSoon = false,
    this.icon,
    this.onCustomTap,
  });
}

class FooterLinkData {
  FooterLinkData._();

  static List<FooterLinkItem> getProductLinks({VoidCallback? onOpenRegisterModal}) {
    return [
      const FooterLinkItem(
        label: 'Dashboard',
        route: '/dashboard',
        icon: Icons.dashboard_outlined,
      ),
      const FooterLinkItem(
        label: 'Vehicles',
        route: '/vehicles',
        icon: Icons.directions_car_outlined,
      ),
      FooterLinkItem(
        label: 'Register Vehicle',
        route: '/vehicles/new',
        icon: Icons.add_circle_outline,
        onCustomTap: onOpenRegisterModal,
      ),
    ];
  }

  static const List<FooterLinkItem> featureLinks = [
    FooterLinkItem(
      label: 'Documents & Expiry',
      isSoon: true,
      icon: Icons.document_scanner_outlined,
    ),
    FooterLinkItem(
      label: 'Maintenance History',
      isSoon: true,
      icon: Icons.car_repair_outlined,
    ),
    FooterLinkItem(
      label: 'Driver Assignment',
      isSoon: true,
      icon: Icons.badge_outlined,
    ),
  ];

  static const List<FooterLinkItem> resourceLinks = [
    FooterLinkItem(
      label: 'About Stark VMS',
      externalUrl: ProjectLinks.aboutUrl,
      icon: Icons.info_outline,
    ),
  ];
}

