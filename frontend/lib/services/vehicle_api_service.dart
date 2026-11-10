import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';
import 'api_exception.dart';

class VehicleApiService {
  static const String _defaultBaseUrl = 'http://localhost:8080';
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  final String baseUrl;
  final http.Client client;

  VehicleApiService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = (baseUrl != null && baseUrl.isNotEmpty)
            ? baseUrl
            : (_envBaseUrl.isNotEmpty ? _envBaseUrl : _defaultBaseUrl),
        client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// GET /api/vehicles - List all vehicles
  Future<List<Vehicle>> getAll() async {
    final uri = Uri.parse('$baseUrl/api/vehicles');
    try {
      final response = await client.get(uri, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((item) => Vehicle.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw ApiException.fromResponseBody(response.statusCode, response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        statusCode: 0,
        message: 'Network error: Unable to connect to server ($e)',
      );
    }
  }

  /// Backward-compatible alias for getAll()
  Future<List<Vehicle>> getVehicles() => getAll();

  /// GET /api/vehicles/{id} - Get vehicle by ID
  Future<Vehicle> getById(int id) async {
    final uri = Uri.parse('$baseUrl/api/vehicles/$id');
    try {
      final response = await client.get(uri, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        return Vehicle.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
      throw ApiException.fromResponseBody(response.statusCode, response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        statusCode: 0,
        message: 'Network error: Unable to connect to server ($e)',
      );
    }
  }

  /// POST /api/vehicles - Create new vehicle
  Future<Vehicle> create(Map<String, dynamic> vehicleData) async {
    final uri = Uri.parse('$baseUrl/api/vehicles');
    try {
      final response = await client.post(
        uri,
        headers: _headers,
        body: jsonEncode(vehicleData),
      );
      if (response.statusCode == 201) {
        return Vehicle.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
      throw ApiException.fromResponseBody(response.statusCode, response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        statusCode: 0,
        message: 'Network error: Unable to connect to server ($e)',
      );
    }
  }

  /// PUT /api/vehicles/{id} - Update vehicle
  Future<Vehicle> update(int id, Map<String, dynamic> vehicleData) async {
    final uri = Uri.parse('$baseUrl/api/vehicles/$id');
    try {
      final response = await client.put(
        uri,
        headers: _headers,
        body: jsonEncode(vehicleData),
      );
      if (response.statusCode == 200) {
        return Vehicle.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
      throw ApiException.fromResponseBody(response.statusCode, response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        statusCode: 0,
        message: 'Network error: Unable to connect to server ($e)',
      );
    }
  }

  /// DELETE /api/vehicles/{id} - Delete vehicle
  Future<void> delete(int id) async {
    final uri = Uri.parse('$baseUrl/api/vehicles/$id');
    try {
      final response = await client.delete(uri, headers: _headers);
      if (response.statusCode == 204) {
        return;
      }
      throw ApiException.fromResponseBody(response.statusCode, response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        statusCode: 0,
        message: 'Network error: Unable to connect to server ($e)',
      );
    }
  }
}
