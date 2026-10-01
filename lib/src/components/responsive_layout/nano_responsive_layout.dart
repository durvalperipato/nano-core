import 'package:flutter/widgets.dart';

import 'models/nano_responsive_flex_config.dart';
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
        config = null,
        mobileConfig = null,
        tabletConfig = null,
        desktopConfig = null,
        spacing = null,
        reverseOnMobile = null,
        mainAxisAlignment = null,
        mainAxisSize = null,
        crossAxisAlignment = null,
        textDirection = null,
        verticalDirection = null,
        textBaseline = null;

  /// Creates a responsive flex container that renders [children] as a [Row]
  /// on desktop/tablet viewports and as a [Column] on mobile viewports.
  ///
  /// * [config]: Base flex configuration applied across all viewports.
  /// * [mobileConfig]: Optional flex configuration overrides for mobile.
  /// * [tabletConfig]: Optional flex configuration overrides for tablet.
  /// * [desktopConfig]: Optional flex configuration overrides for desktop.
  const NanoResponsiveLayout.flex({
    required this.children,
    this.config,
    this.mobileConfig,
    this.tabletConfig,
    this.desktopConfig,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
    this.spacing,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated(
      'Use config or mobileConfig with reverse instead. '
      'Will be removed in 1.2.0.',
    )
    this.reverseOnMobile,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
    this.mainAxisAlignment,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
    this.mainAxisSize,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
    this.crossAxisAlignment,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
    this.textDirection,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
    this.verticalDirection,
    // TODO(cleanup): Remove in version 1.2.0
    @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
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

  /// Base flex configuration applied across all viewports.
  final NanoResponsiveFlexConfig? config;

  /// Optional flex configuration overrides for mobile viewports.
  final NanoResponsiveFlexConfig? mobileConfig;

  /// Optional flex configuration overrides for tablet viewports.
  final NanoResponsiveFlexConfig? tabletConfig;

  /// Optional flex configuration overrides for desktop viewports.
  final NanoResponsiveFlexConfig? desktopConfig;

  /// The space between each child widget in logical pixels.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final double? spacing;

  /// Whether to reverse children order when displayed in a mobile column.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated(
    'Use config or mobileConfig with reverse instead. '
    'Will be removed in 1.2.0.',
  )
  final bool? reverseOnMobile;

  /// How children should be placed along the main axis.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final MainAxisAlignment? mainAxisAlignment;

  /// How much space children should occupy in the main axis.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final MainAxisSize? mainAxisSize;

  /// How children should be placed along the cross axis.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final CrossAxisAlignment? crossAxisAlignment;

  /// Determines the order to lay children out horizontally.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final VerticalDirection? verticalDirection;

  /// Baseline for aligning text children along the cross axis.
  // TODO(cleanup): Remove in version 1.2.0
  @Deprecated('Use config parameter instead. Will be removed in 1.2.0.')
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    if (_isFlex) {
      return NanoResponsiveFlexLayout(
        config: config,
        mobileConfig: mobileConfig,
        tabletConfig: tabletConfig,
        desktopConfig: desktopConfig,
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
