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
      var users = List.generate(
        15,
        (index) {
          final id = (index + 1).toString();
          final roles = ['admin', 'developer', 'designer'];
          final names = [
            'John Doe',
            'Alice Smith',
            'Durval Peripato',
            'Bob Johnson',
            'Carol Williams',
            'David Brown',
            'Eva Davis',
            'Frank Miller',
            'Grace Wilson',
            'Henry Moore',
            'Ivy Taylor',
            'Jack Anderson',
            'Kate Thomas',
            'Leo Jackson',
            'Mia White',
          ];
          return {
            'id': id,
            'name': names[index % names.length],
            'email': 'user$id@nanodevs.com.br',
            'role': roles[index % roles.length],
          };
        },
      );

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

      // Pagination slicing:
      final page = queryParameters?['page'] is int
          ? queryParameters!['page'] as int
          : int.tryParse(queryParameters?['page']?.toString() ?? '1') ?? 1;

      final pageSize = queryParameters?['pageSize'] is int
          ? queryParameters!['pageSize'] as int
          : queryParameters?['limit'] is int
              ? queryParameters!['limit'] as int
              : int.tryParse(queryParameters?['pageSize']?.toString() ??
                      queryParameters?['limit']?.toString() ??
                      '') ??
                  5;

      final startIndex = (page - 1) * pageSize;
      final pagedUsers = (startIndex < users.length)
          ? users.sublist(
              startIndex,
              (startIndex + pageSize).clamp(0, users.length),
            )
          : <Map<String, dynamic>>[];

      final res = NanoHttpResponse<T>(
        data: pagedUsers as T?,
        statusCode: NanoHttpCode.ok,
        statusMessage: 'OK',
      );
      return await _dispatchResponse(res, req);
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
