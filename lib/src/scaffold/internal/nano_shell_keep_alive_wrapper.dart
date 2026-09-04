import 'package:flutter/material.dart';

/// An internal wrapper widget that preserves the state of child widgets in an
/// [IndexedStack].
class NanoShellKeepAliveWrapper extends StatefulWidget {
  /// Creates a [NanoShellKeepAliveWrapper].
  const NanoShellKeepAliveWrapper({
    required this.maintainState,
    required this.child,
    super.key,
  });

  /// Whether to maintain the state alive when out of view.
  final bool maintainState;

  /// The child widget to keep alive.
  final Widget child;

  @override
  State<NanoShellKeepAliveWrapper> createState() =>
      _NanoShellKeepAliveWrapperState();
}

class _NanoShellKeepAliveWrapperState
    extends State<NanoShellKeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.maintainState;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
