import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../biometrics/nano_biometrics.dart';
import '../../logger/nano_logger.dart';
import '../models/nano_route_args.dart';
import '../nano_router.dart';
import '../routes/nano_biometric_protected_route.dart';
import '../routes/nano_protected_route.dart';
import '../routes/nano_route.dart';
import '../routes/nano_route_base.dart';
import '../routes/nano_route_guard.dart';
import '../routes/nano_shell_route.dart';

/// A wrapper widget that evaluates route guards before rendering the page.
class NanoGuardedPage extends StatelessWidget {
  /// Creates a [NanoGuardedPage] widget.
  const NanoGuardedPage({
    required this.route,
    required this.path,
    required this.args,
    required this.guards,
    required this.nameToPathMap,
    super.key,
  });

  /// The target route to build.
  final NanoRouteBase route;

  /// The requested path.
  final String path;

  /// Route arguments passed to this route.
  final NanoRouteArgs args;

  /// List of active protected guards protecting this route.
  final List<NanoRouteGuard> guards;

  /// Route name-to-path resolution mapping.
  final Map<String, String> nameToPathMap;

  @override
  Widget build(BuildContext context) {
    if (guards.isNotEmpty) {
      for (final guard in guards) {
        if (guard is NanoProtectedRoute) {
          final hasAccess = guard.hasAccess(context, args);
          if (!hasAccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final target =
                  nameToPathMap[guard.redirectTo] ?? guard.redirectTo;
              NanoRouter.toReplacementNamed(target, arguments: args.data);
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        }
      }
    }

    final targetRoute = route;
    Widget content = const SizedBox.shrink();
    if (targetRoute is NanoShellRoute) {
      content = targetRoute.buildWidget(context);
    } else if (targetRoute is NanoRoute) {
      content = targetRoute.builder(context, args);
    }

    final biometricGuards =
        guards.whereType<NanoBiometricProtectedRoute>().toList();
    if (biometricGuards.isNotEmpty) {
      return NanoBiometricGate(
        biometricGuards: biometricGuards,
        args: args,
        nameToPathMap: nameToPathMap,
        child: content,
      );
    }

    return content;
  }
}

/// An internal gate widget that evaluates biometric authentication requirements
/// asynchronously before revealing [child].
class NanoBiometricGate extends StatefulWidget {
  /// Creates a [NanoBiometricGate] widget.
  const NanoBiometricGate({
    required this.biometricGuards,
    required this.args,
    required this.nameToPathMap,
    required this.child,
    super.key,
  });

  /// The active biometric guards to evaluate in order.
  final List<NanoBiometricProtectedRoute> biometricGuards;

  /// Route arguments passed to the route.
  final NanoRouteArgs args;

  /// Name to path resolution mapping.
  final Map<String, String> nameToPathMap;

  /// The protected child widget to render upon successful authentication.
  final Widget child;

  @override
  State<NanoBiometricGate> createState() => _NanoBiometricGateState();
}

class _NanoBiometricGateState extends State<NanoBiometricGate> {
  bool _isAuthenticated = false;
  bool _isRedirecting = false;
  bool _hardwareChecked = false;
  bool _hardwareAvailable = false;
  int _activeGuardIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBiometrics();
    });
  }

  NanoBiometricProtectedRoute? get _currentGuard {
    if (_activeGuardIndex < widget.biometricGuards.length) {
      return widget.biometricGuards[_activeGuardIndex];
    }
    return null;
  }

  NanoBiometrics? _resolveBiometrics(NanoBiometricProtectedRoute guard) {
    if (guard.biometrics != null) return guard.biometrics;
    if (GetIt.I.isRegistered<NanoBiometrics>()) {
      return GetIt.I<NanoBiometrics>();
    }
    return null;
  }

  Future<void> _initBiometrics() async {
    final guard = _currentGuard;
    if (guard == null) {
      if (mounted) setState(() => _isAuthenticated = true);
      return;
    }

    final biometrics = _resolveBiometrics(guard);
    if (biometrics == null) {
      NanoLogger.debug(
        'NanoBiometrics service is not registered in GetIt and was not '
        'provided. Redirecting to "${guard.redirectTo}".',
        tag: 'NanoBiometrics',
      );
      _redirect(guard.redirectTo);
      return;
    }

    try {
      final available = await biometrics.isAvailable();
      if (!mounted) return;
      if (!available) {
        NanoLogger.debug(
          'Biometric authentication is unavailable or un-enrolled on this '
          'device. Redirecting to "${guard.redirectTo}".',
          tag: 'NanoBiometrics',
        );
        _redirect(guard.redirectTo);
        return;
      }

      setState(() {
        _hardwareChecked = true;
        _hardwareAvailable = true;
      });

      if (guard.authBuilder == null) {
        await _authenticate(guard, biometrics);
      }
    } catch (e) {
      NanoLogger.debug(
        'Error during biometric availability check: $e. Redirecting to '
        '"${guard.redirectTo}".',
        tag: 'NanoBiometrics',
      );
      _redirect(guard.redirectTo);
    }
  }

  Future<void> _authenticate(
    NanoBiometricProtectedRoute guard,
    NanoBiometrics biometrics,
  ) async {
    if (_isRedirecting) return;

    final options = guard.optionsBuilder?.call(context);

    try {
      final success = await biometrics.authenticate(options);
      if (!mounted) return;
      if (success) {
        if (_activeGuardIndex + 1 < widget.biometricGuards.length) {
          setState(() {
            _activeGuardIndex++;
            _hardwareChecked = false;
            _hardwareAvailable = false;
          });
          await _initBiometrics();
        } else {
          setState(() {
            _isAuthenticated = true;
          });
        }
      } else {
        NanoLogger.debug(
          'Biometric authentication failed or was cancelled by user. '
          'Redirecting to "${guard.redirectTo}".',
          tag: 'NanoBiometrics',
        );
        _redirect(guard.redirectTo);
      }
    } catch (e) {
      NanoLogger.debug(
        'Biometric authentication error: $e. Redirecting to '
        '"${guard.redirectTo}".',
        tag: 'NanoBiometrics',
      );
      _redirect(guard.redirectTo);
    }
  }

  void _cancel(NanoBiometricProtectedRoute guard) {
    NanoLogger.debug(
      'Biometric authentication cancelled by user. Redirecting to '
      '"${guard.redirectTo}".',
      tag: 'NanoBiometrics',
    );
    _redirect(guard.redirectTo);
  }

  void _redirect(String targetRedirect) {
    if (_isRedirecting) return;
    _isRedirecting = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = widget.nameToPathMap[targetRedirect] ?? targetRedirect;
      NanoRouter.toReplacementNamed(target, arguments: widget.args.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }

    final guard = _currentGuard;
    if (guard != null &&
        guard.authBuilder != null &&
        _hardwareChecked &&
        _hardwareAvailable &&
        !_isRedirecting) {
      return guard.authBuilder!(
        context,
        () {
          final biometrics = _resolveBiometrics(guard);
          if (biometrics != null) {
            _authenticate(guard, biometrics);
          } else {
            _redirect(guard.redirectTo);
          }
        },
        () => _cancel(guard),
      );
    }

    if (guard?.loadingBuilder != null) {
      return guard!.loadingBuilder!(context);
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
