import 'dart:async';
import 'package:get_it/get_it.dart';
import '../../repository/nano_auth_repository.dart';
import '../nano_http_error.dart';
import '../nano_http_request.dart';
import '../nano_http_response.dart';
import 'nano_http_interceptor.dart';

/// An HTTP interceptor that automatically injects Bearer/Authorization tokens
/// into outgoing requests and handles 401 Unauthorized responses.
///
/// Delegates token resolution directly to [NanoAuthRepository] as the single
/// source of truth.
class NanoAuthInterceptor implements NanoHttpInterceptor {
  /// Creates a [NanoAuthInterceptor] instance.
  ///
  /// If [authRepository] is omitted, it automatically resolves from [GetIt].
  const NanoAuthInterceptor({
    this.headerPrefix = 'Bearer',
    this.headerName = 'Authorization',
    this.tokenProvider,
    this.onUnauthorized,
    this.excludePaths = const [],
    NanoAuthRepository<dynamic>? authRepository,
  }) : _authRepository = authRepository;

  /// Prefix prepended to the token in the header (defaults to 'Bearer').
  final String headerPrefix;

  /// Header name (defaults to 'Authorization').
  final String headerName;

  /// Custom token resolver callback. If omitted, uses
  /// [NanoAuthRepository.token].
  final FutureOr<String?> Function()? tokenProvider;

  /// Callback executed when an HTTP 401 Unauthorized status is received.
  final void Function()? onUnauthorized;

  /// URL path substrings to exclude from token injection.
  final List<String> excludePaths;

  final NanoAuthRepository<dynamic>? _authRepository;

  NanoAuthRepository<dynamic>? get _activeAuthRepository =>
      _authRepository ??
      (GetIt.I.isRegistered<NanoAuthRepository<dynamic>>()
          ? GetIt.I<NanoAuthRepository<dynamic>>()
          : null);

  @override
  FutureOr<NanoHttpRequest> onRequest(NanoHttpRequest request) async {
    for (final excluded in excludePaths) {
      if (request.url.contains(excluded)) return request;
    }

    final token = tokenProvider != null
        ? await tokenProvider!()
        : _activeAuthRepository?.token;

    if (token != null && token.isNotEmpty) {
      final updatedHeaders = Map<String, dynamic>.from(request.headers);
      updatedHeaders[headerName] = headerPrefix.isNotEmpty
          ? '$headerPrefix $token'
          : token;
      return request.copyWith(headers: updatedHeaders);
    }

    return request;
  }

  @override
  FutureOr<NanoHttpResponse<T>> onResponse<T>(NanoHttpResponse<T> response) =>
      response;

  @override
  FutureOr<NanoHttpResponse<dynamic>?> onError(NanoHttpError error) {
    if (error.statusCode == 401) {
      _activeAuthRepository?.clearSession();
      onUnauthorized?.call();
    }
    return null;
  }
}
