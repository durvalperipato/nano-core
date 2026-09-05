import 'package:flutter/widgets.dart';

import '../scaffold/nano_shell_context.dart';

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

  /// Accesses actions and state of the nearest [NanoShellScaffold].
  NanoShellContext get shell => NanoShellContext(this);

  /// Switches the active primary tab in the nearest [NanoShellScaffold].
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated(
    'Use context.shell.selectTab(tab) instead. Will be removed in 1.2.0.',
  )
  void toTab<TTab extends Enum>(TTab tab) => shell.selectTab(tab);

  /// Opens a contextual sub-view in the nearest [NanoShellScaffold].
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated(
    'Use context.shell.openSubView(subView) instead. Will be removed in 1.2.0.',
  )
  void toSubView<TSubView>(TSubView subView) => shell.openSubView(subView);

  /// Closes the active contextual sub-view in the nearest [NanoShellScaffold].
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated(
    'Use context.shell.closeSubView() instead. Will be removed in 1.2.0.',
  )
  void closeSubView() => shell.closeSubView();

  /// Retrieves the currently active tab in the nearest [NanoShellScaffold],
  /// or `null` if none is active or when a sub-view is open.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated(
    'Use context.shell.currentTab<T>() instead. Will be removed in 1.2.0.',
  )
  TTab? currentTab<TTab extends Enum>() => shell.currentTab<TTab>();

  /// Internal shortcut to retrieve the [NavigatorState] for this context.
  NavigatorState get _navigator => Navigator.of(this);
}
