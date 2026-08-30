import 'package:flutter/material.dart';

/// Full-screen or container loading overlay widget for page-level
/// state loading or custom views.
class NanoLoadingOverlay extends StatelessWidget {
  /// Creates a [NanoLoadingOverlay] widget.
  const NanoLoadingOverlay({
    this.backgroundColor = Colors.black26,
    this.indicatorColor,
    this.child,
    super.key,
  });

  /// Background overlay color. Defaults to semi-transparent black.
  final Color backgroundColor;

  /// Custom color for the default progress indicator.
  final Color? indicatorColor;

  /// Optional custom widget to display inside the loading overlay instead of
  /// the default [CircularProgressIndicator].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: backgroundColor,
        child: Center(
          child:
              child ?? CircularProgressIndicator(color: indicatorColor),
        ),
      ),
    );
  }
}
