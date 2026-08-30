import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';

/// Represents a declarative route in [NanoRouter].
class NanoRoute {
  /// Creates a standard [NanoRoute].
  const NanoRoute({
    required this.path,
    required this.builder,
    this.name,
    this.routes = const <NanoRoute>[],
  });

  /// The unique path pattern for this route (e.g. `'/users'` or `'/detail'`).
  final String path;

  /// Builds the widget tree for this route.
  final Widget Function(BuildContext context, NanoRouteArgs args) builder;

  /// Optional unique name identifier for this route (e.g. `'user_detail'`).
  final String? name;

  /// Nested sub-routes belonging to this route.
  final List<NanoRoute> routes;
}
