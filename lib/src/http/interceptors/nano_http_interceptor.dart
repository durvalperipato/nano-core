import 'dart:async';
import '../nano_http_error.dart';
import '../nano_http_request.dart';
import '../nano_http_response.dart';

/// Contract for intercepting and transforming HTTP requests, responses,
/// and errors.
abstract interface class NanoHttpInterceptor {
  /// Intercepts and optionally mutates the [request] before it is sent.
  FutureOr<NanoHttpRequest> onRequest(NanoHttpRequest request) => request;

  /// Intercepts and optionally mutates the [response] received from the server.
  FutureOr<NanoHttpResponse<T>> onResponse<T>(NanoHttpResponse<T> response) =>
      response;

  /// Intercepts an HTTP [error] and optionally handles or transforms it.
  ///
  /// Returning a [NanoHttpResponse] recovers from the error and returns
  /// that response to the caller.
  ///
  /// Returning `null` or rethrowing allows the error to propagate.
  FutureOr<NanoHttpResponse<dynamic>?> onError(NanoHttpError error) => null;
}
