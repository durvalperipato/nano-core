import 'package:flutter/material.dart';
import '../components/nano_loading_overlay.dart';
import '../controller/nano_controller.dart';

/// [NanoScaffold] is the reactive base page layout structure in nano-core.
/// 
/// Supports:
/// - [header]: Generic top bar (Web/Desktop Navbar or Mobile AppBar).
/// - [headerHeight]: Custom height for [header] when it is not a [PreferredSizeWidget].
/// - Automatic state observation via [NanoController] to display loading overlays
///   and handle failure/error notifications.
class NanoScaffold extends StatefulWidget {
  const NanoScaffold({
    super.key,
    this.controller,
    this.header,
    this.headerHeight = kToolbarHeight,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.onFailure,
    required this.builder,
  });

  /// Optional reactive controller managing page state.
  final NanoController? controller;

  /// Top navigation bar or header (Web Navbar, Mobile AppBar, or any Widget).
  final Widget? header;

  /// Custom height for [header] when not a [PreferredSizeWidget]. Defaults to [kToolbarHeight].
  final double headerHeight;

  /// Side navigation drawer.
  final Widget? drawer;

  /// Bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Page background color.
  final Color? backgroundColor;

  /// Whether to resize contents when soft keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Optional custom error callback for controller failures.
  final void Function(String error)? onFailure;

  /// Main page content builder.
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  State<NanoScaffold> createState() => _NanoScaffoldState();
}

class _NanoScaffoldState extends State<NanoScaffold> {
  @override
  void initState() {
    super.initState();
    _subscribeController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant NanoScaffold oldWidget) {
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

  void _subscribeController(NanoController? controller) {
    controller?.addListener(_onStateChanged);
  }

  void _unsubscribeController(NanoController? controller) {
    controller?.removeListener(_onStateChanged);
  }

  void _onStateChanged() {
    final controller = widget.controller;
    if (controller == null) return;

    final state = controller.state;
    if (state.isFailure) {
      final errorMessage = state.error ?? 'An unexpected error occurred.';
      if (widget.onFailure != null) {
        widget.onFailure!(errorMessage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  PreferredSizeWidget? _buildEffectiveHeader() {
    final header = widget.header;
    if (header == null) return null;

    if (header is PreferredSizeWidget) {
      return header;
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(widget.headerHeight),
      child: header,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: _buildEffectiveHeader(),
      drawer: widget.drawer,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: controller == null
          ? widget.builder(context, null)
          : ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    widget.builder(context, child),
                    if (controller.state.isLoading)
                      const NanoLoadingOverlay(),
                  ],
                );
              },
            ),
    );
  }
}
