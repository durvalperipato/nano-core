import 'package:flutter/material.dart';

import 'nano_shimmer_direction.dart';

/// A lightweight, GPU-accelerated wave gradient animation widget.
///
/// Uses Flutter's built-in [ShaderMask] and [AnimationController] to apply
/// a smooth shimmering effect over any child widget without external
/// dependencies. Automatically adapts base and highlight colors based on
/// the current theme brightness.
class NanoShimmer extends StatefulWidget {
  /// Creates a [NanoShimmer] animation widget.
  const NanoShimmer({
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = NanoShimmerDirection.ltr,
    this.enabled = true,
    super.key,
  });

  /// The widget over which the shimmer wave is rendered.
  final Widget child;

  /// The base background color of the shimmer.
  ///
  /// Defaults to a subtle gray adapted to [ThemeData.brightness]
  /// (`#E0E0E0` in Light mode, `#2A2A2A` in Dark mode).
  final Color? baseColor;

  /// The highlight wave color of the shimmer.
  ///
  /// Defaults to a lighter gray adapted to [ThemeData.brightness]
  /// (`#F5F5F5` in Light mode, `#3D3D3D` in Dark mode).
  final Color? highlightColor;

  /// Total duration of a single shimmer wave sweep. Defaults to 1500ms.
  final Duration duration;

  /// Direction of the wave motion. Defaults to [NanoShimmerDirection.ltr].
  final NanoShimmerDirection direction;

  /// Whether the shimmer animation is running.
  ///
  /// When `false`, the child is rendered statically without animation overhead.
  final bool enabled;

  @override
  State<NanoShimmer> createState() => _NanoShimmerState();
}

class _NanoShimmerState extends State<NanoShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(NanoShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (AlignmentGeometry, AlignmentGeometry) _getAlignments(double progress) {
    const span = 2.0;
    final offset = -span + (span * 2 * progress);

    switch (widget.direction) {
      case NanoShimmerDirection.ltr:
        return (
          Alignment(offset - 1.0, 0.0),
          Alignment(offset + 1.0, 0.0),
        );
      case NanoShimmerDirection.rtl:
        return (
          Alignment(-offset + 1.0, 0.0),
          Alignment(-offset - 1.0, 0.0),
        );
      case NanoShimmerDirection.ttb:
        return (
          Alignment(0.0, offset - 1.0),
          Alignment(0.0, offset + 1.0),
        );
      case NanoShimmerDirection.btt:
        return (
          Alignment(0.0, -offset + 1.0),
          Alignment(0.0, -offset - 1.0),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ??
        (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0));
    final highlightColor = widget.highlightColor ??
        (isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final (begin, end) = _getAlignments(_controller.value);
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: begin,
              end: end,
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.1, 0.3, 0.5],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
