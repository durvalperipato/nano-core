import '../equatable/nano_equatable.dart';
import 'nano_http_request.dart';
import 'nano_http_response.dart';

/// Represents an error or exception during HTTP execution.
class NanoHttpError extends NanoEquatable implements Exception {
  /// Creates a [NanoHttpError] instance.
  const NanoHttpError({
    required this.message,
    this.statusCode,
    this.request,
    this.response,
    this.error,
    this.stackTrace,
  });

  /// The human-readable error message.
  final String message;

  /// The HTTP status code, if available.
  final int? statusCode;

  /// The original request that triggered this error.
  final NanoHttpRequest? request;

  /// The response returned by the server, if any.
  final NanoHttpResponse<dynamic>? response;

  /// The underlying exception or error object.
  final Object? error;

  /// The stack trace where the error occurred.
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, statusCode, request, response, error];

  @override
  String toString() {
    return 'NanoHttpError('
        'statusCode: $statusCode, '
        'message: $message, '
        'error: $error'
        ')';
  }
}
