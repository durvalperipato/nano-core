import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route.dart';

/// A route guard wrapper that enforces access permissions for all child
/// [routes].
///
/// If [hasAccess] returns `false`, navigation redirects to [redirectTo].
class NanoProtectedRoute extends NanoRoute {
  /// Creates a [NanoProtectedRoute] guard wrapper.
  NanoProtectedRoute({
    required this.hasAccess,
    required this.redirectTo,
    required super.routes,
    super.path = '',
  }) : super(builder: (context, args) => const SizedBox.shrink());

  /// Evaluates whether the user has access to view routes wrapped by this
  /// guard.
  final bool Function(BuildContext context, NanoRouteArgs args) hasAccess;

  /// The destination path or route name to redirect to when [hasAccess]
  /// returns `false`.
  final String redirectTo;
}
