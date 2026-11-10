import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/router/app_router.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';

Widget createAppShellTestWidget() {
  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(),
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    ),
  );
}

void main() {
  group('AppShell Responsive Navigation', () {
    testWidgets('renders desktop sidebar with nav items and soon badges on wide screens', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      AppRouter.router.go('/dashboard');
      await tester.pumpWidget(createAppShellTestWidget());
      await tester.pumpAndSettle();

      // Verify sidebar branding
      expect(find.text('STARK VMS'), findsOneWidget);
      expect(find.text('Fleet Portal'), findsOneWidget);

      // Verify primary nav items
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Vehicles'), findsOneWidget);

      // Verify disabled items with Soon badges
      expect(find.text('Drivers'), findsOneWidget);
      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Soon'), findsNWidgets(3));

      // Verify top bar on desktop
      expect(find.text('Fleet Dashboard'), findsWidgets);
      expect(find.text('Register Vehicle'), findsOneWidget);
      expect(find.text('Public Site'), findsOneWidget);

      // Navigate to Vehicles via sidebar
      await tester.tap(find.text('Vehicles'));
      await tester.pumpAndSettle();

      expect(find.text('Vehicles Directory'), findsWidgets);
    });

    testWidgets('renders mobile drawer with hamburger toggle on compact screens', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      AppRouter.router.go('/dashboard');
      await tester.pumpWidget(createAppShellTestWidget());
      await tester.pumpAndSettle();

      // Top bar title and register button
      expect(find.text('Fleet Dashboard'), findsWidgets);
      expect(find.text('Register'), findsOneWidget);

      // Sidebar should NOT be visible directly
      expect(find.text('STARK VMS'), findsNothing);

      // Open drawer via hamburger icon
      final drawerButton = find.byType(IconButton).first;
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      // Drawer is now open with sidebar content
      expect(find.text('STARK VMS'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Vehicles'), findsOneWidget);
      expect(find.text('Soon'), findsNWidgets(3));

      // Click Vehicles in drawer
      await tester.tap(find.text('Vehicles'));
      await tester.pumpAndSettle();

      // Drawer closes, navigated to Vehicles
      expect(find.text('STARK VMS'), findsNothing);
      expect(find.text('Vehicles Directory'), findsOneWidget);
    });
  });
}
