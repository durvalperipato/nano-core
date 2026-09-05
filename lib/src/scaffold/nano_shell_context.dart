import 'package:flutter/widgets.dart';

import 'nano_shell.dart';
import 'nano_shell_controller.dart';

/// Contextual helper that exposes actions and state of the nearest
/// [NanoShellScaffold].
class NanoShellContext {
  /// Creates a [NanoShellContext] bound to the provided [BuildContext].
  const NanoShellContext(this._context);

  final BuildContext _context;

  /// Switches the active primary tab in the nearest [NanoShellScaffold].
  void selectTab<TTab extends Enum>(TTab tab) =>
      NanoShell.maybeOf<TTab, Object>(_context, listen: false)?.selectTab(tab);

  /// Opens a contextual sub-view in the nearest [NanoShellScaffold].
  void openSubView<TSubView>(TSubView subView) =>
      NanoShell.maybeOf<Enum, TSubView>(
        _context,
        listen: false,
      )?.openSubView(subView);

  /// Closes the active contextual sub-view in the nearest [NanoShellScaffold].
  void closeSubView() =>
      NanoShell.maybeOf<Enum, Object>(_context, listen: false)?.closeSubView();

  /// Retrieves the currently active tab in the nearest [NanoShellScaffold],
  /// or `null` if none is active or when a sub-view is open.
  TTab? currentTab<TTab extends Enum>({bool listen = true}) {
    final tab = NanoShell.maybeOf<TTab, Object>(
      _context,
      listen: listen,
    )?.effectiveActiveTab;
    return tab is TTab ? tab : null;
  }

  /// Retrieves the currently active sub-view in the nearest
  /// [NanoShellScaffold], or `null` if no sub-view is open.
  TSubView? activeSubView<TSubView>({bool listen = true}) {
    final subView = NanoShell.maybeOf<Enum, TSubView>(
      _context,
      listen: listen,
    )?.activeSubView;
    return subView is TSubView ? subView : null;
  }

  /// Whether a contextual sub-view is currently active in the nearest
  /// [NanoShellScaffold].
  bool isSubViewOpen({bool listen = true}) =>
      NanoShell.maybeOf<Enum, Object>(
        _context,
        listen: listen,
      )?.isShowingSubView ??
      false;

  /// Accesses the underlying [NanoShellController] directly.
  NanoShellController<TTab, TSubView>? controller<TTab extends Enum, TSubView>({
    bool listen = false,
  }) => NanoShell.maybeOf<TTab, TSubView>(_context, listen: listen);
}
