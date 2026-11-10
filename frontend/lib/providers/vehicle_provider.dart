import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';
import '../services/api_exception.dart';
import '../services/vehicle_api_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleApiService _apiService;

  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  VehicleProvider({VehicleApiService? apiService})
      : _apiService = apiService ?? VehicleApiService();

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Loads all vehicles from the backend.
  Future<void> fetchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vehicles = await _apiService.getAll();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a vehicle and immediately refreshes the vehicle list from the server.
  Future<Vehicle> createVehicle(Map<String, dynamic> vehicleData) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await _apiService.create(vehicleData);
      await fetchVehicles();
      return created;
    } catch (e) {
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Updates an existing vehicle and immediately refreshes the vehicle list from the server.
  Future<Vehicle> updateVehicle(int id, Map<String, dynamic> vehicleData) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _apiService.update(id, vehicleData);
      await fetchVehicles();
      return updated;
    } catch (e) {
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Deletes a vehicle and immediately refreshes the vehicle list from the server.
  Future<void> deleteVehicle(int id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.delete(id);
      await fetchVehicles();
    } catch (e) {
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
