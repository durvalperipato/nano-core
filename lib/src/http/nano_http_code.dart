/// Standard HTTP Status Codes constants for easy reference.
abstract class NanoHttpCode {
  // 2xx Success
  /// OK
  static const int ok = 200;

  /// Created
  static const int created = 201;

  /// Accepted
  static const int accepted = 202;

  /// No Content
  static const int noContent = 204;

  // 3xx Redirection
  /// Multiple Choices
  static const int multipleChoices = 300;

  /// Moved Permanently
  static const int movedPermanently = 301;

  /// Found
  static const int found = 302;

  /// Not Modified
  static const int notModified = 304;

  // 4xx Client Errors
  /// Bad Request
  static const int badRequest = 400;

  /// Unauthorized
  static const int unauthorized = 401;

  /// Forbidden
  static const int forbidden = 403;

  /// Not Found
  static const int notFound = 404;

  /// Method Not Allowed
  static const int methodNotAllowed = 405;

  /// Conflict
  static const int conflict = 409;

  /// Unprocessable Entity
  static const int unprocessableEntity = 422;

  // 5xx Server Errors
  /// Internal Server Error
  static const int internalServerError = 500;

  /// Not Implemented
  static const int notImplemented = 501;

  /// Bad Gateway
  static const int badGateway = 502;

  /// Service Unavailable
  static const int serviceUnavailable = 503;

  /// Gateway Timeout
  static const int gatewayTimeout = 504;
}
