import 'package:flutter/widgets.dart';
import '../models/nano_route_args.dart';
import 'nano_route.dart';

/// A specialized declarative route for details and sub-pages.
///
/// Automatically extracts typed arguments of type [Args] from route
/// parameters, maps, or direct objects and provides them directly to
/// [builder].
class NanoDetailsRoute<Args> extends NanoRoute {
  /// Creates a [NanoDetailsRoute].
  NanoDetailsRoute({
    required Widget Function(BuildContext context, Args? data) builder,
    super.path = '/detail',
    super.name,
    super.routes,
  }) : super(
         builder: (context, args) {
           final extracted = _extractTypedData<Args>(args);
           return builder(context, extracted);
         },
       );

  static TargetType? _extractTypedData<TargetType>(NanoRouteArgs args) {
    final raw = args.data;
    if (raw is TargetType) return raw;

    if (raw is Map) {
      for (final value in raw.values) {
        if (value is TargetType) return value;
      }
    }

    if (args.pathParameters.isNotEmpty) {
      final first = args.pathParameters.values.first;
      if (TargetType == String) return first as TargetType;
      if (TargetType == int) {
        final parsed = int.tryParse(first);
        if (parsed != null) return parsed as TargetType;
      }
      if (TargetType == double) {
        final parsed = double.tryParse(first);
        if (parsed != null) return parsed as TargetType;
      }
    }
    return null;
  }
}
