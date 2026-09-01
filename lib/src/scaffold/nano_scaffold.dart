import 'package:flutter/material.dart';
import '../components/nano_loading_overlay.dart';
import '../components/nano_toast.dart';
import '../controller/nano_controller.dart';
import '../state/nano_message_key.dart';
import '../state/nano_state.dart';
import '../state/nano_state_observable.dart';
import '../state/nano_view_state.dart';
import 'widgets/nano_scaffold_builder.dart';

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
/// - Automatic state observation via [NanoStateObservable] (such as
///   [NanoController], BLoC, Cubit, or MobX adapters) to display loading
///   overlays, custom error/warning/success toasts via [NanoToast], or
///   custom callbacks.
/// - Passes the current [NanoState] directly to [builder], [headerBuilder],
///   [footerBuilder], [drawerBuilder], and [floatingActionButtonBuilder].
/// - Strongly-typed message callbacks [onCustomError] and [onCustomWarning]
///   using [MessageKey].
/// - Customizable [loadingWidget] overlay when the state is [LoadingState].
class NanoScaffold<
  ViewState extends NanoViewState,
  MessageKey extends NanoMessageKey
>
    extends StatefulWidget {
  /// Creates a [NanoScaffold] widget layout.
  const NanoScaffold({
    required this.builder,
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
    this.loadingWidget,
    this.onCustomError,
    this.onCustomWarning,
    this.onCustomSuccess,
    super.key,
  });

  /// Optional reactive state observable (such as [NanoController] or custom
  /// BLoC / MobX adapter) managing page state.
  final NanoStateObservable<ViewState>? controller;

  /// Static top navigation bar or header (Web Navbar, Mobile AppBar).
  final Widget? header;

  /// Dynamic top navigation bar builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  headerBuilder;

  /// Custom height for [header] when not a [PreferredSizeWidget].
  /// Defaults to [kToolbarHeight].
  final double headerHeight;

  /// Static side navigation drawer.
  final Widget? drawer;

  /// Dynamic drawer builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  drawerBuilder;

  /// Static bottom navigation bar or footer.
  final Widget? footer;

  /// Dynamic footer builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  footerBuilder;

  /// Static floating action button.
  final Widget? floatingActionButton;

  /// Dynamic floating action button builder receiving the current [NanoState].
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  floatingActionButtonBuilder;

  /// Page background color.
  final Color? backgroundColor;

  /// Whether to resize contents when soft keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Optional custom loading widget displayed when state is [LoadingState].
  ///
  /// Defaults to [NanoLoadingOverlay].
  final Widget? loadingWidget;

  /// Optional custom error callback. If null, displays default
  /// [NanoToast.showError].
  final void Function(MessageKey? error)? onCustomError;

  /// Optional custom warning callback. If null, displays default
  /// [NanoToast.showWarning].
  final void Function(MessageKey? warning)? onCustomWarning;

  /// Optional custom success callback. If null, displays default
  /// [NanoToast.showSuccess].
  final void Function(String message)? onCustomSuccess;

  /// Main page content builder, receiving current context and [NanoState].
  final Widget Function(BuildContext context, NanoState<ViewState> state)
  builder;

  @override
  State<NanoScaffold<ViewState, MessageKey>> createState() =>
      _NanoScaffoldState<ViewState, MessageKey>();
}

class _NanoScaffoldState<
  ViewState extends NanoViewState,
  MessageKey extends NanoMessageKey
>
    extends State<NanoScaffold<ViewState, MessageKey>> {
  @override
  void initState() {
    super.initState();
    _subscribeController(widget.controller);
  }

  @override
  void didUpdateWidget(
    covariant NanoScaffold<ViewState, MessageKey> oldWidget,
  ) {
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

  void _subscribeController(NanoStateObservable<ViewState>? controller) {
    controller?.addListener(_onStateChanged);
  }

  void _unsubscribeController(NanoStateObservable<ViewState>? controller) {
    controller?.removeListener(_onStateChanged);
  }

  void _onStateChanged() {
    final controller = widget.controller;
    if (controller == null) return;

    final state = controller.state;

    if (state case ErrorState(:final key)) {
      final typedKey = key is MessageKey ? key : null;
      if (widget.onCustomError != null) {
        widget.onCustomError!(typedKey);
      } else {
        NanoToast.showError(context, key?.message(context) ?? '');
      }
    } else if (state case WarningState(:final key)) {
      final typedKey = key is MessageKey ? key : null;
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

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    if (controller == null) {
      return NanoScaffoldBuilder<ViewState>(
        state: InitialState<ViewState>(),
        builder: widget.builder,
        header: widget.header,
        headerBuilder: widget.headerBuilder,
        headerHeight: widget.headerHeight,
        drawer: widget.drawer,
        drawerBuilder: widget.drawerBuilder,
        footer: widget.footer,
        footerBuilder: widget.footerBuilder,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonBuilder: widget.floatingActionButtonBuilder,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        loadingWidget: widget.loadingWidget,
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => NanoScaffoldBuilder<ViewState>(
        state: controller.state,
        builder: widget.builder,
        header: widget.header,
        headerBuilder: widget.headerBuilder,
        headerHeight: widget.headerHeight,
        drawer: widget.drawer,
        drawerBuilder: widget.drawerBuilder,
        footer: widget.footer,
        footerBuilder: widget.footerBuilder,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonBuilder: widget.floatingActionButtonBuilder,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        loadingWidget: widget.loadingWidget,
      ),
    );
  }
}
