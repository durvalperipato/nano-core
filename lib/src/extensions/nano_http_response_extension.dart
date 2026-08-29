import '../http/nano_http_response.dart';

/// Helper extension to easily evaluate HTTP status codes.
extension NanoHttpResponseExtension on NanoHttpResponse {
  /// Returns true if the status code is between 200 and 299 (inclusive).
  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;

  /// Returns true if the status code is between 400 and 499 (inclusive).
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Returns true if the status code is 500 or greater.
  bool get isServerError => statusCode != null && statusCode! >= 500;
}
