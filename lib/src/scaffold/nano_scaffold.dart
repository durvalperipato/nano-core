import 'package:flutter/material.dart';
import '../components/nano_loading_overlay.dart';
import '../components/nano_toast.dart';
import '../controller/nano_controller.dart';
import '../state/nano_message_key.dart';
import '../state/nano_state.dart';
import '../state/nano_view_state.dart';

/// [NanoScaffold] is the reactive base page layout structure in nano-core.
///
/// Generic over [T], where [T] represents the page's [NanoViewState],
/// and [M], where [M] represents the strongly typed [NanoMessageKey].
///
/// Supports:
/// - [header]: Static top bar (Web/Desktop Navbar or Mobile AppBar).
/// - [headerBuilder]: Dynamic top bar builder receiving current [NanoState].
/// - [headerHeight]: Custom height for [header] when it is not a
///   [PreferredSizeWidget].
/// - Automatic state observation via [NanoController] to display loading
///   overlays, custom error/warning/success toasts via [NanoToast], or
///   custom callbacks.
/// - Passes the current [NanoState] directly to [builder], [headerBuilder],
///   [footerBuilder], [drawerBuilder], and [floatingActionButtonBuilder].
/// - Strongly-typed message callbacks [onCustomError] and [onCustomWarning]
///   using [M].
class NanoScaffold<T extends NanoViewState, M extends NanoMessageKey>
    extends StatefulWidget {
  /// Creates a [NanoScaffold] widget layout.
  const NanoScaffold({
    super.key,
    this.controller,
    this.header,
    this.headerBuilder,
    this.headerHeight = kToolbarHeight,
    this.drawer,
    this.drawerBuilder,
    this.footer,
    this.footerBuilder,
    this.floatingActionButton,
    this.floatingActionButtonBuilder,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.onCustomError,
    this.onCustomWarning,
    this.onCustomSuccess,
    required this.builder,
  });

  /// Optional reactive controller managing page state.
  final NanoController<T>? controller;

  /// Static top navigation bar or header (Web Navbar, Mobile AppBar).
  final Widget? header;

  /// Dynamic top navigation bar builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<T> state)?
  headerBuilder;

  /// Custom height for [header] when not a [PreferredSizeWidget].
  /// Defaults to [kToolbarHeight].
  final double headerHeight;

  /// Static side navigation drawer.
  final Widget? drawer;

  /// Dynamic drawer builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<T> state)?
  drawerBuilder;

  /// Static bottom navigation bar or footer.
  final Widget? footer;

  /// Dynamic footer builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<T> state)?
  footerBuilder;

  /// Static floating action button.
  final Widget? floatingActionButton;

  /// Dynamic floating action button builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<T> state)?
  floatingActionButtonBuilder;

  /// Page background color.
  final Color? backgroundColor;

  /// Whether to resize contents when soft keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Optional custom error callback. If null, displays default
  /// [NanoToast.showError].
  final void Function(M? error)? onCustomError;

  /// Optional custom warning callback. If null, displays default
  /// [NanoToast.showWarning].
  final void Function(M? warning)? onCustomWarning;

  /// Optional custom success callback. If null, displays default
  /// [NanoToast.showSuccess].
  final void Function(String message)? onCustomSuccess;

  /// Main page content builder, receiving current context and [NanoState].
  final Widget Function(BuildContext context, NanoState<T> state) builder;

  @override
  State<NanoScaffold<T, M>> createState() => _NanoScaffoldState<T, M>();
}

class _NanoScaffoldState<T extends NanoViewState, M extends NanoMessageKey>
    extends State<NanoScaffold<T, M>> {
  @override
  void initState() {
    super.initState();
    _subscribeController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant NanoScaffold<T, M> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unsubscribeController(oldWidget.controller);
      _subscribeController(widget.controller);
    }
  }

  @override
  void dispose() {
    _unsubscribeController(widget.controller);
    super.dispose();
  }

  void _subscribeController(NanoController<T>? controller) {
    controller?.addListener(_onStateChanged);
  }

  void _unsubscribeController(NanoController<T>? controller) {
    controller?.removeListener(_onStateChanged);
  }

  void _onStateChanged() {
    final controller = widget.controller;
    if (controller == null) return;

    final state = controller.state;

    if (state case ErrorState(:final key)) {
      final typedKey = key is M ? key : null;
      if (widget.onCustomError != null) {
        widget.onCustomError!(typedKey);
      } else {
        NanoToast.showError(context, key?.message(context) ?? '');
      }
    } else if (state case WarningState(:final key)) {
      final typedKey = key is M ? key : null;
      if (widget.onCustomWarning != null) {
        widget.onCustomWarning!(typedKey);
      } else {
        NanoToast.showWarning(context, key?.message(context) ?? '');
      }
    } else if (state case SuccessState(:final data)) {
      final successMsg = data.toString();
      if (successMsg.isNotEmpty) {
        if (widget.onCustomSuccess != null) {
          widget.onCustomSuccess!(successMsg);
        } else {
          NanoToast.showSuccess(context, successMsg);
        }
      }
    }
  }

  PreferredSizeWidget? _buildEffectiveHeader(NanoState<T> state) {
    final effectiveWidget = widget.headerBuilder != null
        ? widget.headerBuilder!(context, state)
        : widget.header;

    if (effectiveWidget == null) return null;
    if (effectiveWidget is PreferredSizeWidget) return effectiveWidget;
    return PreferredSize(
      preferredSize: Size.fromHeight(widget.headerHeight),
      child: effectiveWidget,
    );
  }

  Widget? _buildEffectiveDrawer(NanoState<T> state) {
    return widget.drawerBuilder != null
        ? widget.drawerBuilder!(context, state)
        : widget.drawer;
  }

  Widget? _buildEffectiveFooter(NanoState<T> state) {
    return widget.footerBuilder != null
        ? widget.footerBuilder!(context, state)
        : widget.footer;
  }

  Widget? _buildEffectiveFab(NanoState<T> state) {
    return widget.floatingActionButtonBuilder != null
        ? widget.floatingActionButtonBuilder!(context, state)
        : widget.floatingActionButton;
  }

  Widget _buildScaffoldWithState(NanoState<T> state) {
    return Scaffold(
      appBar: _buildEffectiveHeader(state),
      drawer: _buildEffectiveDrawer(state),
      bottomNavigationBar: _buildEffectiveFooter(state),
      floatingActionButton: _buildEffectiveFab(state),
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: [
          widget.builder(context, state),
          if (state is LoadingState) const NanoLoadingOverlay(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    if (controller == null) {
      return _buildScaffoldWithState(InitialState<T>());
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _buildScaffoldWithState(controller.state),
    );
  }
}
