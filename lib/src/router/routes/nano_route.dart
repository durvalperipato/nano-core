import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route_base.dart';

/// Represents a standard declarative route with a widget builder in
/// [NanoRouter].
class NanoRoute extends NanoRouteBase {
  /// Creates a standard [NanoRoute].
  const NanoRoute({
    required super.path,
    required this.builder,
    super.name,
    super.routes = const <NanoRouteBase>[],
  });

  /// Builds the widget tree for this route.
  final Widget Function(BuildContext context, NanoRouteArgs args) builder;
}

