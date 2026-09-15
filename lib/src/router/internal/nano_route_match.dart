import '../routes/nano_route_base.dart';

/// Represents a successful dynamic route match with extracted path parameters.
class NanoRouteMatch {
  /// Creates a [NanoRouteMatch] instance.
  const NanoRouteMatch({
    required this.route,
    required this.canonicalPath,
    required this.pathParameters,
  });

  /// The matched route definition.
  final NanoRouteBase route;

  /// The canonical pattern path that was registered (e.g. `/users/:id`).
  final String canonicalPath;

  /// The extracted path parameters (e.g. `{'id': '42'}`).
  final Map<String, String> pathParameters;
}
