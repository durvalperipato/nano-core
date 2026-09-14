import 'package:flutter/material.dart';

import 'nano_shimmer.dart';

/// Design system skeleton placeholder widget.
///
/// Provides factory constructors for pre-assembled layouts
/// ([NanoSkeleton.grid], [NanoSkeleton.list], [NanoSkeleton.card]), geometric
/// building blocks ([NanoSkeleton.box], [NanoSkeleton.circle],
/// [NanoSkeleton.text]), and GPU-accelerated ghost masking
/// ([NanoSkeleton.mask]).
class NanoSkeleton extends StatelessWidget {
  /// Internal constructor delegating to specific builders.
  const NanoSkeleton._({
    required Widget child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
    super.key,
  }) : _child = child;

  /// Creates a single rectangular skeleton box.
  factory NanoSkeleton.box({
    Key? key,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? color,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool enabled = true,
  }) {
    return NanoSkeleton._(
      key: key,
      baseColor: color,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _SkeletonBox(
        width: width,
        height: height,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        color: color,
      ),
    );
  }

  /// Creates a circular skeleton avatar placeholder.
  factory NanoSkeleton.circle({
    Key? key,
    double size = 48.0,
    Color? color,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool enabled = true,
  }) {
    return NanoSkeleton._(
      key: key,
      baseColor: color,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _SkeletonCircle(
        size: size,
        color: color,
      ),
    );
  }

  /// Creates a simulated paragraph of skeleton text lines.
  factory NanoSkeleton.text({
    Key? key,
    double? width,
    double height = 14.0,
    int lines = 1,
    double lineSpacing = 8.0,
    BorderRadius? borderRadius,
    Color? color,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool enabled = true,
  }) {
    return NanoSkeleton._(
      key: key,
      baseColor: color,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _SkeletonText(
        width: width,
        height: height,
        lines: lines,
        lineSpacing: lineSpacing,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        color: color,
      ),
    );
  }

  /// Creates a pre-assembled card skeleton placeholder.
  factory NanoSkeleton.card({
    Key? key,
    double? width,
    double height = 140.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    BorderRadius? borderRadius,
    Color? color,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool enabled = true,
  }) {
    return NanoSkeleton._(
      key: key,
      baseColor: color,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _SkeletonCard(
        width: width,
        height: height,
        padding: padding,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: color,
      ),
    );
  }

  /// Creates a pre-assembled list of skeleton rows with avatar and text
  /// placeholders.
  factory NanoSkeleton.list({
    Key? key,
    int items = 6,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    double spacing = 16.0,
    Color? color,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool enabled = true,
  }) {
    return NanoSkeleton._(
      key: key,
      baseColor: color,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _SkeletonList(
        items: items,
        padding: padding,
        spacing: spacing,
        color: color,
      ),
    );
  }

  /// Creates a pre-assembled grid of skeleton cards with configurable columns
  /// and rows.
  factory NanoSkeleton.grid({
    Key? key,
    int columns = 2,
    int rows = 3,
    double itemHeight = 120.0,
    double spacing = 12.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    BorderRadius? borderRadius,
    Color? color,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool enabled = true,
  }) {
    return NanoSkeleton._(
      key: key,
      baseColor: color,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _SkeletonGrid(
        columns: columns,
        rows: rows,
        itemHeight: itemHeight,
        spacing: spacing,
        padding: padding,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: color,
      ),
    );
  }

  /// Ghost masking: automatically masks children widgets (texts, icons, images)
  /// with a shimmering redacted overlay when [loading] is `true`.
  ///
  /// When [loading] is `false`, renders [child] directly without animation
  /// overhead.
  factory NanoSkeleton.mask({
    required bool loading,
    required Widget child,
    Key? key,
    Color? maskColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    if (!loading) {
      return NanoSkeleton._(
        key: key,
        enabled: false,
        child: child,
      );
    }

    return NanoSkeleton._(
      key: key,
      baseColor: maskColor,
      highlightColor: highlightColor,
      duration: duration,
      child: _SkeletonMask(
        maskColor: maskColor,
        child: child,
      ),
    );
  }

  final Widget _child;

  /// Base shimmer color.
  final Color? baseColor;

  /// Shimmer highlight wave color.
  final Color? highlightColor;

  /// Shimmer wave animation cycle duration.
  final Duration duration;

  /// Whether the shimmer animation is active.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return NanoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      enabled: enabled,
      child: _child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width,
    this.height,
    this.borderRadius,
    this.color,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? defaultColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  const _SkeletonCircle({
    this.size = 48.0,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? defaultColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SkeletonText extends StatelessWidget {
  const _SkeletonText({
    this.width,
    this.height = 14.0,
    this.lines = 1,
    this.lineSpacing = 8.0,
    this.borderRadius,
    this.color,
  });

  final double? width;
  final double height;
  final int lines;
  final double lineSpacing;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (lines <= 1) {
      return _SkeletonBox(
        width: width,
        height: height,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        color: color,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        final effectiveWidth = isLastLine && width != null
            ? width! * 0.65
            : isLastLine
                ? 120.0
                : width;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastLine ? 0.0 : lineSpacing),
          child: _SkeletonBox(
            width: effectiveWidth,
            height: height,
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            color: color,
          ),
        );
      }),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.color,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBorderColor =
        isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);

    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: defaultBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonCircle(size: 40, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                      width: 140,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                      color: color,
                    ),
                    const SizedBox(height: 6),
                    _SkeletonBox(
                      width: 80,
                      height: 10,
                      borderRadius: BorderRadius.circular(4),
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          _SkeletonBox(
            width: double.infinity,
            height: 12,
            borderRadius: BorderRadius.circular(4),
            color: color,
          ),
          const SizedBox(height: 6),
          _SkeletonBox(
            width: 200,
            height: 12,
            borderRadius: BorderRadius.circular(4),
            color: color,
          ),
        ],
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList({
    required this.items,
    required this.padding,
    required this.spacing,
    this.color,
  });

  final int items;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: padding,
      itemCount: items,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) => Row(
        children: [
          _SkeletonCircle(size: 40, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                ),
                const SizedBox(height: 8),
                _SkeletonBox(
                  width: 160,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid({
    required this.columns,
    required this.rows,
    required this.itemHeight,
    required this.spacing,
    required this.padding,
    required this.borderRadius,
    this.color,
  });

  final int columns;
  final int rows;
  final double itemHeight;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (rowIndex) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: rowIndex == rows - 1 ? 0.0 : spacing,
            ),
            child: Row(
              children: List.generate(columns, (colIndex) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: colIndex == columns - 1 ? 0.0 : spacing,
                    ),
                    child: _SkeletonBox(
                      height: itemHeight,
                      borderRadius: borderRadius,
                      color: color,
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _SkeletonMask extends StatelessWidget {
  const _SkeletonMask({
    required this.child,
    this.maskColor,
  });

  final Widget child;
  final Color? maskColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor =
        isDark ? const Color(0xFF424242) : const Color(0xFFBDBDBD);

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        maskColor ?? defaultColor,
        BlendMode.srcATop,
      ),
      child: child,
    );
  }
}
