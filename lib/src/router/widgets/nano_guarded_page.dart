import 'package:flutter/material.dart';
import '../models/nano_route_args.dart';
import '../nano_router.dart';
import '../routes/nano_protected_route.dart';
import '../routes/nano_route.dart';

/// A wrapper widget that evaluates route guards before rendering the page.
class NanoGuardedPage extends StatelessWidget {
  /// Creates a [NanoGuardedPage] widget.
  const NanoGuardedPage({
    super.key,
    required this.route,
    required this.path,
    required this.args,
    required this.guards,
    required this.nameToPathMap,
  });

  /// The target route to build.
  final NanoRoute route;

  /// The requested path.
  final String path;

  /// Route arguments passed to this route.
  final NanoRouteArgs args;

  /// List of active protected guards protecting this route.
  final List<NanoProtectedRoute> guards;

  /// Route name-to-path resolution mapping.
  final Map<String, String> nameToPathMap;

  @override
  Widget build(BuildContext context) {
    if (guards.isNotEmpty) {
      for (final guard in guards) {
        final hasAccess = guard.hasAccess(context, args);
        if (!hasAccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final target =
                nameToPathMap[guard.redirectTo] ?? guard.redirectTo;
            NanoRouter.toReplacementNamed(target, arguments: args.data);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      }
    }
    return route.builder(context, args);
  }
}
