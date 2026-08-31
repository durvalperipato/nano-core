import '../equatable/nano_equatable.dart';

/// Represents an HTTP request payload processed by [NanoHttpClient]
/// and its interceptors.
class NanoHttpRequest extends NanoEquatable {
  /// Creates a [NanoHttpRequest] instance.
  const NanoHttpRequest({
    required this.method,
    required this.url,
    this.headers = const {},
    this.queryParameters = const {},
    this.body,
    this.extra = const {},
  });

  /// The HTTP method (e.g. 'GET', 'POST', 'PUT', 'DELETE', etc.).
  final String method;

  /// The request URL or endpoint path.
  final String url;

  /// HTTP headers for this request.
  final Map<String, dynamic> headers;

  /// Query parameters appended to the URL.
  final Map<String, dynamic> queryParameters;

  /// Request body data (JSON map, list, string, etc.).
  final dynamic body;

  /// Extra metadata or context properties for interceptors.
  final Map<String, dynamic> extra;

  /// Creates a copy of this [NanoHttpRequest] with modified properties.
  NanoHttpRequest copyWith({
    String? method,
    String? url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, dynamic>? extra,
  }) {
    return NanoHttpRequest(
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? Map.from(this.headers),
      queryParameters: queryParameters ?? Map.from(this.queryParameters),
      body: body ?? this.body,
      extra: extra ?? Map.from(this.extra),
    );
  }

  @override
  List<Object?> get props => [
    method,
    url,
    headers,
    queryParameters,
    body,
    extra,
  ];
}
