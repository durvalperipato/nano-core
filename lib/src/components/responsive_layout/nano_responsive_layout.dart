import 'package:flutter/widgets.dart';

import 'widgets/nano_responsive_builder_layout.dart';
import 'widgets/nano_responsive_flex_layout.dart';

/// A canonical responsive layout widget for the Nano ecosystem.
///
/// Supports structural adaptive builders (via standard constructor) and
/// dynamic axis switching (via [NanoResponsiveLayout.flex]).
class NanoResponsiveLayout extends StatelessWidget {
  /// Creates a responsive layout that conditionally builds different widget
  /// trees based on the screen breakpoint.
  ///
  /// * [mobile]: Builder evaluated when screen width is < 600dp.
  /// * [desktop]: Builder evaluated when screen width is >= 1024dp,
  ///   or as fallback.
  /// * [tablet]: Optional builder evaluated when screen width is >= 600dp
  ///   and < 1024dp. If omitted, falls back to [desktop].
  const NanoResponsiveLayout({
    required this.mobile,
    required this.desktop,
    this.tablet,
    super.key,
  })  : _isFlex = false,
        children = const [],
        spacing = 0.0,
        reverseOnMobile = false,
        mainAxisAlignment = MainAxisAlignment.start,
        mainAxisSize = MainAxisSize.max,
        crossAxisAlignment = CrossAxisAlignment.center,
        textDirection = null,
        verticalDirection = VerticalDirection.down,
        textBaseline = null;

  /// Creates a responsive flex container that renders [children] as a [Row]
  /// on desktop/tablet viewports and as a [Column] on mobile viewports.
  ///
  /// * [spacing]: Spacing inserted between children (horizontal on desktop/tablet,
  ///   vertical on mobile).
  /// * [reverseOnMobile]: Whether to reverse the order of [children] on mobile.
  const NanoResponsiveLayout.flex({
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
  })  : _isFlex = true,
        mobile = null,
        desktop = null,
        tablet = null;

  /// Builder for mobile viewports (< 600dp).
  final NanoResponsiveWidgetBuilder? mobile;

  /// Builder for desktop viewports (>= 1024dp).
  final NanoResponsiveWidgetBuilder? desktop;

  /// Optional builder for tablet viewports (>= 600dp and < 1024dp).
  final NanoResponsiveWidgetBuilder? tablet;

  final bool _isFlex;

  /// The list of child widgets for [NanoResponsiveLayout.flex].
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

  @override
  Widget build(BuildContext context) {
    if (_isFlex) {
      return NanoResponsiveFlexLayout(
        spacing: spacing,
        reverseOnMobile: reverseOnMobile,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: children,
      );
    }

    return NanoResponsiveBuilderLayout(
      mobile: mobile!,
      desktop: desktop!,
      tablet: tablet,
    );
  }
}
