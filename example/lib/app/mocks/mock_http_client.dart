import 'package:nano_core/nano_core.dart';

/// A mock implementation of [NanoHttpClient] for testing and demo purposes.
class MockHttpClient implements NanoHttpClient {
  /// Creates a [MockHttpClient] instance.
  const MockHttpClient();

  @override
  Future<NanoHttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (path == '/users') {
      final data = [
        {'id': '1', 'name': 'John Doe', 'email': 'john@example.com'},
        {'id': '2', 'name': 'Alice Smith', 'email': 'alice@example.com'},
      ] as dynamic;
      return NanoHttpResponse<T>(
        data: data as T?,
        statusCode: NanoHttpCode.ok,
        statusMessage: 'OK',
      );
    }

    if (path.startsWith('/users/')) {
      final id = path.split('/').last;
      final data = {
        'id': id,
        'name': 'John Doe (from NanoRepository)',
        'email': 'john@example.com',
      } as dynamic;

      return NanoHttpResponse<T>(
        data: data as T?,
        statusCode: NanoHttpCode.ok,
        statusMessage: 'OK',
      );
    }

    return NanoHttpResponse<T>(
      statusCode: NanoHttpCode.notFound,
      statusMessage: 'Not Found',
    );
  }

  @override
  Future<NanoHttpResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return NanoHttpResponse<T>(
      data: data as T?,
      statusCode: NanoHttpCode.created,
      statusMessage: 'Created',
    );
  }

  @override
  Future<NanoHttpResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return NanoHttpResponse<T>(
      data: data as T?,
      statusCode: NanoHttpCode.ok,
      statusMessage: 'OK',
    );
  }

  @override
  Future<NanoHttpResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return NanoHttpResponse<T>(
      statusCode: NanoHttpCode.noContent,
      statusMessage: 'No Content',
    );
  }

  @override
  Future<NanoHttpResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return NanoHttpResponse<T>(
      data: data as T?,
      statusCode: NanoHttpCode.ok,
      statusMessage: 'OK',
    );
  }
}
