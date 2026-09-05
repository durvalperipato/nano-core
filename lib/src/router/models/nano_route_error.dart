import 'nano_route_code.dart';

/// Represents an error or access restriction during route resolution.
class NanoRouteError {
  /// Creates a new [NanoRouteError] instance.
  const NanoRouteError({required this.path, required this.code, this.message});

  /// The path of the requested route.
  final String path;

  /// The route status code, typically from [NanoRouteCode].
  final int code;

  /// Optional descriptive error message.
  final String? message;

  /// Whether this error represents a route not found (404).
  bool get isNotFound => code == NanoRouteCode.notFound;

  /// Whether this error represents an unauthenticated request (401).
  bool get isUnauthorized => code == NanoRouteCode.unauthorized;

  /// Whether this error represents a forbidden access request (403).
  bool get isForbidden => code == NanoRouteCode.forbidden;

  /// Whether this error represents an invalid parameters request (400).
  bool get isBadRequest => code == NanoRouteCode.badRequest;
}
