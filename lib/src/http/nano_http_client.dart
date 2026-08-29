import 'nano_http_response.dart';

/// An abstract interface defining the standard contract for HTTP clients.
///
/// This allows swapping out the underlying HTTP implementation
/// (e.g., Dio, Http) without affecting the rest of the application.
abstract class NanoHttpClient {
  /// Sends an HTTP GET request.
  Future<NanoHttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends an HTTP POST request.
  Future<NanoHttpResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends an HTTP PUT request.
  Future<NanoHttpResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends an HTTP DELETE request.
  Future<NanoHttpResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends an HTTP PATCH request.
  Future<NanoHttpResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}
