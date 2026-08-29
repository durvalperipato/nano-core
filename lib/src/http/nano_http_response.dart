/// A standardized generic response object for all HTTP requests.
class NanoHttpResponse<T> {
  /// Creates a new [NanoHttpResponse] instance.
  const NanoHttpResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  /// The payload data returned by the server, parsed to type [T].
  final T? data;

  /// The HTTP status code of the response (e.g., 200, 404).
  final int? statusCode;

  /// A descriptive message representing the status of the response.
  final String? statusMessage;
}
