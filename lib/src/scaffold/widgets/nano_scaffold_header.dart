import 'package:flutter/material.dart';
import '../../state/nano_state.dart';
import '../../state/nano_view_state.dart';

/// A [PreferredSizeWidget] managing static or dynamic top navigation
/// bar headers.
class NanoScaffoldHeader<ViewState extends NanoViewState>
    extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a [NanoScaffoldHeader] widget.
  const NanoScaffoldHeader({
    required this.state,
    required this.headerHeight,
    this.header,
    this.headerBuilder,
    super.key,
  });

  /// The current state passed to the dynamic header builder.
  final NanoState<ViewState> state;

  /// Custom height for the header.
  final double headerHeight;

  /// Static header widget.
  final Widget? header;

  /// Dynamic header builder.
  final Widget? Function(BuildContext context, NanoState<ViewState> state)?
  headerBuilder;

  @override
  Widget build(BuildContext context) {
    final customHeader = headerBuilder;
    if (customHeader != null) {
      final built = customHeader(context, state);
      if (built != null) return built;
    }

    return header ?? const SizedBox.shrink();
  }

  @override
  Size get preferredSize {
    final staticHeader = header;
    if (staticHeader is PreferredSizeWidget) {
      return staticHeader.preferredSize;
    }
    return Size.fromHeight(headerHeight);
  }
}
