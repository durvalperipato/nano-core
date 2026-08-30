import 'package:flutter/widgets.dart';

/// Navigation convenience extensions on [BuildContext].
extension NanoNavigationExtension on BuildContext {
  /// Navigates to a named route.
  Future<T?> toNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) => _navigator.pushNamed<T>(routeName, arguments: arguments);

  /// Replaces the current route with a named route.
  Future<T?> toReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => _navigator.pushReplacementNamed<T, TO>(
    routeName,
    result: result,
    arguments: arguments,
  );

  /// Clears the navigation stack and navigates to a named route.
  Future<T?> toAndRemoveUntilNamed<T extends Object?>(
    String routeName, {
    bool Function(Route<dynamic>)? predicate,
    Object? arguments,
  }) => _navigator.pushNamedAndRemoveUntil<T>(
    routeName,
    predicate ?? (route) => false,
    arguments: arguments,
  );

  /// Pops the current route from navigation.
  void back<T extends Object?>([T? result]) {
    if (_navigator.canPop()) _navigator.pop<T>(result);
  }

  /// Retrieves the arguments passed to the current route.
  Object? get routeArgs => ModalRoute.of(this)?.settings.arguments;

  /// Internal shortcut to retrieve the [NavigatorState] for this context.
  NavigatorState get _navigator => Navigator.of(this);
}
