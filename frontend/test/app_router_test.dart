import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/router/app_router.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';

Widget createRouterTestApp({String initialLocation = '/'}) {
  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(),
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    ),
  );
}

void main() {
  group('AppRouter & Theme', () {
    testWidgets('initial route loads landing page at /', (tester) async {
      AppRouter.router.go('/');
      await tester.pumpWidget(createRouterTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Enterprise Fleet Control Built for Stark Group'), findsOneWidget);
    });

    testWidgets('navigates to /dashboard', (tester) async {
      AppRouter.router.go('/dashboard');
      await tester.pumpWidget(createRouterTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Fleet Dashboard'), findsWidgets);
      expect(find.text('Operations Command'), findsOneWidget);
    });

    testWidgets('navigates to /vehicles', (tester) async {
      AppRouter.router.go('/vehicles');
      await tester.pumpWidget(createRouterTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Vehicles Directory'), findsWidgets);
    });

    testWidgets('navigates to /vehicles/new', (tester) async {
      AppRouter.router.go('/vehicles/new');
      await tester.pumpWidget(createRouterTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Register Vehicle'), findsWidgets);
      expect(find.text('Vehicle Registration Number *'), findsOneWidget);
    });

    testWidgets('navigates to /vehicles/:id/edit with parameter', (tester) async {
      AppRouter.router.go('/vehicles/42/edit');
      await tester.pumpWidget(createRouterTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Edit Vehicle'), findsWidgets);
      expect(find.text('Vehicle Registration Number *'), findsOneWidget);
    });

    testWidgets('navigates to unknown route displays 404 screen', (tester) async {
      AppRouter.router.go('/unknown-nonexistent-path');
      await tester.pumpWidget(createRouterTestApp());
      await tester.pumpAndSettle();

      expect(find.text('404 ERROR'), findsOneWidget);
      expect(find.text('Page Not Found'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);

      // Tap Back to Home
      await tester.tap(find.text('Back to Home'));
      await tester.pumpAndSettle();

      expect(find.text('Enterprise Fleet Control Built for Stark Group'), findsOneWidget);
    });
  });
}

