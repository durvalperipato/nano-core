import 'nano_route_base.dart';

/// A route that redirects navigation from [path] to [redirectTo].
class NanoRedirectRoute extends NanoRouteBase {
  /// Creates a [NanoRedirectRoute].
  NanoRedirectRoute({
    required super.path,
    required this.redirectTo,
    super.name,
    super.routes = const <NanoRouteBase>[],
  });

  /// The target destination path to redirect to.
  final String redirectTo;
}

