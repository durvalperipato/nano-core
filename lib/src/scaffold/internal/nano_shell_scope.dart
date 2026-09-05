import 'package:flutter/widgets.dart';

import '../nano_shell_controller.dart';
import 'nano_shell_controller_base.dart';

/// An internal [InheritedNotifier] providing [NanoShellControllerBase] down
/// the widget tree.
class NanoShellScope extends InheritedNotifier<NanoShellControllerBase> {
  /// Creates a [NanoShellScope].
  const NanoShellScope({
    required NanoShellControllerBase controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Retrieves the [NanoShellController] from the nearest [NanoShellScope]
  /// ancestor.
  static NanoShellController<TTab, TSubView>? maybeOf<
    TTab extends Enum,
    TSubView
  >(BuildContext context, {bool listen = true}) {
    if (listen) {
      final scope = context
          .dependOnInheritedWidgetOfExactType<NanoShellScope>();
      return scope?.notifier as NanoShellController<TTab, TSubView>?;
    }
    final widget = context
        .getElementForInheritedWidgetOfExactType<NanoShellScope>()
        ?.widget;
    return (widget as NanoShellScope?)?.notifier
        as NanoShellController<TTab, TSubView>?;
  }
}
