import 'package:flutter/material.dart';
import 'models/nano_paths.dart';
import 'models/nano_route_args.dart';
import 'models/nano_route_code.dart';
import 'models/nano_route_error.dart';
import 'routes/nano_animated_route.dart';
import 'routes/nano_group_route.dart';
import 'routes/nano_protected_route.dart';
import 'routes/nano_redirect_route.dart';
import 'routes/nano_route.dart';
import 'routes/nano_shell_route.dart';
import 'widgets/nano_error_page.dart';
import 'widgets/nano_guarded_page.dart';

/// Central declarative router manager for Flutter applications.
class NanoRouter {
  /// Creates a [NanoRouter] instance.
  NanoRouter({
    this.routes = const [],
    this.shells = const [],
    this.initialRoute = NanoPaths.root,
    this.errorBuilder,
    this.observers = const [],
  }) {
    for (final route in routes) {
      _registerRoute(route, '', const []);
    }
    for (final shell in shells) {
      _registerRoute(shell, '', const []);
    }
  }

  /// Global navigator key shared across the app.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// The list of navigation observers observing route changes.
  final List<NavigatorObserver> observers;

  /// The initial route path or name.
  final String initialRoute;

  /// The list of registered top-level routes.
  final List<NanoRoute> routes;

  /// The list of registered persistent shell routes.
  final List<NanoShellRoute<dynamic, dynamic>> shells;

  /// Custom error builder for not-found or unauthorized routes.
  final Widget Function(BuildContext context, NanoRouteError error)?
  errorBuilder;

  final Map<String, NanoRoute> _routeMap = {};
  final Map<String, String> _nameToPathMap = {};
  final Map<String, List<NanoProtectedRoute>> _routeGuardsMap = {};

  void _registerRoute(
    NanoRoute route,
    String parentPath,
    List<NanoProtectedRoute> activeGuards,
  ) {
    final fullPath = _joinPaths(parentPath, route.path);
    final currentGuards = List<NanoProtectedRoute>.from(activeGuards);

    if (route is NanoProtectedRoute) currentGuards.add(route);

    if (route is! NanoGroupRoute && route is! NanoProtectedRoute) {
      _routeMap[fullPath] = route;
      if (currentGuards.isNotEmpty) _routeGuardsMap[fullPath] = currentGuards;
    }

    if (route.name != null && route.name!.isNotEmpty) {
      _nameToPathMap[route.name!] = fullPath;
    }

    for (final child in route.routes) {
      _registerRoute(child, fullPath, currentGuards);
    }
  }

  String _joinPaths(String parent, String child) {
    if (child.isEmpty) return parent.isEmpty ? '/' : parent;
    if (parent.isEmpty || parent == '/') {
      return child.startsWith('/') ? child : '/$child';
    }
    final cleanParent = parent.endsWith('/')
        ? parent.substring(0, parent.length - 1)
        : parent;
    final cleanChild = child.startsWith('/') ? child.substring(1) : child;
    return '$cleanParent/$cleanChild';
  }

  /// Generates Flutter [Route] from [RouteSettings].
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final requested = settings.name ?? initialRoute;
    final path = _nameToPathMap[requested] ?? requested;
    final args = NanoRouteArgs(data: settings.arguments);

    final route = _routeMap[path];

    if (route == null) {
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => NanoErrorPage(
          error: NanoRouteError(
            path: path,
            code: NanoRouteCode.notFound,
            message: 'Route "$path" not found.',
          ),
          errorBuilder: errorBuilder,
        ),
      );
    }

    if (route is NanoRedirectRoute) {
      final target = _nameToPathMap[route.redirectTo] ?? route.redirectTo;
      return onGenerateRoute(
        RouteSettings(name: target, arguments: settings.arguments),
      );
    }

    final page = NanoGuardedPage(
      route: route,
      path: path,
      args: args,
      guards: _routeGuardsMap[path] ?? const [],
      nameToPathMap: _nameToPathMap,
    );

    if (route is NanoAnimatedRoute) {
      return PageRouteBuilder<dynamic>(
        settings: settings,
        transitionDuration: route.transitionDuration,
        reverseTransitionDuration: route.reverseTransitionDuration,
        opaque: route.opaque,
        barrierDismissible: route.barrierDismissible,
        barrierColor: route.barrierColor,
        barrierLabel: route.barrierLabel,
        maintainState: route.maintainState,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: route.transitionBuilder,
      );
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (context) => page,
    );
  }

  /// Navigates to a named route (accepts route name or path).
  static Future<T?> toNamed<T extends Object?>(
    String pathOrName, {
    Object? arguments,
  }) {
    final state = navigatorKey.currentState;
    if (state == null) return Future.value(null);
    return state.pushNamed<T>(pathOrName, arguments: arguments);
  }

  /// Replaces the current route with a named route.
  static Future<T?> toReplacementNamed<T extends Object?, TO extends Object?>(
    String pathOrName, {
    TO? result,
    Object? arguments,
  }) {
    final state = navigatorKey.currentState;
    if (state == null) return Future.value(null);
    return state.pushReplacementNamed<T, TO>(
      pathOrName,
      result: result,
      arguments: arguments,
    );
  }

  /// Clears the navigation stack and navigates to a named route.
  static Future<T?> toAndRemoveUntilNamed<T extends Object?>(
    String pathOrName, {
    bool Function(Route<dynamic>)? predicate,
    Object? arguments,
  }) {
    final state = navigatorKey.currentState;
    if (state == null) return Future.value(null);
    return state.pushNamedAndRemoveUntil<T>(
      pathOrName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Pops the current route off the navigator.
  static void back<T extends Object?>([T? result]) {
    final state = navigatorKey.currentState;
    if (state != null && state.canPop()) state.pop<T>(result);
  }
}
