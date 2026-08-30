import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route.dart';

/// A specialized declarative route for details and sub-pages.
///
/// Automatically extracts typed arguments of type [T] from route parameters,
/// maps, or direct objects and provides them directly to [builder].
class NanoDetailsRoute<T> extends NanoRoute {
  /// Creates a [NanoDetailsRoute].
  NanoDetailsRoute({
    required Widget Function(BuildContext context, T? data) builder,
    super.path = '/detail',
    super.name,
    super.routes,
  }) : super(
         builder: (context, args) {
           final extracted = _extractTypedData<T>(args);
           return builder(context, extracted);
         },
       );

  static T? _extractTypedData<T>(NanoRouteArgs args) {
    final raw = args.data;
    if (raw is T) return raw;

    if (raw is Map) {
      for (final value in raw.values) {
        if (value is T) return value;
      }
    }
    return null;
  }
}
