import 'package:flutter/widgets.dart';
import '../../biometrics/nano_biometric_options.dart';
import '../../biometrics/nano_biometrics.dart';
import 'nano_route_guard.dart';

/// Signature for custom biometric authentication view builder.
///
/// [onAuthenticate] triggers the biometric authentication flow.
/// [onCancel] triggers fallback cancellation and redirects to `redirectTo`.
typedef NanoBiometricAuthBuilder = Widget Function(
  BuildContext context,
  VoidCallback onAuthenticate,
  VoidCallback onCancel,
);

/// Signature for resolving biometric options via [BuildContext].
typedef NanoBiometricOptionsBuilder =
    NanoBiometricOptions Function(BuildContext context);

/// A route guard wrapper that enforces biometric authentication for all child
/// [routes].
///
/// Extends [NanoRouteGuard] so all guards share a single unified
/// registration pipeline in `NanoRouter`.
/// If biometric hardware is unavailable or un-enrolled, or if authentication
/// fails/is cancelled, navigation automatically redirects to [redirectTo].
class NanoBiometricProtectedRoute extends NanoRouteGuard {
  /// Creates a [NanoBiometricProtectedRoute] guard wrapper.
  NanoBiometricProtectedRoute({
    required super.redirectTo,
    required super.routes,
    super.path = '',
    super.name,
    this.biometrics,
    this.optionsBuilder,
    this.authBuilder,
    this.loadingBuilder,
  });

  /// Optional injected [NanoBiometrics] service.
  ///
  /// If omitted, resolves automatically via `GetIt.I<NanoBiometrics>()`.
  final NanoBiometrics? biometrics;

  /// Optional callback to resolve [NanoBiometricOptions] dynamically with
  /// [BuildContext] (e.g. `(context) =>
  /// NanoBiometricOptions(reason: context.l10n.auth)`).
  final NanoBiometricOptionsBuilder? optionsBuilder;

  /// Optional custom authentication UI builder.
  ///
  /// When provided, allows creating custom lock screens, bottom sheets,
  /// or modals. If omitted, triggers native biometric prompt automatically
  /// with default loading feedback.
  final NanoBiometricAuthBuilder? authBuilder;

  /// Optional custom loading widget builder shown while evaluating biometrics.
  final WidgetBuilder? loadingBuilder;
}
