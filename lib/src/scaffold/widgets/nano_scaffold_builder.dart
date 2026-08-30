import 'package:flutter/material.dart';
import '../../components/nano_loading_overlay.dart';
import '../../state/nano_message_key.dart';
import '../../state/nano_state.dart';
import '../../state/nano_view_state.dart';
import 'nano_scaffold_header.dart';

/// The presentation builder widget composing the layout structure for
/// [NanoScaffold].
class NanoScaffoldBuilder<T extends NanoViewState, M extends NanoMessageKey>
    extends StatelessWidget {
  /// Creates a [NanoScaffoldBuilder] widget.
  const NanoScaffoldBuilder({
    required this.state,
    required this.builder,
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
    super.key,
  });

  /// The current reactive state.
  final NanoState<T> state;

  /// Main page builder.
  final Widget Function(BuildContext context, NanoState<T> state) builder;

  /// Static header.
  final Widget? header;

  /// Dynamic header builder.
  final Widget? Function(BuildContext context, NanoState<T> state)?
  headerBuilder;

  /// Header height.
  final double headerHeight;

  /// Static drawer.
  final Widget? drawer;

  /// Dynamic drawer builder.
  final Widget? Function(BuildContext context, NanoState<T> state)?
  drawerBuilder;

  /// Static footer.
  final Widget? footer;

  /// Dynamic footer builder.
  final Widget? Function(BuildContext context, NanoState<T> state)?
  footerBuilder;

  /// Static floating action button.
  final Widget? floatingActionButton;

  /// Dynamic floating action button builder.
  final Widget? Function(BuildContext context, NanoState<T> state)?
  floatingActionButtonBuilder;

  /// Background color.
  final Color? backgroundColor;

  /// Soft keyboard resize policy.
  final bool? resizeToAvoidBottomInset;

  /// Custom loading widget overlay.
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final effectiveHeader = (header != null || headerBuilder != null)
        ? NanoScaffoldHeader<T>(
            state: state,
            headerHeight: headerHeight,
            header: header,
            headerBuilder: headerBuilder,
          )
        : null;

    final customDrawer = drawerBuilder;
    final effectiveDrawer = customDrawer != null
        ? customDrawer(context, state)
        : drawer;

    final customFooter = footerBuilder;
    final effectiveFooter = customFooter != null
        ? customFooter(context, state)
        : footer;

    final customFab = floatingActionButtonBuilder;
    final effectiveFab = customFab != null
        ? customFab(context, state)
        : floatingActionButton;

    return Scaffold(
      appBar: effectiveHeader,
      drawer: effectiveDrawer,
      bottomNavigationBar: effectiveFooter,
      floatingActionButton: effectiveFab,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          builder(context, state),
          if (state is LoadingState)
            loadingWidget ?? const NanoLoadingOverlay(),
        ],
      ),
    );
  }
}
