import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../components/nano_loading_overlay.dart';
import '../components/nano_toast.dart';
import '../connectivity/nano_connectivity.dart';
import '../connectivity/nano_connectivity_status.dart';
import '../controller/nano_controller.dart';
import '../state/nano_message_key.dart';
import '../state/nano_state.dart';
import '../state/nano_state_observable.dart';
import '../state/nano_view_state.dart';
import 'widgets/nano_scaffold_builder.dart';

/// [NanoScaffold] is the reactive base page layout structure in nano-core.
///
/// Generic over [ViewState], where [ViewState] represents the page's
/// [NanoViewState], and [MessageKey], where [MessageKey] represents the
/// strongly typed [NanoMessageKey].
///
/// Supports:
/// - [header]: Top navigation bar builder receiving context and [NanoState].
/// - [headerHeight]: Custom height for [header]. Defaults to [kToolbarHeight].
/// - [drawer]: Side drawer builder receiving context and [NanoState].
/// - [footer]: Bottom navigation bar or footer builder.
/// - [floatingActionButton]: Floating action button builder.
/// - Automatic state observation via [NanoStateObservable] (such as
///   [NanoController], BLoC, Cubit, or MobX adapters) to display loading
///   overlays, custom error/warning/success toasts via [NanoToast], or
///   custom callbacks.
/// - Passes the current [NanoState] directly to [builder], [header],
///   [footer], [drawer], and [floatingActionButton].
/// - Strongly-typed message callbacks [onCustomError] and [onCustomWarning]
///   using [MessageKey].
/// - Customizable [loadingWidget] overlay when the state is [LoadingState].
/// - Reactive [connectivity] observation with [connectivityBuilder] and
///   [onConnectivityChanged] hook.
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
    this.headerHeight = kToolbarHeight,
    this.drawer,
    this.footer,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.loadingWidget,
    this.connectivity,
    this.connectivityBuilder,
    this.onConnectivityChanged,
    this.onCustomError,
    this.onCustomWarning,
    this.onCustomSuccess,
    super.key,
  });

  /// Optional reactive state observable (such as [NanoController] or custom
  /// BLoC / MobX adapter) managing page state.
  final NanoStateObservable<ViewState>? controller;

  /// Optional connectivity observable. If null, attempts to resolve from
  /// [GetIt] if registered.
  final NanoConnectivity? connectivity;

  /// Optional custom connectivity widget builder receiving the active
  /// [NanoConnectivityStatus]. Return a widget to render an overlay/banner
  /// or null to render nothing.
  final Widget? Function(BuildContext context, NanoConnectivityStatus status)?
  connectivityBuilder;

  /// Optional callback triggered when network connectivity status changes.
  final void Function(NanoConnectivityStatus status)? onConnectivityChanged;

  /// Top navigation bar or header builder (Web Navbar, Mobile AppBar).
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  header;

  /// Custom height for [header]. Defaults to [kToolbarHeight].
  final double headerHeight;

  /// Side navigation drawer builder.
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  drawer;

  /// Bottom navigation bar or footer builder.
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  footer;

  /// Floating action button builder.
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  floatingActionButton;

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
  NanoConnectivity? _connectivity;

  @override
  void initState() {
    super.initState();
    _subscribeController(widget.controller);
    _resolveAndSubscribeConnectivity();
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
    if (oldWidget.connectivity != widget.connectivity) {
      _unsubscribeConnectivity(_connectivity);
      _resolveAndSubscribeConnectivity();
    }
  }

  @override
  void dispose() {
    _unsubscribeController(widget.controller);
    _unsubscribeConnectivity(_connectivity);
    super.dispose();
  }

  void _resolveAndSubscribeConnectivity() {
    _connectivity =
        widget.connectivity ??
        (GetIt.I.isRegistered<NanoConnectivity>()
            ? GetIt.I<NanoConnectivity>()
            : null);
    _connectivity?.addListener(_onConnectivityChanged);
  }

  void _unsubscribeConnectivity(NanoConnectivity? connectivity) =>
      connectivity?.removeListener(_onConnectivityChanged);

  void _onConnectivityChanged() {
    final connectivity = _connectivity;
    if (connectivity == null) return;
    widget.onConnectivityChanged?.call(connectivity.status);
    setState(() {});
  }

  void _subscribeController(NanoStateObservable<ViewState>? controller) =>
      controller?.addListener(_onStateChanged);

  void _unsubscribeController(NanoStateObservable<ViewState>? controller) =>
      controller?.removeListener(_onStateChanged);

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

  Widget? _buildConnectivityWidget() {
    final connectivity = _connectivity;
    final builder = widget.connectivityBuilder;
    if (connectivity != null && builder != null) {
      return builder(context, connectivity.status);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final connectivityWidget = _buildConnectivityWidget();

    if (controller == null) {
      return NanoScaffoldBuilder<ViewState>(
        state: InitialState<ViewState>(),
        builder: widget.builder,
        header: widget.header,
        headerHeight: widget.headerHeight,
        drawer: widget.drawer,
        footer: widget.footer,
        floatingActionButton: widget.floatingActionButton,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        loadingWidget: widget.loadingWidget,
        connectivityWidget: connectivityWidget,
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => NanoScaffoldBuilder<ViewState>(
        state: controller.state,
        builder: widget.builder,
        header: widget.header,
        headerHeight: widget.headerHeight,
        drawer: widget.drawer,
        footer: widget.footer,
        floatingActionButton: widget.floatingActionButton,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        loadingWidget: widget.loadingWidget,
        connectivityWidget: connectivityWidget,
      ),
    );
  }
}
