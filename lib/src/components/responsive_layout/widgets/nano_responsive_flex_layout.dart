import 'package:flutter/widgets.dart';

import '../../../extensions/nano_context_extensions.dart';

/// Internal adaptive flex widget that renders [children] as a [Row]
/// on desktop/tablet viewports and as a [Column] on mobile viewports.
class NanoResponsiveFlexLayout extends StatelessWidget {
  /// Creates a [NanoResponsiveFlexLayout].
  const NanoResponsiveFlexLayout({
    required this.children,
    this.spacing = 0.0,
    this.reverseOnMobile = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    super.key,
  });

  /// The list of child widgets.
  final List<Widget> children;

  /// The space between each child widget in logical pixels.
  final double spacing;

  /// Whether to reverse children order when displayed in a mobile column.
  final bool reverseOnMobile;

  /// How children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space children should occupy in the main axis.
  final MainAxisSize mainAxisSize;

  /// How children should be placed along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Determines the order to lay children out horizontally.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically.
  final VerticalDirection verticalDirection;

  /// Baseline for aligning text children along the cross axis.
  final TextBaseline? textBaseline;

  List<Widget> _computeSpacedChildren(bool isMobile) {
    final effectiveChildren = isMobile && reverseOnMobile
        ? children.reversed.toList(growable: false)
        : children;

    if (spacing <= 0 || effectiveChildren.isEmpty) {
      return effectiveChildren;
    }

    final spaced = <Widget>[];
    for (var i = 0; i < effectiveChildren.length; i++) {
      spaced.add(effectiveChildren[i]);
      if (i < effectiveChildren.length - 1) {
        spaced.add(
          isMobile
              ? SizedBox(height: spacing)
              : SizedBox(width: spacing),
        );
      }
    }
    return spaced;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screen.isMobile;
    final spacedChildren = _computeSpacedChildren(isMobile);

    if (isMobile) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: spacedChildren,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: spacedChildren,
    );
  }
}
