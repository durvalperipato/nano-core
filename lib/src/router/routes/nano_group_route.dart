import 'package:flutter/widgets.dart';
import 'nano_route.dart';

/// A route grouping container that prepends a [path] prefix to all child
/// [routes] without rendering a standalone page of its own.
class NanoGroupRoute extends NanoRoute {
  /// Creates a [NanoGroupRoute].
  NanoGroupRoute({required super.path, required super.routes})
    : super(builder: (context, args) => const SizedBox.shrink());
}
