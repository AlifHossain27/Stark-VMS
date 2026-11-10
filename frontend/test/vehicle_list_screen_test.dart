import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/screens/vehicle_list_screen.dart';
import 'package:frontend/services/api_exception.dart';
import 'package:frontend/services/vehicle_api_service.dart';
import 'package:provider/provider.dart';

import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

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

Widget createTestWidget(
  VehicleApiService apiService, {
  void Function(BuildContext, [Vehicle?])? onNavigateToForm,
  void Function(BuildContext, Vehicle)? onDeleteVehicle,
}) {
  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(apiService: apiService),
    child: MaterialApp(
      home: VehicleListScreen(
        onNavigateToForm: onNavigateToForm,
        onDeleteVehicle: onDeleteVehicle,
      ),
    ),
  );
}

void main() {
  testWidgets('displays empty state with add button when no vehicles exist', (tester) async {
    final fakeService = FakeSuccessVehicleApiService([]);
    await tester.pumpWidget(createTestWidget(fakeService));
    await tester.pumpAndSettle();

    expect(find.text('No vehicles registered yet'), findsOneWidget);
    expect(find.text('Get started by adding your first vehicle asset to the Stark Group fleet.'), findsOneWidget);
    expect(find.text('Register vehicle'), findsWidgets);
  });

  testWidgets('displays vehicle data with edit and delete action buttons', (tester) async {
    final vehicles = [
      const Vehicle(
        id: 1,
        vehicleNumber: 'DHAKA-METRO-GA-11-2233',
        brand: 'Toyota',
        model: 'Hiace',
        manufactureYear: 2019,
        vehicleType: 'VAN',
        color: 'White',
      ),
    ];

    final fakeService = FakeSuccessVehicleApiService(vehicles);
    await tester.pumpWidget(createTestWidget(fakeService));
    await tester.pumpAndSettle();

    expect(find.text('DHAKA-METRO-GA-11-2233'), findsOneWidget);
    expect(find.text('Toyota Hiace'), findsOneWidget);
    expect(find.text('VAN'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
  });

  testWidgets('displays error state with retry connection button on failure', (tester) async {
    final fakeService = FakeErrorVehicleApiService('Failed to connect to backend server');
    await tester.pumpWidget(createTestWidget(fakeService));
    await tester.pumpAndSettle();

    expect(find.text('Unable to Load Fleet Data'), findsOneWidget);
    expect(find.text('Failed to connect to backend server'), findsOneWidget);
    expect(find.text('Retry connection'), findsOneWidget);
  });
}
