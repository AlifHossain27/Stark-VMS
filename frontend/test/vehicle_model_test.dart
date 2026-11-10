import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/services/api_exception.dart';

void main() {
  group('Vehicle Model', () {
    test('fromJson and toJson match contract exactly', () {
      final json = {
        'id': 1,
        'vehicleNumber': 'DHAKA-METRO-GA-11-2233',
        'brand': 'Toyota',
        'model': 'Hiace',
        'manufactureYear': 2019,
        'vehicleType': 'VAN',
        'color': 'White',
        'createdAt': '2026-11-09T12:00:00.000Z',
        'updatedAt': '2026-11-09T12:00:00.000Z',
      };

      final vehicle = Vehicle.fromJson(json);

      expect(vehicle.id, 1);
      expect(vehicle.vehicleNumber, 'DHAKA-METRO-GA-11-2233');
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.model, 'Hiace');
      expect(vehicle.manufactureYear, 2019);
      expect(vehicle.vehicleType, 'VAN');
      expect(vehicle.color, 'White');
      expect(vehicle.createdAt, DateTime.parse('2026-11-09T12:00:00.000Z'));
      expect(vehicle.updatedAt, DateTime.parse('2026-11-09T12:00:00.000Z'));

      final serialized = vehicle.toJson();
      expect(serialized['id'], 1);
      expect(serialized['vehicleNumber'], 'DHAKA-METRO-GA-11-2233');
      expect(serialized['brand'], 'Toyota');
      expect(serialized['model'], 'Hiace');
      expect(serialized['manufactureYear'], 2019);
      expect(serialized['vehicleType'], 'VAN');
      expect(serialized['color'], 'White');

      final requestBody = vehicle.toRequestBody();
      expect(requestBody.containsKey('id'), isFalse);
      expect(requestBody.containsKey('createdAt'), isFalse);
      expect(requestBody.containsKey('updatedAt'), isFalse);
      expect(requestBody['vehicleNumber'], 'DHAKA-METRO-GA-11-2233');
    });
  });

  group('ApiException', () {
    test('fromResponseBody parses contract error shape with fieldErrors', () {
      const errorJson = '''
      {
        "timestamp": "2026-11-09T12:00:00Z",
        "status": 409,
        "error": "Conflict",
        "message": "Vehicle number DHAKA-METRO-GA-11-2233 already exists",
        "fieldErrors": { "vehicleNumber": "already exists" }
      }
      ''';

      final exception = ApiException.fromResponseBody(409, errorJson);

      expect(exception.statusCode, 409);
      expect(exception.message, 'Vehicle number DHAKA-METRO-GA-11-2233 already exists');
      expect(exception.fieldErrors, {'vehicleNumber': 'already exists'});
    });

    test('fromResponseBody handles non-json error gracefully', () {
      final exception = ApiException.fromResponseBody(500, 'Internal Server Error');
      expect(exception.statusCode, 500);
      expect(exception.message, contains('500'));
      expect(exception.fieldErrors, isEmpty);
    });
  });
}

