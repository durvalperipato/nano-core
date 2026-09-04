import 'package:flutter/material.dart';
import '../../components/nano_loading_overlay.dart';
import '../../state/nano_state.dart';
import '../../state/nano_view_state.dart';
import 'nano_scaffold_header.dart';

/// The presentation builder widget composing the layout structure for
/// [NanoScaffold].
class NanoScaffoldBuilder<ViewState extends NanoViewState>
    extends StatelessWidget {
  /// Creates a [NanoScaffoldBuilder] widget.
  const NanoScaffoldBuilder({
    required this.state,
    required this.builder,
    this.header,
    this.headerHeight = kToolbarHeight,
    this.drawer,
    this.footer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.loadingWidget,
    this.connectivityWidget,
    super.key,
  });

  /// The current reactive state.
  final NanoState<ViewState> state;

  /// Optional connectivity overlay or banner widget.
  final Widget? connectivityWidget;

  /// Main page builder.
  final Widget Function(BuildContext context, NanoState<ViewState> state)
  builder;

  /// Top navigation bar header builder.
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  header;

  /// Header height.
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

  /// Optional location for the [floatingActionButton].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Background color.
  final Color? backgroundColor;

  /// Soft keyboard resize policy.
  final bool? resizeToAvoidBottomInset;

  /// Custom loading widget overlay.
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final effectiveHeader = header != null
        ? NanoScaffoldHeader<ViewState>(
            state: state,
            headerHeight: headerHeight,
            header: header,
          )
        : null;

    final effectiveDrawer = drawer?.call(context, state);
    final effectiveFooter = footer?.call(context, state);
    final effectiveFab = floatingActionButton?.call(context, state);

    return Scaffold(
      appBar: effectiveHeader,
      drawer: effectiveDrawer,
      bottomNavigationBar: effectiveFooter,
      floatingActionButton: effectiveFab,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          builder(context, state),
          ?connectivityWidget,
          if (state is LoadingState)
            Positioned.fill(
              child: loadingWidget ?? const NanoLoadingOverlay(),
            ),
        ],
      ),
    );
  }
}
