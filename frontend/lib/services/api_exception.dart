import 'dart:convert';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, String> fieldErrors;

  ApiException({
    required this.statusCode,
    required this.message,
    this.fieldErrors = const {},
  });

  factory ApiException.fromResponseBody(int statusCode, String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] as String? ?? 'An error occurred';
        final rawFieldErrors = decoded['fieldErrors'];
        final Map<String, String> fieldErrors = {};

        if (rawFieldErrors is Map) {
          rawFieldErrors.forEach((key, value) {
            if (key != null && value != null) {
              fieldErrors[key.toString()] = value.toString();
            }
          });
        }

        return ApiException(
          statusCode: statusCode,
          message: message,
          fieldErrors: fieldErrors,
        );
      }
    } catch (_) {
      // Body was not JSON or failed to parse
    }

    return ApiException(
      statusCode: statusCode,
      message: 'Server returned error status $statusCode',
      fieldErrors: const {},
    );
  }

  @override
  String toString() =>
      'ApiException(status: $statusCode, message: $message, fieldErrors: $fieldErrors)';
}
