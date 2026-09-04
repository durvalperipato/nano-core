import 'package:flutter/widgets.dart';

import '../scaffold/nano_shell.dart';

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

  /// Switches the active primary tab in the nearest [NanoShellScaffold].
  void toTab<TTab extends Enum>(TTab tab) {
    NanoShell.maybeOf<TTab, Object>(this, listen: false)?.selectTab(tab);
  }

  /// Opens a contextual sub-view in the nearest [NanoShellScaffold].
  void toSubView<TSubView>(TSubView subView) {
    NanoShell.maybeOf<Enum, TSubView>(this, listen: false)?.openSubView(
      subView,
    );
  }

  /// Closes the active contextual sub-view in the nearest [NanoShellScaffold].
  void closeSubView() {
    NanoShell.maybeOf<Enum, Object>(this, listen: false)?.closeSubView();
  }

  /// Retrieves the currently active tab in the nearest [NanoShellScaffold],
  /// or `null` if none is active or when a sub-view is open.
  TTab? currentTab<TTab extends Enum>() {
    final tab =
        NanoShell.maybeOf<TTab, Object>(
          this,
          listen: true,
        )?.effectiveActiveTab;
    return tab is TTab ? tab : null;
  }

  /// Internal shortcut to retrieve the [NavigatorState] for this context.
  NavigatorState get _navigator => Navigator.of(this);
}
