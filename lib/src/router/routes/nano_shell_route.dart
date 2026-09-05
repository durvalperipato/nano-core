import 'package:flutter/material.dart';

import '../../scaffold/nano_shell_controller.dart';
import '../../scaffold/nano_shell_scaffold.dart';
import '../../scaffold/widgets/nano_shell_sub_view.dart';
import '../../scaffold/widgets/nano_shell_tab.dart';
import 'nano_route.dart';

/// A declarative shell route for [NanoRouter] that manages persistent primary
/// tabs and contextual sub-views.
///
/// Use [builder] to wrap the active tab [body] and manage custom navigation
/// bars, drawers, or layout wrappers (such as sidebars or bottom navs).
class NanoShellRoute<TTab extends Enum, TSubView> extends NanoRoute {
  /// Creates a [NanoShellRoute] instance.
  NanoShellRoute({
    required super.path,
    required List<NanoShellTab<TTab>> tabs,
    super.name,
    super.routes,
    TTab? initialTab,
    List<NanoShellSubView<TSubView>> subViews = const [],
    Widget Function(
      BuildContext context,
      NanoShellController<TTab, TSubView> controller,
      Widget body,
    )?
    builder,
    bool enablePopScope = true,
  }) : super(
         builder: (context, _) => NanoShellScaffold<TTab, TSubView>(
           tabs: tabs,
           initialTab: initialTab,
           subViews: subViews,
           builder: builder,
           enablePopScope: enablePopScope,
         ),
       );
}

