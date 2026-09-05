import 'package:flutter/material.dart';

import '../../scaffold/nano_shell_controller.dart';
import '../../scaffold/nano_shell_scaffold.dart';
import '../../scaffold/widgets/nano_shell_sub_view.dart';
import '../../scaffold/widgets/nano_shell_tab.dart';
import 'nano_route_base.dart';

/// A declarative shell route for [NanoRouter] that manages persistent primary
/// tabs and contextual sub-views.
///
/// Use [builder] to wrap the active tab [body] and manage custom navigation
/// bars, drawers, or layout wrappers (such as sidebars or bottom navs).
class NanoShellRoute<TTab extends Enum, TSubView> extends NanoRouteBase {
  /// Creates a [NanoShellRoute] instance.
  NanoShellRoute({
    required super.path,
    required this.tabs,
    super.name,
    super.routes = const <NanoRouteBase>[],
    this.initialTab,
    this.subViews = const [],
    this.builder,
    this.enablePopScope = true,
  });

  /// The list of primary tabs.
  final List<NanoShellTab<TTab>> tabs;

  /// The initial tab to select.
  final TTab? initialTab;

  /// The list of optional contextual sub-views.
  final List<NanoShellSubView<TSubView>> subViews;

  /// Custom layout wrapper builder.
  final Widget Function(
    BuildContext context,
    NanoShellController<TTab, TSubView> controller,
    Widget body,
  )?
  builder;

  /// Whether to intercept the system back-gesture when a sub-view is open.
  final bool enablePopScope;

  /// Builds the persistent [NanoShellScaffold] widget for this route.
  Widget buildWidget(BuildContext context) => NanoShellScaffold<TTab, TSubView>(
    tabs: tabs,
    initialTab: initialTab,
    subViews: subViews,
    builder: builder,
    enablePopScope: enablePopScope,
  );
}



