import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/services/api_exception.dart';
import 'package:frontend/services/vehicle_api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

class FakeSuccessVehicleApiService extends VehicleApiService {
  final List<Vehicle> mockVehicles;
  FakeSuccessVehicleApiService(this.mockVehicles)
      : super(client: MockClient((_) async => http.Response('[]', 200)));

  @override
  Future<List<Vehicle>> getAll() async => mockVehicles;

  @override
  Future<List<Vehicle>> getVehicles() async => mockVehicles;
}

class FakeErrorVehicleApiService extends VehicleApiService {
  final String errorMsg;
  FakeErrorVehicleApiService(this.errorMsg)
      : super(client: MockClient((_) async => http.Response('error', 500)));

  @override
  Future<List<Vehicle>> getAll() async {
    throw ApiException(statusCode: 500, message: errorMsg);
  }

  @override
  Future<List<Vehicle>> getVehicles() async {
    throw ApiException(statusCode: 500, message: errorMsg);
  }
}

Widget createDashboardTestWidget(VehicleApiService apiService) {
  final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const Scaffold(body: Text('Vehicles Target Screen')),
      ),
      GoRoute(
        path: '/vehicles/new',
        builder: (context, state) => const Scaffold(body: Text('New Vehicle Target Screen')),
      ),
      GoRoute(
        path: '/vehicles/:id/edit',
        builder: (context, state) => Scaffold(body: Text('Edit Vehicle Target Screen ${state.pathParameters['id']}')),
      ),
    ],
  );

  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(apiService: apiService),
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  final sampleVehicles = [
    const Vehicle(
      id: 1,
      vehicleNumber: 'DHAKA-METRO-GA-11-2233',
      brand: 'Toyota',
      model: 'Hiace',
      manufactureYear: 2022,
      vehicleType: 'VAN',
      color: 'White',
    ),
    const Vehicle(
      id: 2,
      vehicleNumber: 'DHAKA-METRO-BA-12-3456',
      brand: 'Hino',
      model: '1J Bus',
      manufactureYear: 2021,
      vehicleType: 'BUS',
      color: 'Blue',
    ),
    const Vehicle(
      id: 3,
      vehicleNumber: 'DHAKA-METRO-TA-99-8877',
      brand: 'Isuzu',
      model: 'Forward',
      manufactureYear: 2023,
      vehicleType: 'TRUCK',
      color: 'Silver',
    ),
  ];

  group('DashboardScreen', () {
    testWidgets('renders empty state when no vehicles are in fleet', (tester) async {
      final fakeService = FakeSuccessVehicleApiService([]);
      await tester.pumpWidget(createDashboardTestWidget(fakeService));
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Operations Command'), findsOneWidget);
      expect(find.text('Register vehicle'), findsOneWidget);
      expect(find.text('View vehicles'), findsOneWidget);

      // Real summary card shows 0
      expect(find.text('Total vehicles'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Live Data'), findsOneWidget);

      // Assignment 2 placeholder cards (no fake numbers, marked "Coming soon")
      expect(find.text('Active vehicles'), findsOneWidget);
      expect(find.text('Under maintenance'), findsOneWidget);
      expect(find.text('Documents expiring soon'), findsOneWidget);
      expect(find.text('Maintenance this month'), findsOneWidget);
      expect(find.text('Coming soon'), findsNWidgets(4));
      expect(find.text('--'), findsNWidgets(4));

      // Recent vehicles empty state
      expect(find.text('Recent Vehicles'), findsOneWidget);
      expect(find.text('No vehicles registered yet'), findsOneWidget);
      expect(find.text('Add vehicle'), findsOneWidget);
    });

    testWidgets('renders live vehicle count and recent vehicles list when data exists', (tester) async {
      final fakeService = FakeSuccessVehicleApiService(sampleVehicles);
      await tester.pumpWidget(createDashboardTestWidget(fakeService));
      await tester.pumpAndSettle();

      // Real card shows live count 3
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Total vehicles'), findsOneWidget);

      // Recent vehicles list displays vehicle rows
      expect(find.text('Toyota Hiace'), findsOneWidget);
      expect(find.text('DHAKA-METRO-GA-11-2233'), findsOneWidget);
      expect(find.text('Hino 1J Bus'), findsOneWidget);
      expect(find.text('Isuzu Forward'), findsOneWidget);

      // Muted placeholder cards still show Coming soon and --
      expect(find.text('Coming soon'), findsNWidgets(4));
      expect(find.text('--'), findsNWidgets(4));
    });

    testWidgets('renders error state when API fails with retry button', (tester) async {
      final fakeService = FakeErrorVehicleApiService('Network failure connecting to Neon DB');
      await tester.pumpWidget(createDashboardTestWidget(fakeService));
      await tester.pumpAndSettle();

      // Total vehicles card shows error
      expect(find.text('Failed to load'), findsOneWidget);

      // Recent vehicles shows error and retry button
      expect(find.text('Network failure connecting to Neon DB'), findsOneWidget);
      expect(find.text('Retry'), findsWidgets);
    });

    testWidgets('quick action and view all buttons navigate correctly', (tester) async {
      final fakeService = FakeSuccessVehicleApiService(sampleVehicles);
      await tester.pumpWidget(createDashboardTestWidget(fakeService));
      await tester.pumpAndSettle();

      // Click "Register vehicle" button (now opens modal dialog)
      await tester.tap(find.text('Register vehicle'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Vehicle Registration Number *'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);

      // Click "View all" in recent vehicles panel
      await tester.ensureVisible(find.text('View all'));
      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();
      expect(find.text('Vehicles Target Screen'), findsOneWidget);
    });
  });
}
