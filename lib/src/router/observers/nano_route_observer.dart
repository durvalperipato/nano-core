import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';

/// A specialized navigation observer providing high-level callbacks for
/// route lifecycle, screen tracking, and telemetry in nano-core.
class NanoRouteObserver extends NavigatorObserver {
  /// Creates a [NanoRouteObserver] instance.
  NanoRouteObserver({
    this.onRouteChange,
    this.onRoutePushed,
    this.onRoutePopped,
    this.onRouteReplaced,
    this.onRouteRemoved,
  });

  /// Called whenever the active route changes (push, pop, or replace).
  ///
  /// Provides the previous route path `from`, the new route path `to`, and
  /// any route arguments `args` associated with the destination route.
  final void Function(String? from, String? to, NanoRouteArgs args)?
  onRouteChange;

  /// Called when a new route is pushed onto the navigation stack.
  final void Function(String path, NanoRouteArgs args)? onRoutePushed;

  /// Called when the active route is popped off the navigation stack.
  final void Function(String path, String? previousPath)? onRoutePopped;

  /// Called when a route is replaced by another route in the navigation stack.
  final void Function(String newPath, String? oldPath)? onRouteReplaced;

  /// Called when a route is removed from the navigation stack.
  final void Function(String path)? onRouteRemoved;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final to = route.settings.name ?? '';
    final from = previousRoute?.settings.name;
    final args = NanoRouteArgs(data: route.settings.arguments);

    if (to.isNotEmpty) {
      onRoutePushed?.call(to, args);
      onRouteChange?.call(from, to, args);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final from = route.settings.name ?? '';
    final to = previousRoute?.settings.name;
    final args = NanoRouteArgs(data: previousRoute?.settings.arguments);

    if (from.isNotEmpty) {
      onRoutePopped?.call(from, to);
      onRouteChange?.call(from, to, args);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final to = newRoute?.settings.name ?? '';
    final from = oldRoute?.settings.name;
    final args = NanoRouteArgs(data: newRoute?.settings.arguments);

    if (to.isNotEmpty) {
      onRouteReplaced?.call(to, from);
      onRouteChange?.call(from, to, args);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final path = route.settings.name ?? '';
    if (path.isNotEmpty) onRouteRemoved?.call(path);
  }
}
