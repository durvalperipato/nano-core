import 'package:nano_core/nano_core.dart';

/// A mock implementation of [NanoHttpClient] for testing and demo purposes.
class MockHttpClient extends NanoHttpClient {
  /// Creates a [MockHttpClient] instance.
  MockHttpClient([List<NanoHttpInterceptor>? interceptors])
      : _interceptors = interceptors ?? [const NanoHttpLogInterceptor()];

  final List<NanoHttpInterceptor> _interceptors;

  @override
  List<NanoHttpInterceptor> get interceptors => _interceptors;

  @override
  void addInterceptor(NanoHttpInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  Future<NanoHttpRequest> _dispatchRequest(
    String path,
    String method, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    var req = NanoHttpRequest(
      url: path,
      method: method,
      body: data,
      queryParameters: queryParameters ?? const {},
      headers: headers ?? const {},
    );

    for (final interceptor in _interceptors) {
      req = await interceptor.onRequest(req);
    }
    return req;
  }

  Future<NanoHttpResponse<T>> _dispatchResponse<T>(
    NanoHttpResponse<T> response,
    NanoHttpRequest request,
  ) async {
    var res = response.copyWith(request: request);
    for (final interceptor in _interceptors) {
      res = await interceptor.onResponse(res);
    }
    return res;
  }

  @override
  Future<NanoHttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final req = await _dispatchRequest(
      path,
      'GET',
      queryParameters: queryParameters,
      headers: headers,
    );

    await Future.delayed(const Duration(milliseconds: 1200));

    if (path == '/users') {
      var users = [
        {
          'id': '1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'role': 'admin',
        },
        {
          'id': '2',
          'name': 'Alice Smith',
          'email': 'alice@example.com',
          'role': 'developer',
        },
        {
          'id': '3',
          'name': 'Durval Peripato',
          'email': 'durval@nanodevs.com.br',
          'role': 'admin',
        },
      ];

      if (queryParameters != null && queryParameters.containsKey('name')) {
        final query = queryParameters['name'].toString().toLowerCase();
        users = users
            .where((u) => u['name'].toString().toLowerCase().contains(query))
            .toList();
      }

      if (queryParameters != null && queryParameters.containsKey('role')) {
        final role = queryParameters['role'].toString().toLowerCase();
        users = users
            .where((u) => u['role'].toString().toLowerCase() == role)
            .toList();
      }

      final res = NanoHttpResponse<T>(
        data: users as T?,
        statusCode: NanoHttpCode.ok,
        statusMessage: 'OK',
      );
      return _dispatchResponse(res, req);
    }

    if (path.startsWith('/users/')) {
      final id = path.split('/').last;
      final data = {
        'id': id,
        'name': 'John Doe (from NanoRepository)',
        'email': 'john@example.com',
      } as dynamic;

      final res = NanoHttpResponse<T>(
        data: data as T?,
        statusCode: NanoHttpCode.ok,
        statusMessage: 'OK',
      );
      return await _dispatchResponse(res, req);
    }

    final notFound = NanoHttpResponse<T>(
      statusCode: NanoHttpCode.notFound,
      statusMessage: 'Not Found',
    );
    return await _dispatchResponse(notFound, req);
  }

  @override
  Future<NanoHttpResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final req = await _dispatchRequest(
      path,
      'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final res = NanoHttpResponse<T>(
      data: data as T?,
      statusCode: NanoHttpCode.created,
      statusMessage: 'Created',
    );
    return await _dispatchResponse(res, req);
  }

  @override
  Future<NanoHttpResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final req = await _dispatchRequest(
      path,
      'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final res = NanoHttpResponse<T>(
      data: data as T?,
      statusCode: NanoHttpCode.ok,
      statusMessage: 'OK',
    );
    return await _dispatchResponse(res, req);
  }

  @override
  Future<NanoHttpResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final req = await _dispatchRequest(
      path,
      'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    await Future.delayed(const Duration(milliseconds: 600));
    final res = NanoHttpResponse<T>(
      statusCode: NanoHttpCode.noContent,
      statusMessage: 'No Content',
    );
    return await _dispatchResponse(res, req);
  }

  @override
  Future<NanoHttpResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final req = await _dispatchRequest(
      path,
      'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final res = NanoHttpResponse<T>(
      data: data as T?,
      statusCode: NanoHttpCode.ok,
      statusMessage: 'OK',
    );
    return await _dispatchResponse(res, req);
  }
}
