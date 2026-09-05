/// Base abstract class for all declarative routes within [NanoRouter].
///
/// Subclasses include:
/// - [NanoRoute] for standard page routes with widget builders.
/// - [NanoShellRoute] for persistent tab/sub-view navigation shells.
/// - [NanoProtectedRoute] for permission and auth guards wrapping routes.
/// - [NanoGroupRoute] for prefix-only grouping containers.
/// - [NanoRedirectRoute] for path-to-path navigation aliases.
abstract class NanoRouteBase {
  /// Creates a [NanoRouteBase] instance.
  const NanoRouteBase({
    required this.path,
    this.name,
    this.routes = const <NanoRouteBase>[],
  });

  /// The unique path pattern for this route (e.g. `'/users'` or `'/detail'`).
  final String path;

  /// Optional unique name identifier for this route (e.g. `'user_detail'`).
  final String? name;

  /// Nested sub-routes belonging to this route.
  final List<NanoRouteBase> routes;
}
