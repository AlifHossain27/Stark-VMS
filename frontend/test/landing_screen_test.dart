import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/router/app_router.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';

Widget createLandingTestWidget() {
  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(),
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    ),
  );
}

void main() {
  group('LandingScreen Content & Navigation', () {
    testWidgets('renders all required landing page sections and elements', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      AppRouter.router.go('/');
      await tester.pumpWidget(createLandingTestWidget());
      await tester.pumpAndSettle();

      // 1. Top Bar
      expect(find.text('STARK VMS'), findsWidgets);
      expect(find.text('Features'), findsOneWidget);
      expect(find.text('How It Works'), findsOneWidget);
      expect(find.text('Open Dashboard'), findsWidgets);

      // 2. Hero Section
      expect(find.text('Enterprise Fleet Control Built for Stark Group'), findsOneWidget);
      expect(find.text('Go to Dashboard'), findsOneWidget);
      expect(find.text('View Vehicles'), findsOneWidget);

      // 3. Stats Strip (3 text-only value statements, no fake numbers)
      expect(find.text('Track every vehicle'), findsOneWidget);
      expect(find.text('Never miss an expiry'), findsOneWidget);
      expect(find.text('One place for your fleet'), findsOneWidget);

      // 4. Features Section (6 features, 5 coming soon)
      expect(find.text('Vehicle Registry'), findsOneWidget);
      expect(find.text('Documents & Expiry Tracking'), findsOneWidget);
      expect(find.text('Maintenance History'), findsWidgets);
      expect(find.text('Driver Assignment'), findsOneWidget);
      expect(find.text('Search & Server Filters'), findsOneWidget);
      expect(find.text('Dashboard Insights'), findsOneWidget);
      expect(find.text('Coming soon'), findsNWidgets(5));
      expect(find.text('Active'), findsWidgets);

      // 5. How It Works Section (3 steps)
      expect(find.text('Register vehicles'), findsOneWidget);
      expect(find.text('Track documents & service'), findsOneWidget);
      expect(find.text('Monitor from the dashboard'), findsOneWidget);

      // 6. CTA Banner
      expect(find.text('Ready to Streamline Your Fleet Operations?'), findsOneWidget);

      // 7. Footer
      expect(find.textContaining('Stark Group VMS'), findsWidgets);
      expect(find.text('Back to top'), findsOneWidget);
    });

    testWidgets('hero buttons navigate to /dashboard and /vehicles', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      AppRouter.router.go('/');
      await tester.pumpWidget(createLandingTestWidget());
      await tester.pumpAndSettle();

      // Click Go to Dashboard
      await tester.tap(find.text('Go to Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Fleet Dashboard'), findsWidgets);

      // Go back to landing
      AppRouter.router.go('/');
      await tester.pumpAndSettle();

      // Click View Vehicles
      await tester.tap(find.text('View Vehicles'));
      await tester.pumpAndSettle();

      expect(find.text('Vehicles Directory'), findsWidgets);
    });
  });
}
