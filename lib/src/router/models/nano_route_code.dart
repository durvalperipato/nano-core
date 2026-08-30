/// Represents route status codes in nano-core.
abstract final class NanoRouteCode {
  /// The route does not exist in the routing table (404).
  static const int notFound = 404;

  /// The user is not authenticated to access the route (401).
  static const int unauthorized = 401;

  /// The user is authenticated but lacks permission for the route (403).
  static const int forbidden = 403;

  /// The route parameters or arguments are invalid or missing (400).
  static const int badRequest = 400;

  /// The route was redirected to another destination (302).
  static const int redirect = 302;
}
