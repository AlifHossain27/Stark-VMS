import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/screens/vehicle_form_screen.dart';
import 'package:frontend/services/api_exception.dart';
import 'package:frontend/services/vehicle_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

class MockVehicleApiService extends VehicleApiService {
  final Future<Vehicle> Function(Map<String, dynamic>)? onCreate;
  final Future<Vehicle> Function(int, Map<String, dynamic>)? onUpdate;

  MockVehicleApiService({this.onCreate, this.onUpdate})
      : super(client: MockClient((_) async => http.Response('[]', 200)));

  @override
  Future<Vehicle> create(Map<String, dynamic> vehicleData) async {
    if (onCreate != null) {
      return onCreate!(vehicleData);
    }
    return Vehicle(
      id: 10,
      vehicleNumber: vehicleData['vehicleNumber'] as String,
      brand: vehicleData['brand'] as String,
      model: vehicleData['model'] as String,
      company: vehicleData['company'] as String? ?? 'Stark Logistics',
      vehicleType: vehicleData['vehicleType'] as String? ?? 'CAR',
      status: vehicleData['status'] as String? ?? 'ACTIVE',
    );
  }

  @override
  Future<Vehicle> update(int id, Map<String, dynamic> vehicleData) async {
    if (onUpdate != null) {
      return onUpdate!(id, vehicleData);
    }
    return Vehicle(
      id: id,
      vehicleNumber: vehicleData['vehicleNumber'] as String,
      brand: vehicleData['brand'] as String,
      model: vehicleData['model'] as String,
      company: vehicleData['company'] as String? ?? 'Stark Logistics',
      vehicleType: vehicleData['vehicleType'] as String? ?? 'CAR',
      status: vehicleData['status'] as String? ?? 'ACTIVE',
    );
  }

  @override
  Future<List<Vehicle>> getAll() async => [];
}

Widget createFormTestWidget({
  Vehicle? vehicle,
  VehicleApiService? apiService,
}) {
  return ChangeNotifierProvider(
    create: (_) => VehicleProvider(apiService: apiService ?? MockVehicleApiService()),
    child: MaterialApp(
      home: VehicleFormScreen(vehicle: vehicle),
    ),
  );
}

void main() {
  group('VehicleFormScreen', () {
    testWidgets('client-side validation blocks empty submission', (tester) async {
      await tester.pumpWidget(createFormTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Register New Vehicle'), findsWidgets);

      // Scroll to Register Vehicle button and tap
      final submitButton = find.text('Register Vehicle');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Vehicle number is required'), findsOneWidget);
      expect(find.text('Brand is required'), findsOneWidget);
      expect(find.text('Model is required'), findsOneWidget);
      expect(find.text('Company is required'), findsOneWidget);
    });

    testWidgets('pre-populates fields in Edit mode', (tester) async {
      const existing = Vehicle(
        id: 5,
        vehicleNumber: 'DHAKA-METRO-GA-11-2233',
        brand: 'Toyota',
        model: 'Hiace',
        company: 'Stark Logistics',
        vehicleType: 'VAN',
        status: 'ACTIVE',
      );

      await tester.pumpWidget(createFormTestWidget(vehicle: existing));
      await tester.pumpAndSettle();

      expect(find.text('Edit Vehicle'), findsWidgets);
      expect(find.text('DHAKA-METRO-GA-11-2233'), findsOneWidget);
      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('Hiace'), findsOneWidget);
      expect(find.text('Stark Logistics'), findsOneWidget);
      expect(find.text('Update Vehicle'), findsOneWidget);
    });

    testWidgets('displays server fieldError inline for duplicate vehicle number (409)', (tester) async {
      final mockService = MockVehicleApiService(
        onCreate: (data) async {
          throw ApiException(
            statusCode: 409,
            message: 'Vehicle number already exists',
            fieldErrors: {'vehicleNumber': 'Vehicle number already exists in fleet'},
          );
        },
      );

      await tester.pumpWidget(createFormTestWidget(apiService: mockService));
      await tester.pumpAndSettle();

      // Enter valid form fields: 0=number, 1=brand, 2=model, 3=company
      await tester.enterText(find.byType(TextFormField).at(0), 'DHAKA-METRO-GA-11-2233');
      await tester.enterText(find.byType(TextFormField).at(1), 'Toyota');
      await tester.enterText(find.byType(TextFormField).at(2), 'Hiace');
      await tester.enterText(find.byType(TextFormField).at(3), 'Stark Logistics');

      // Submit
      final submitButton = find.text('Register Vehicle');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify server field error is displayed inline under vehicle number
      expect(find.text('Vehicle number already exists in fleet'), findsOneWidget);
    });
  });
}
