import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/api_exception.dart';
import 'package:frontend/services/vehicle_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('VehicleApiService', () {
    test('getAll returns list of vehicles on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/vehicles');
        expect(request.method, 'GET');
        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'vehicleNumber': 'DHAKA-METRO-GA-11-2233',
              'brand': 'Toyota',
              'model': 'Hiace',
              'company': 'Stark Logistics',
              'vehicleType': 'VAN',
              'status': 'ACTIVE',
            }
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');
      final vehicles = await service.getAll();

      expect(vehicles.length, 1);
      expect(vehicles.first.vehicleNumber, 'DHAKA-METRO-GA-11-2233');
      expect(vehicles.first.company, 'Stark Logistics');
    });

    test('getById returns single vehicle on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/vehicles/1');
        return http.Response(
          jsonEncode({
            'id': 1,
            'vehicleNumber': 'DHAKA-METRO-GA-11-2233',
            'brand': 'Toyota',
            'model': 'Hiace',
            'company': 'Stark Logistics',
            'vehicleType': 'VAN',
            'status': 'ACTIVE',
          }),
          200,
        );
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');
      final vehicle = await service.getById(1);

      expect(vehicle.id, 1);
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.company, 'Stark Logistics');
    });

    test('create returns created vehicle on 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/vehicles');
        expect(request.method, 'POST');
        return http.Response(
          jsonEncode({
            'id': 99,
            'vehicleNumber': 'DHAKA-METRO-BA-99-8877',
            'brand': 'Honda',
            'model': 'Civic',
            'company': 'Stark Transit',
            'vehicleType': 'CAR',
            'status': 'ACTIVE',
          }),
          201,
        );
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');
      final vehicle = await service.create({
        'vehicleNumber': 'DHAKA-METRO-BA-99-8877',
        'brand': 'Honda',
        'model': 'Civic',
        'company': 'Stark Transit',
        'vehicleType': 'CAR',
        'status': 'ACTIVE',
      });

      expect(vehicle.id, 99);
      expect(vehicle.vehicleNumber, 'DHAKA-METRO-BA-99-8877');
      expect(vehicle.company, 'Stark Transit');
    });

    test('create throws ApiException with fieldErrors on 409 conflict', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'timestamp': '2026-11-09T12:00:00Z',
            'status': 409,
            'error': 'Conflict',
            'message': 'Vehicle number DHAKA-METRO-GA-11-2233 already exists',
            'fieldErrors': {'vehicleNumber': 'already exists'},
          }),
          409,
        );
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');

      expect(
        () => service.create({'vehicleNumber': 'DHAKA-METRO-GA-11-2233'}),
        throwsA(isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 409)
            .having((e) => e.fieldErrors['vehicleNumber'], 'vehicleNumber error', 'already exists')),
      );
    });

    test('update returns updated vehicle on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/vehicles/1');
        expect(request.method, 'PUT');
        return http.Response(
          jsonEncode({
            'id': 1,
            'vehicleNumber': 'DHAKA-METRO-GA-11-2233',
            'brand': 'Toyota',
            'model': 'Hiace Updated',
            'company': 'Stark Logistics',
            'vehicleType': 'VAN',
            'status': 'MAINTENANCE',
          }),
          200,
        );
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');
      final updated = await service.update(1, {'model': 'Hiace Updated'});

      expect(updated.model, 'Hiace Updated');
      expect(updated.status, 'MAINTENANCE');
    });

    test('delete returns without error on 204', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/vehicles/1');
        expect(request.method, 'DELETE');
        return http.Response('', 204);
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');
      await service.delete(1);
    });

    test('delete throws ApiException on 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'status': 404,
            'message': 'Vehicle not found with id 99',
          }),
          404,
        );
      });

      final service = VehicleApiService(client: mockClient, baseUrl: 'http://test-server');

      expect(
        () => service.delete(99),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
      );
    });
  });
}
