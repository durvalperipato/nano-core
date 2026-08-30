import 'package:flutter/widgets.dart';
import 'nano_route.dart';

/// A route that redirects navigation from [path] to [redirectTo].
class NanoRedirectRoute extends NanoRoute {
  /// Creates a [NanoRedirectRoute].
  NanoRedirectRoute({
    required super.path,
    required this.redirectTo,
    super.name,
  }) : super(
         builder: (context, args) => const SizedBox.shrink(),
       );

  /// The target destination path to redirect to.
  final String redirectTo;
}
