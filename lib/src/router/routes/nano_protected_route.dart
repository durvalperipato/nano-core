import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route_guard.dart';

/// A route guard wrapper that enforces synchronous access permissions for all
/// child [routes].
///
/// If [hasAccess] returns `false`, navigation redirects to [redirectTo].
class NanoProtectedRoute extends NanoRouteGuard {
  /// Creates a [NanoProtectedRoute] guard wrapper.
  NanoProtectedRoute({
    required super.redirectTo,
    required this.hasAccess,
    required super.routes,
    super.path = '',
    super.name,
  });

  /// Evaluates whether the user has access to view routes wrapped by this
  /// guard.
  final bool Function(BuildContext context, NanoRouteArgs args) hasAccess;
}
