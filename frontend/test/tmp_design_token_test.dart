// TEMPORARY verification test: asserts rendered widgets carry the design
// tokens from lib/theme/ (docs/design-guidelines.md). Deleted after review.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/landing_screen.dart';
import 'package:frontend/screens/vehicle_list_screen.dart';
import 'package:frontend/services/vehicle_api_service.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/app_theme.dart' as real_theme;
import 'package:frontend/widgets/app_shell.dart';
import 'package:frontend/widgets/destructive_button.dart';
import 'package:frontend/widgets/status_badge.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

class FakeApi extends VehicleApiService {
  final List<Vehicle> vehicles;
  FakeApi(this.vehicles) : super(client: MockClient((_) async => http.Response('[]', 200)));

  @override
  Future<List<Vehicle>> getAll() async => vehicles;

  @override
  Future<List<Vehicle>> getVehicles() async => vehicles;
}

const vehicles = [
  Vehicle(
    id: 1,
    vehicleNumber: 'DHAKA-METRO-GA-11-2233',
    brand: 'Toyota',
    model: 'Hiace',
    company: 'Stark Logistics',
    vehicleType: 'VAN',
    status: 'ACTIVE',
  ),
  Vehicle(
    id: 3,
    vehicleNumber: 'DHAKA-METRO-CHA-55-6789',
    brand: 'Honda',
    model: 'Civic',
    company: 'Stark Industries',
    vehicleType: 'CAR',
    status: 'MAINTENANCE',
  ),
  Vehicle(
    id: 5,
    vehicleNumber: 'DHAKA-METRO-KHA-33-9090',
    brand: 'Hino',
    model: 'Bus',
    company: 'Stark Transit',
    vehicleType: 'BUS',
    status: 'INACTIVE',
  ),
];

Widget buildApp(VehicleApiService service, {String initial = '/dashboard'}) {
  final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(path: '/', builder: (c, s) => const LandingScreen()),
      ShellRoute(
        builder: (c, s, child) => AppShell(currentLocation: s.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
          GoRoute(path: '/vehicles', builder: (c, s) => const VehicleListScreen(showNavBar: false)),
        ],
      ),
    ],
  );
  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(apiService: service),
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: real_theme.AppTheme.lightTheme,
      routerConfig: router,
    ),
  );
}

Color? boxColor(Container c) => c.decoration is BoxDecoration
    ? (c.decoration as BoxDecoration).color
    : null;

void main() {
  test('AppTheme carries the exact palette tokens', () {
    final theme = real_theme.AppTheme.lightTheme;

    // Buttons: one primary action style; outlined uses the border token.
    expect(theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}), AppColors.primary);
    expect(theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}), AppColors.white);
    expect(theme.filledButtonTheme.style?.backgroundColor?.resolve({}), AppColors.primary);
    expect(theme.outlinedButtonTheme.style?.side?.resolve({})?.color, AppColors.border);

    // Inputs: white fill, border token, primary focus, danger error.
    final input = theme.inputDecorationTheme;
    expect(input.fillColor, AppColors.surface);
    expect(input.enabledBorder?.borderSide.color, AppColors.border);
    expect(input.focusedBorder?.borderSide.color, AppColors.primary);
    expect(input.errorBorder?.borderSide.color, AppColors.danger);
    expect(input.focusedErrorBorder?.borderSide.color, AppColors.danger);

    // Cards: white surface, 1px border token, radius 16.
    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;
    expect(theme.cardTheme.color, AppColors.surface);
    expect(cardShape.side.color, AppColors.border);
    expect(cardShape.borderRadius, BorderRadius.circular(16));

    // Navigation chrome: Deep Blue on soft gray background.
    expect(theme.appBarTheme.backgroundColor, AppColors.deepBlue);
    expect(theme.scaffoldBackgroundColor, AppColors.background);

    // Chips: neutral tint, primary when selected.
    expect(theme.chipTheme.backgroundColor, AppColors.neutralTint);
    expect(theme.chipTheme.selectedColor, AppColors.primary);
    expect(theme.chipTheme.side?.color, AppColors.border);

    // Snackbar default: Deep Blue.
    expect(theme.snackBarTheme.backgroundColor, AppColors.deepBlue);

    // Table header uses the neutral tint.
    expect(
      theme.dataTableTheme.headingRowColor?.resolve({}),
      AppColors.neutralTint,
    );
  });

  testWidgets('dashboard at 1440: deepBlue sidebar, primary selected nav, primary CTA, badge mapping', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp(FakeApi(vehicles.toList())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Sidebar surface is Deep Blue.
    final deepBlueSurfaces = find.byWidgetPredicate(
      (w) => w is Container && boxColor(w) == AppColors.deepBlue,
    );
    expect(deepBlueSurfaces, findsAtLeastNWidgets(1));

    // Selected nav item (Dashboard) is a primary-filled Material.
    final selectedMaterial = tester.widget<Material>(
      find.ancestor(of: find.text('Dashboard'), matching: find.byType(Material)).first,
    );
    expect(selectedMaterial.color, AppColors.primary);

    // The one filled primary action on the dashboard.
    final cta = tester.widget<ElevatedButton>(find.byType(ElevatedButton).first);
    expect(cta.style?.backgroundColor?.resolve({}), AppColors.primary);

    // Status badges map per the guidelines table.
    for (final badge in tester.widgetList<StatusBadge>(find.byType(StatusBadge))) {
      final badgeFinder = find.byWidget(badge);
      final bg = boxColor(tester.widget<Container>(
        find.descendant(of: badgeFinder, matching: find.byType(Container)).first,
      ));
      final text = tester.widget<Text>(find.descendant(of: badgeFinder, matching: find.byType(Text)).first);
      final fg = text.style?.color;

      switch (badge.status) {
        case 'ACTIVE':
          expect(bg, AppColors.successTint);
          expect(fg, AppColors.success);
        case 'MAINTENANCE':
          expect(bg, AppColors.primaryTint);
          expect(fg, AppColors.primary);
        case 'INACTIVE':
          expect(bg, AppColors.neutralTint);
          expect(fg, AppColors.textPrimary);
      }
    }
  });

  testWidgets('vehicle list at 1440: ALL filter chip selected, primary selected color', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp(FakeApi(vehicles.toList()), initial: '/vehicles'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final allChip = tester.widget<FilterChip>(
      find.ancestor(of: find.text('ALL'), matching: find.byType(FilterChip)),
    );
    expect(allChip.selected, true);
    expect(real_theme.AppTheme.lightTheme.chipTheme.selectedColor, AppColors.primary);
  });

  testWidgets('delete dialog uses the destructive (danger) button', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp(FakeApi(vehicles.toList()), initial: '/vehicles'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    final destructive = tester.widget<FilledButton>(
      find.descendant(of: find.byType(DestructiveButton), matching: find.byType(FilledButton)).first,
    );
    expect(destructive.style?.backgroundColor?.resolve({}), AppColors.danger);
    expect(destructive.style?.foregroundColor?.resolve({}), AppColors.white);
  });
}
