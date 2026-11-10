import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/widgets/footer/back_to_top_button.dart';
import 'package:frontend/widgets/footer/site_footer.dart';
import 'package:go_router/go_router.dart';

Widget createFooterTestWidget({
  VoidCallback? onBackToTop,
  Size size = const Size(1280, 800),
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: SingleChildScrollView(
            child: SiteFooter(onBackToTop: onBackToTop),
          ),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Scaffold(body: Text('Target Dashboard')),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const Scaffold(body: Text('Target Vehicles')),
      ),
    ],
  );

  return MaterialApp.router(
    theme: AppTheme.lightTheme,
    routerConfig: router,
  );
}

void main() {
  group('SiteFooter', () {
    testWidgets('renders all 4 columns, links, soon badges, and copyright on desktop', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createFooterTestWidget());
      await tester.pumpAndSettle();

      // 1. Brand Block
      expect(find.text('STARK VMS'), findsOneWidget);
      expect(
        find.textContaining('Enterprise fleet control, vehicle asset tracking'),
        findsOneWidget,
      );
      expect(find.text('Open Dashboard'), findsOneWidget);

      // 2. Product Column
      expect(find.text('PRODUCT'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Vehicles'), findsOneWidget);
      expect(find.text('Register Vehicle'), findsOneWidget);

      // 3. Features Column with Soon Badges
      expect(find.text('FEATURES'), findsOneWidget);
      expect(find.text('Documents & Expiry'), findsOneWidget);
      expect(find.text('Maintenance History'), findsOneWidget);
      expect(find.text('Driver Assignment'), findsOneWidget);
      expect(find.text('Soon'), findsNWidgets(3));

      // 4. Resources Column
      expect(find.text('RESOURCES'), findsOneWidget);
      expect(find.text('About this project'), findsOneWidget);
      expect(find.text('Course / Assignment'), findsOneWidget);
      expect(find.text('GitHub Repository'), findsOneWidget);

      // 5. Bottom Bar
      final year = DateTime.now().year;
      expect(find.textContaining('© $year Stark Group VMS'), findsOneWidget);
      expect(find.text('Back to top'), findsOneWidget);
    });

    testWidgets('Soon items do not navigate or invoke actions when tapped', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createFooterTestWidget());
      await tester.pumpAndSettle();

      // Tap on a Soon item (Documents & Expiry)
      await tester.tap(find.text('Documents & Expiry'));
      await tester.pumpAndSettle();

      // Should still be on the same page with SiteFooter, no navigation occurred
      expect(find.text('STARK VMS'), findsOneWidget);
    });

    testWidgets('Back to top button triggers callback', (tester) async {
      bool scrolledToTop = false;

      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createFooterTestWidget(
        onBackToTop: () => scrolledToTop = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BackToTopButton));
      await tester.pumpAndSettle();

      expect(scrolledToTop, isTrue);
    });

    testWidgets('navigates to dashboard from Open Dashboard button', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createFooterTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Target Dashboard'), findsOneWidget);
    });

    testWidgets('renders cleanly on tablet (800px) and mobile (390px) without overflow', (tester) async {
      // 1. Tablet View (800px)
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createFooterTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('STARK VMS'), findsOneWidget);
      expect(find.text('PRODUCT'), findsOneWidget);
      expect(find.text('FEATURES'), findsOneWidget);
      expect(find.text('RESOURCES'), findsOneWidget);

      // 2. Mobile View (390px)
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createFooterTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('STARK VMS'), findsOneWidget);
      expect(find.text('PRODUCT'), findsOneWidget);
      expect(find.text('FEATURES'), findsOneWidget);
      expect(find.text('RESOURCES'), findsOneWidget);
      expect(find.text('Back to top'), findsOneWidget);
    });
  });
}

