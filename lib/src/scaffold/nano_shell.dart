import 'package:flutter/widgets.dart';

import 'internal/nano_shell_scope.dart';
import 'nano_shell_controller.dart';

/// Helper utility for accessing [NanoShellController] from the widget tree.
abstract final class NanoShell {
  /// Obtains the [NanoShellController] from the nearest [NanoShellScaffold]
  /// ancestor.
  static NanoShellController<TTab, TSubView> of<TTab extends Enum, TSubView>(
    BuildContext context, {
    bool listen = true,
  }) {
    final controller = maybeOf<TTab, TSubView>(context, listen: listen);
    assert(
      controller != null,
      'No NanoShellScaffold found in the given BuildContext. '
      'Make sure that the context is a descendant of a NanoShellScaffold.',
    );
    return controller!;
  }

  /// Obtains the [NanoShellController] from the nearest [NanoShellScaffold]
  /// ancestor, or `null` if none is found.
  static NanoShellController<TTab, TSubView>? maybeOf<
    TTab extends Enum,
    TSubView
  >(BuildContext context, {bool listen = true}) {
    return NanoShellScope.maybeOf<TTab, TSubView>(context, listen: listen);
  }
}
