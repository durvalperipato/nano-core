import '../../logger/nano_logger.dart';
import '../nano_http_error.dart';
import '../nano_http_request.dart';
import '../nano_http_response.dart';
import 'nano_http_interceptor.dart';

/// An out-of-the-box HTTP interceptor that formats and logs network requests,
/// responses, and errors using [NanoLogger].
class NanoHttpLogInterceptor implements NanoHttpInterceptor {
  /// Creates a [NanoHttpLogInterceptor] instance.
  const NanoHttpLogInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logHeaders = false,
    this.logBody = true,
    this.tag = 'NanoHttp',
  });

  /// Whether to log outgoing requests.
  final bool logRequest;

  /// Whether to log incoming responses.
  final bool logResponse;

  /// Whether to log errors and exceptions.
  final bool logError;

  /// Whether to log request/response headers.
  final bool logHeaders;

  /// Whether to log request/response bodies.
  final bool logBody;

  /// Log tag prefix.
  final String tag;

  @override
  NanoHttpRequest onRequest(NanoHttpRequest request) {
    if (logRequest) {
      final details = <String, dynamic>{};
      if (logHeaders && request.headers.isNotEmpty) {
        details['headers'] = request.headers;
      }
      if (request.queryParameters.isNotEmpty) {
        details['queryParams'] = request.queryParameters;
      }
      if (logBody && request.body != null) {
        details['body'] = request.body;
      }

      NanoLogger.http(
        request.url,
        httpMethod: request.method,
        tag: tag,
        method: 'onRequest',
        data: details.isNotEmpty ? details : null,
      );
    }
    return request;
  }

  @override
  NanoHttpResponse<T> onResponse<T>(NanoHttpResponse<T> response) {
    if (logResponse) {
      NanoLogger.http(
        'HTTP Response [${response.data.runtimeType}]',
        httpMethod: response.request?.method,
        statusCode: response.statusCode,
        tag: tag,
        method: 'onResponse',
        data: logBody && response.data != null ? response.data : null,
      );
    }
    return response;
  }

  @override
  NanoHttpResponse<dynamic>? onError(NanoHttpError error) {
    if (logError) {
      NanoLogger.error(
        error.message,
        httpMethod: error.request?.method,
        statusCode: error.statusCode,
        tag: tag,
        method: 'onError',
        data: error.response?.data,
        error: error.error,
        stackTrace: error.stackTrace,
      );
    }
    return null;
  }
}
