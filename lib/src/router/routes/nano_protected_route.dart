import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route.dart';

/// A protected route that verifies access permissions before rendering.
class NanoProtectedRoute extends NanoRoute {
  /// Creates a [NanoProtectedRoute].
  const NanoProtectedRoute({
    required super.path,
    required super.builder,
    required this.hasAccess,
    required this.redirectTo,
    super.name,
    super.routes,
  });

  /// Evaluates whether the user has access to view this route.
  final bool Function(BuildContext context, NanoRouteArgs args) hasAccess;

  /// The destination path to redirect to when [hasAccess] returns `false`.
  final String redirectTo;
}
