import 'package:flutter/material.dart';
import '../../state/nano_state.dart';
import '../../state/nano_view_state.dart';

/// A [PreferredSizeWidget] managing top navigation bar headers in
/// [NanoScaffold].
class NanoScaffoldHeader<ViewState extends NanoViewState>
    extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a [NanoScaffoldHeader] widget.
  const NanoScaffoldHeader({
    required this.state,
    required this.headerHeight,
    this.header,
    super.key,
  });

  /// The current state passed to the header builder.
  final NanoState<ViewState> state;

  /// Custom height for the header.
  final double headerHeight;

  /// Header builder receiving context and state.
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  header;

  @override
  Widget build(BuildContext context) =>
      header?.call(context, state) ?? const SizedBox.shrink();

  @override
  Size get preferredSize => Size.fromHeight(headerHeight);
}
