// TEMPORARY file for design-system visual verification only.
// Renders the real app (real router wiring, real theme) at 1440px and
// 390px and writes screenshots to goldens/tmp/. Deleted after review.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/landing_screen.dart';
import 'package:frontend/screens/vehicle_form_screen.dart';
import 'package:frontend/screens/vehicle_list_screen.dart';
import 'package:frontend/services/api_exception.dart';
import 'package:frontend/services/vehicle_api_service.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/widgets/app_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

// Real vehicles currently in the production database (fetched live from
// the API during this verification session) so screenshots show real data.
final List<Vehicle> _dbVehicles = [
  const Vehicle(
    id: 1,
    vehicleNumber: 'DHAKA-METRO-GA-11-2233',
    brand: 'Toyota',
    model: 'Hiace',
    company: 'Stark Logistics',
    vehicleType: 'VAN',
    status: 'ACTIVE',
  ),
  const Vehicle(
    id: 3,
    vehicleNumber: 'DHAKA-METRO-CHA-55-6789',
    brand: 'Honda',
    model: 'Civic',
    company: 'Stark Industries',
    vehicleType: 'CAR',
    status: 'MAINTENANCE',
  ),
  const Vehicle(
    id: 4,
    vehicleNumber: 'DHAKA-METRO-KHA-11-2212',
    brand: 'Audi',
    model: 'None',
    company: 'Stark Industries',
    vehicleType: 'CAR',
    status: 'ACTIVE',
  ),
];

class FakeSuccessVehicleApiService extends VehicleApiService {
  FakeSuccessVehicleApiService()
      : super(client: MockClient((_) async => http.Response('[]', 200)));

  @override
  Future<List<Vehicle>> getAll() async => _dbVehicles;

  @override
  Future<List<Vehicle>> getVehicles() async => _dbVehicles;
}

class FakeErrorVehicleApiService extends VehicleApiService {
  FakeErrorVehicleApiService()
      : super(client: MockClient((_) async => http.Response('error', 500)));

  @override
  Future<List<Vehicle>> getAll() async =>
      throw ApiException(statusCode: 500, message: 'Connection refused: the fleet database is unreachable.');

  @override
  Future<List<Vehicle>> getVehicles() async =>
      throw ApiException(statusCode: 500, message: 'Connection refused: the fleet database is unreachable.');
}

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

const String _sdkFonts =
    r'F:\Softwares\Flutter\src\flutter\bin\cache\artifacts\material_fonts';

/// Router under test, assigned by [buildApp] so tests can navigate.
GoRouter? _router;

/// Builds the app exactly like main.dart (same router wiring, same theme)
/// but with an injectable API service for deterministic data.
Widget buildApp(VehicleApiService service) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const LandingScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(
          currentLocation: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (c, s) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/vehicles',
            builder: (c, s) => const VehicleListScreen(showNavBar: false),
            routes: [
              GoRoute(
                path: 'new',
                builder: (c, s) => const VehicleFormScreen(showAppBar: false),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  _router = router;

  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(apiService: service),
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  setUpAll(() async {
    // Real fonts so screenshots are readable instead of Ahem blocks.
    await _loadFont('Roboto', [
      '$_sdkFonts\\Roboto-Regular.ttf',
      '$_sdkFonts\\Roboto-Medium.ttf',
      '$_sdkFonts\\Roboto-Bold.ttf',
      '$_sdkFonts\\Roboto-Black.ttf',
    ]);
    await _loadFont('MaterialIcons', ['$_sdkFonts\\MaterialIcons-Regular.otf']);
    await _loadFont('monospace', [r'C:\Windows\Fonts\consola.ttf']);
  });

  Future<void> setView(WidgetTester tester, double width, double height) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('landing desktop 1440', (tester) async {
    await setView(tester, 1440, 3400);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    // Fixed pumps: the landing page contains a repeating animation, so
    // pumpAndSettle would never settle.
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/landing_desktop.png'));
  });

  testWidgets('dashboard desktop 1440', (tester) async {
    await setView(tester, 1440, 1700);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/dashboard');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/dashboard_desktop.png'));
  });

  testWidgets('vehicles table desktop 1440', (tester) async {
    await setView(tester, 1440, 1500);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/vehicles_desktop.png'));
  });

  testWidgets('register dialog desktop 1440', (tester) async {
    await setView(tester, 1440, 1000);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Register vehicle').last);
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/register_dialog_desktop.png'));
  });

  testWidgets('edit dialog desktop 1440', (tester) async {
    await setView(tester, 1440, 1000);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/edit_dialog_desktop.png'));
  });

  testWidgets('delete dialog desktop 1440', (tester) async {
    await setView(tester, 1440, 900);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/delete_dialog_desktop.png'));
  });

  testWidgets('form screen desktop 1440', (tester) async {
    await setView(tester, 1440, 1500);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles/new');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/form_screen_desktop.png'));
  });

  testWidgets('error state desktop 1440', (tester) async {
    await setView(tester, 1440, 1000);
    await tester.pumpWidget(buildApp(FakeErrorVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/error_desktop.png'));
  });

  testWidgets('landing mobile 390', (tester) async {
    await setView(tester, 390, 5200);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/landing_mobile.png'));
  });

  testWidgets('dashboard mobile 390', (tester) async {
    await setView(tester, 390, 2000);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/dashboard');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/dashboard_mobile.png'));
  });

  testWidgets('vehicles cards mobile 390', (tester) async {
    await setView(tester, 390, 2000);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/vehicles_mobile.png'));
  });

  testWidgets('form screen mobile 390', (tester) async {
    await setView(tester, 390, 1800);
    await tester.pumpWidget(buildApp(FakeSuccessVehicleApiService()));
    await tester.pump();
    _router!.go('/vehicles/new');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/tmp/form_screen_mobile.png'));
  });
}
