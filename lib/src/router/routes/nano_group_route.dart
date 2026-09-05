import 'nano_route_base.dart';

/// A route grouping container that prepends a [path] prefix to all child
/// [routes] without rendering a standalone page of its own.
class NanoGroupRoute extends NanoRouteBase {
  /// Creates a [NanoGroupRoute].
  NanoGroupRoute({required super.path, required super.routes});
}

