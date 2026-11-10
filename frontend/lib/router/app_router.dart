import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../screens/dashboard_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/vehicle_form_screen.dart';
import '../screens/vehicle_list_screen.dart';
import '../widgets/app_shell.dart';

class AppRouter {
  AppRouter._();

  static CustomTransitionPage<void> _buildFadeTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeOut).animate(animation),
          child: child,
        );
      },
    );
  }

  static Widget Function(BuildContext, GoRouterState)? landingBuilder;
  static Widget Function(BuildContext, GoRouterState)? dashboardBuilder;

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorPageBuilder: (context, state) => _buildFadeTransitionPage(
      context: context,
      state: state,
      child: const NotFoundScreen(),
    ),
    routes: [
      // 1. Public Landing Page
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          context: context,
          state: state,
          child: landingBuilder?.call(context, state) ??
              const LandingScreen(),
        ),
      ),

      // 2. App Shell Routes
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            currentLocation: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => _buildFadeTransitionPage(
              context: context,
              state: state,
              child: dashboardBuilder?.call(context, state) ??
                  const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/vehicles',
            pageBuilder: (context, state) => _buildFadeTransitionPage(
              context: context,
              state: state,
              child: const VehicleListScreen(showNavBar: false),
            ),
            routes: [
              GoRoute(
                path: 'new',
                pageBuilder: (context, state) => _buildFadeTransitionPage(
                  context: context,
                  state: state,
                  child: const VehicleFormScreen(showAppBar: false),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                pageBuilder: (context, state) {
                  final idStr = state.pathParameters['id'];
                  final id = int.tryParse(idStr ?? '');
                  final provider = Provider.of<VehicleProvider?>(context, listen: false);
                  final vehicle = id != null
                      ? provider?.vehicles.where((v) => v.id == id).firstOrNull
                      : null;
                  return _buildFadeTransitionPage(
                    context: context,
                    state: state,
                    child: VehicleFormScreen(vehicle: vehicle, showAppBar: false),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

