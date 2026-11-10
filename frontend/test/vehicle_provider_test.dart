import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/providers/vehicle_provider.dart';
import 'package:frontend/services/api_exception.dart';
import 'package:frontend/services/vehicle_api_service.dart';

class FakeVehicleApiService extends VehicleApiService {
  List<Vehicle> storage = [];
  bool shouldFail = false;
  int fetchCount = 0;

  @override
  Future<List<Vehicle>> getAll() async {
    fetchCount++;
    if (shouldFail) {
      throw ApiException(statusCode: 500, message: 'Server unreachable');
    }
    return List.from(storage);
  }

  @override
  Future<Vehicle> create(Map<String, dynamic> vehicleData) async {
    if (shouldFail) {
      throw ApiException(
        statusCode: 409,
        message: 'Duplicate vehicle number',
        fieldErrors: {'vehicleNumber': 'already exists'},
      );
    }
    final vehicle = Vehicle(
      id: storage.length + 1,
      vehicleNumber: vehicleData['vehicleNumber'] as String,
      brand: vehicleData['brand'] as String,
      model: vehicleData['model'] as String,
      manufactureYear: vehicleData['manufactureYear'] as int,
      vehicleType: vehicleData['vehicleType'] as String,
    );
    storage.add(vehicle);
    return vehicle;
  }

  @override
  Future<Vehicle> update(int id, Map<String, dynamic> vehicleData) async {
    final index = storage.indexWhere((v) => v.id == id);
    if (index == -1) {
      throw ApiException(statusCode: 404, message: 'Not found');
    }
    final updated = Vehicle(
      id: id,
      vehicleNumber: vehicleData['vehicleNumber'] as String? ?? storage[index].vehicleNumber,
      brand: vehicleData['brand'] as String? ?? storage[index].brand,
      model: vehicleData['model'] as String? ?? storage[index].model,
      manufactureYear: vehicleData['manufactureYear'] as int? ?? storage[index].manufactureYear,
      vehicleType: vehicleData['vehicleType'] as String? ?? storage[index].vehicleType,
    );
    storage[index] = updated;
    return updated;
  }

  @override
  Future<void> delete(int id) async {
    storage.removeWhere((v) => v.id == id);
    return;
  }
}

void main() {
  group('VehicleProvider', () {
    late FakeVehicleApiService apiService;
    late VehicleProvider provider;

    setUp(() {
      apiService = FakeVehicleApiService();
      provider = VehicleProvider(apiService: apiService);
    });

    test('fetchVehicles loads data and clears loading state', () async {
      apiService.storage = [
        const Vehicle(
          id: 1,
          vehicleNumber: 'DHAKA-METRO-GA-11-2233',
          brand: 'Toyota',
          model: 'Hiace',
          manufactureYear: 2019,
          vehicleType: 'VAN',
        ),
      ];

      expect(provider.isLoading, isFalse);
      final future = provider.fetchVehicles();
      expect(provider.isLoading, isTrue);

      await future;

      expect(provider.isLoading, isFalse);
      expect(provider.vehicles.length, 1);
      expect(provider.vehicles.first.brand, 'Toyota');
      expect(provider.hasError, isFalse);
    });

    test('fetchVehicles captures error message on failure', () async {
      apiService.shouldFail = true;

      await provider.fetchVehicles();

      expect(provider.isLoading, isFalse);
      expect(provider.vehicles, isEmpty);
      expect(provider.hasError, isTrue);
      expect(provider.errorMessage, 'Server unreachable');
    });

    test('createVehicle writes data and refreshes list from server', () async {
      await provider.createVehicle({
        'vehicleNumber': 'DHAKA-METRO-BA-12-3456',
        'brand': 'Hino',
        'model': '1J',
        'manufactureYear': 2021,
        'vehicleType': 'BUS',
      });

      expect(provider.vehicles.length, 1);
      expect(provider.vehicles.first.vehicleNumber, 'DHAKA-METRO-BA-12-3456');
      expect(apiService.fetchCount, 1);
    });

    test('updateVehicle updates data and refreshes list from server', () async {
      apiService.storage = [
        const Vehicle(
          id: 1,
          vehicleNumber: 'DHAKA-METRO-GA-11-2233',
          brand: 'Toyota',
          model: 'Hiace',
          manufactureYear: 2019,
          vehicleType: 'VAN',
        ),
      ];

      await provider.updateVehicle(1, {
        'brand': 'Toyota Updated',
      });

      expect(provider.vehicles.first.brand, 'Toyota Updated');
      expect(apiService.fetchCount, 1);
    });

    test('deleteVehicle removes data and refreshes list from server', () async {
      apiService.storage = [
        const Vehicle(
          id: 1,
          vehicleNumber: 'DHAKA-METRO-GA-11-2233',
          brand: 'Toyota',
          model: 'Hiace',
          manufactureYear: 2019,
          vehicleType: 'VAN',
        ),
      ];

      await provider.deleteVehicle(1);

      expect(provider.vehicles, isEmpty);
      expect(apiService.fetchCount, 1);
    });
  });
}

