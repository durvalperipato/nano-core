import 'nano_http_request.dart';

/// A standardized generic response object for all HTTP requests.
class NanoHttpResponse<T> {
  /// Creates a new [NanoHttpResponse] instance.
  const NanoHttpResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
    this.request,
  });

  /// The payload data returned by the server, parsed to type [T].
  final T? data;

  /// The HTTP status code of the response (e.g., 200, 404).
  final int? statusCode;

  /// A descriptive message representing the status of the response.
  final String? statusMessage;

  /// The original [NanoHttpRequest] associated with this response.
  final NanoHttpRequest? request;

  /// Creates a copy of this response with modified properties.
  NanoHttpResponse<T> copyWith({
    T? data,
    int? statusCode,
    String? statusMessage,
    NanoHttpRequest? request,
  }) {
    return NanoHttpResponse<T>(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      request: request ?? this.request,
    );
  }
}
