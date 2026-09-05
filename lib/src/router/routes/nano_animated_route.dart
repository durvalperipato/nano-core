import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route.dart';
import 'nano_route_base.dart';

/// A declarative route that uses a custom animation transition when
/// navigated to.
class NanoAnimatedRoute extends NanoRoute {
  /// Creates a [NanoAnimatedRoute] with a custom [transitionBuilder].
  const NanoAnimatedRoute({
    required super.path,
    required super.builder,
    required this.transitionBuilder,
    super.name,
    super.routes,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  /// Creates a [NanoAnimatedRoute] with a smooth fade animation.
  factory NanoAnimatedRoute.fade({
    required String path,
    required Widget Function(BuildContext context, NanoRouteArgs args) builder,
    String? name,
    List<NanoRouteBase> routes = const [],
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return NanoAnimatedRoute(
      path: path,
      name: name,
      routes: routes,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      },
      builder: builder,
    );
  }

  /// Creates a [NanoAnimatedRoute] that slides in from the bottom
  /// (modal style).
  factory NanoAnimatedRoute.slideUp({
    required String path,
    required Widget Function(BuildContext context, NanoRouteArgs args) builder,
    String? name,
    List<NanoRouteBase> routes = const [],
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOutCubic,
  }) {
    return NanoAnimatedRoute(
      path: path,
      name: name,
      routes: routes,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      builder: builder,
    );
  }

  /// Creates a [NanoAnimatedRoute] that slides in from the right.
  factory NanoAnimatedRoute.slideRight({
    required String path,
    required Widget Function(BuildContext context, NanoRouteArgs args) builder,
    String? name,
    List<NanoRouteBase> routes = const [],
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOutCubic,
  }) {
    return NanoAnimatedRoute(
      path: path,
      name: name,
      routes: routes,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      builder: builder,
    );
  }

  /// Creates a [NanoAnimatedRoute] with a scale/zoom entrance animation.
  factory NanoAnimatedRoute.scale({
    required String path,
    required Widget Function(BuildContext context, NanoRouteArgs args) builder,
    String? name,
    List<NanoRouteBase> routes = const [],
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutBack,
  }) {
    return NanoAnimatedRoute(
      path: path,
      name: name,
      routes: routes,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: curve));

        return ScaleTransition(scale: scaleAnimation, child: child);
      },
      builder: builder,
    );
  }

  /// The builder creating the transition animation.
  final RouteTransitionsBuilder transitionBuilder;

  /// The forward transition duration.
  final Duration transitionDuration;

  /// The reverse transition duration when popping.
  final Duration reverseTransitionDuration;

  /// Whether this route obscures previous routes.
  final bool opaque;

  /// Whether tapping the modal barrier dismisses the route.
  final bool barrierDismissible;

  /// Color of the modal barrier.
  final Color? barrierColor;

  /// Semantic label for the modal barrier.
  final String? barrierLabel;

  /// Whether the route should remain in memory when inactive.
  final bool maintainState;
}
