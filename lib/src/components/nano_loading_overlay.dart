import 'package:flutter/material.dart';

/// Full-screen or container loading overlay widget for page-level state loading or custom views.
class NanoLoadingOverlay extends StatelessWidget {
  const NanoLoadingOverlay({
    super.key,
    this.backgroundColor = Colors.black26,
    this.indicatorColor,
  });

  /// Background overlay color. Defaults to semi-transparent black.
  final Color backgroundColor;

  /// Custom color for the progress indicator.
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: backgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            color: indicatorColor,
          ),
        ),
      ),
    );
  }
}
