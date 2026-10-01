import 'nano_route_base.dart';

/// An abstract base class for route guards that intercept navigation and
/// enforce access rules before rendering child [routes].
///
/// Subclasses include:
/// - [NanoProtectedRoute] for synchronous permission-based guards.
/// - [NanoBiometricProtectedRoute] for asynchronous biometric authentication
///   guards.
abstract class NanoRouteGuard extends NanoRouteBase {
  /// Creates a [NanoRouteGuard] wrapper.
  NanoRouteGuard({
    required this.redirectTo,
    required super.routes,
    super.path = '',
    super.name,
  });

  /// The destination path or route name to redirect to when access
  /// evaluation fails.
  final String redirectTo;
}
