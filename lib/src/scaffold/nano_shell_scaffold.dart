import 'package:flutter/material.dart';

import 'internal/nano_shell_keep_alive_wrapper.dart';
import 'internal/nano_shell_scope.dart';
import 'nano_shell_controller.dart';
import 'widgets/nano_shell_sub_view.dart';
import 'widgets/nano_shell_tab.dart';

/// A comprehensive, reactive navigation shell scaffold.
///
/// Manages persistent primary tabs ([tabs]), optional contextual sub-views
/// ([subViews]), persistent floating action buttons ([floatingActionButton]),
/// bottom navigation bars ([bottomNavigationBar]), custom layout wrappers
/// ([builder]), drawers, and headers without tearing down or rebuilding
/// routes during tab switches.
///
/// Can be used in self-managed mode with [initialTab] (zero `setState`
/// required), or controlled externally via [controller] / [currentTab].
class NanoShellScaffold<TTab extends Enum, TSubView> extends StatefulWidget {
  /// Creates a [NanoShellScaffold] instance.
  const NanoShellScaffold({
    required this.tabs,
    this.initialTab,
    this.controller,
    this.currentTab,
    this.onTabChanged,
    this.subViews = const [],
    this.activeSubView,
    this.onSubViewChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.builder,
    this.drawer,
    this.endDrawer,
    this.header,
    this.headerHeight = kToolbarHeight,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.enablePopScope = true,
    super.key,
  }) : assert(tabs.length > 0, 'NanoShellScaffold must have at least one tab.');

  /// The list of primary tabs.
  final List<NanoShellTab<TTab>> tabs;

  /// The initial tab to select when [controller] is not provided.
  final TTab? initialTab;

  /// An optional [NanoShellController] to manage tab and sub-view state.
  final NanoShellController<TTab, TSubView>? controller;

  /// The currently selected primary tab (declarative mode).
  final TTab? currentTab;

  /// Callback invoked when a tab is selected.
  final ValueChanged<TTab>? onTabChanged;

  /// The list of optional contextual sub-views.
  final List<NanoShellSubView<TSubView>> subViews;

  /// The currently active sub-view, or `null` to display the active tab.
  final TSubView? activeSubView;

  /// Callback invoked when the active sub-view changes or closes.
  final ValueChanged<TSubView?>? onSubViewChanged;

  /// Custom builder for the persistent floating action button.
  final Widget? Function(
    BuildContext context,
    NanoShellController<TTab, TSubView> controller,
  )?
  floatingActionButton;

  /// The location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Custom builder for the persistent bottom navigation bar.
  final Widget? Function(
    BuildContext context,
    NanoShellController<TTab, TSubView> controller,
  )?
  bottomNavigationBar;

  /// Optional custom layout wrapper builder receiving the [context],
  /// [controller], and the [body] widget (containing tabs and sub-views).
  final Widget Function(
    BuildContext context,
    NanoShellController<TTab, TSubView> controller,
    Widget body,
  )?
  builder;

  /// Optional side drawer.
  final WidgetBuilder? drawer;

  /// Optional end drawer.
  final WidgetBuilder? endDrawer;

  /// Optional top header/AppBar builder.
  final PreferredSizeWidget? Function(
    BuildContext context,
    NanoShellController<TTab, TSubView> controller,
  )?
  header;

  /// The height of the header.
  final double headerHeight;

  /// Background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the body should resize when the keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Whether to automatically intercept system back gestures to close
  /// active sub-views.
  final bool enablePopScope;

  @override
  State<NanoShellScaffold<TTab, TSubView>> createState() =>
      _NanoShellScaffoldState<TTab, TSubView>();
}

class _NanoShellScaffoldState<TTab extends Enum, TSubView>
    extends State<NanoShellScaffold<TTab, TSubView>> {
  late NanoShellController<TTab, TSubView> _controller;
  bool _createdInternalController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _createdInternalController = false;
    } else {
      final resolvedInitialTab =
          widget.currentTab ??
          widget.initialTab ??
          widget.tabs.firstOrNull?.value;

      if (resolvedInitialTab != null) {
        assert(
          widget.tabs.any((t) => t.value == resolvedInitialTab),
          'NanoShellScaffold: The initial tab "$resolvedInitialTab" '
          'was not registered in "tabs".',
        );
      }

      if (widget.activeSubView != null) {
        assert(
          widget.subViews.any((s) => s.id == widget.activeSubView),
          'NanoShellScaffold: The initial activeSubView '
          '"${widget.activeSubView}" was not registered in "subViews".',
        );
      }

      _controller = NanoShellController<TTab, TSubView>(
        initialTab: resolvedInitialTab,
        initialSubView: widget.activeSubView,
      );
      _createdInternalController = true;
    }
    _controller.addListener(_handleControllerNotification);
  }

  void _handleControllerNotification() {
    if (widget.currentTab != null &&
        _controller.currentTab != widget.currentTab &&
        _controller.currentTab != null) {
      widget.onTabChanged?.call(_controller.currentTab!);
    }
    if (widget.onSubViewChanged != null) {
      widget.onSubViewChanged?.call(_controller.activeSubView);
    }
  }

  @override
  void didUpdateWidget(covariant NanoShellScaffold<TTab, TSubView> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerNotification);
      if (_createdInternalController) {
        _controller.dispose();
      }
      _initController();
    } else {
      if (widget.currentTab != null &&
          widget.currentTab != _controller.currentTab &&
          _controller.activeSubView == null) {
        _controller.selectTab(widget.currentTab!);
      }
      if (widget.activeSubView != oldWidget.activeSubView) {
        _controller.setSubView(widget.activeSubView);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerNotification);
    if (_createdInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  int _calculateIndex(NanoShellController<TTab, TSubView> controller) {
    if (controller.isShowingSubView) {
      final subIndex = widget.subViews.indexWhere(
        (s) => s.id == controller.activeSubView,
      );
      assert(
        subIndex != -1,
        'NanoShellScaffold: The requested sub-view '
        '"${controller.activeSubView}" was not registered in "subViews".',
      );
      if (subIndex != -1) {
        return widget.tabs.length + subIndex;
      }
    }

    if (controller.currentTab != null) {
      final tabIndex = widget.tabs.indexWhere(
        (t) => t.value == controller.currentTab,
      );
      assert(
        tabIndex != -1,
        'NanoShellScaffold: The requested tab "${controller.currentTab}" '
        'was not registered in "tabs".',
      );
      if (tabIndex != -1) return tabIndex;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return NanoShellScope(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final allChildren = <Widget>[
            for (final tab in widget.tabs)
              NanoShellKeepAliveWrapper(
                maintainState: tab.maintainState,
                child: Builder(builder: tab.builder),
              ),
            for (final subView in widget.subViews)
              Builder(builder: subView.builder),
          ];

          Widget bodyContent = IndexedStack(
            index: _calculateIndex(_controller),
            children: allChildren,
          );

          if (widget.enablePopScope) {
            bodyContent = PopScope(
              canPop: !_controller.isShowingSubView,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop && _controller.isShowingSubView) {
                  _controller.closeSubView();
                }
              },
              child: bodyContent,
            );
          }

          if (widget.builder != null) {
            return widget.builder!(context, _controller, bodyContent);
          }

          return Scaffold(
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            appBar: widget.header?.call(context, _controller),
            drawer: widget.drawer != null
                ? Builder(builder: widget.drawer!)
                : null,
            endDrawer: widget.endDrawer != null
                ? Builder(builder: widget.endDrawer!)
                : null,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            floatingActionButton: widget.floatingActionButton?.call(
              context,
              _controller,
            ),
            bottomNavigationBar: widget.bottomNavigationBar?.call(
              context,
              _controller,
            ),
            body: bodyContent,
          );
        },
      ),
    );
  }
}
