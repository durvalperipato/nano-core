import 'package:flutter/widgets.dart';

import '../../../extensions/nano_context_extensions.dart';
import '../models/nano_responsive_flex_config.dart';

/// Internal adaptive flex widget that renders [children] as a [Row]
/// on desktop/tablet viewports and as a [Column] on mobile viewports.
class NanoResponsiveFlexLayout extends StatelessWidget {
  /// Creates a [NanoResponsiveFlexLayout].
  const NanoResponsiveFlexLayout({
    required this.children,
    this.config,
    this.mobileConfig,
    this.tabletConfig,
    this.desktopConfig,
    this.spacing,
    this.reverseOnMobile,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.textBaseline,
    super.key,
  });

  /// The list of child widgets.
  final List<Widget> children;

  /// Base flex configuration applied across all viewports.
  final NanoResponsiveFlexConfig? config;

  /// Optional flex configuration overrides for mobile viewports.
  final NanoResponsiveFlexConfig? mobileConfig;

  /// Optional flex configuration overrides for tablet viewports.
  final NanoResponsiveFlexConfig? tabletConfig;

  /// Optional flex configuration overrides for desktop viewports.
  final NanoResponsiveFlexConfig? desktopConfig;

  /// Legacy space between each child widget in logical pixels.
  final double? spacing;

  /// Legacy flag to reverse children order when displayed in a mobile column.
  final bool? reverseOnMobile;

  /// Legacy main axis alignment.
  final MainAxisAlignment? mainAxisAlignment;

  /// Legacy main axis size.
  final MainAxisSize? mainAxisSize;

  /// Legacy cross axis alignment.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Legacy text direction.
  final TextDirection? textDirection;

  /// Legacy vertical direction.
  final VerticalDirection? verticalDirection;

  /// Legacy text baseline.
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    final isMobile = screen.isMobile;
    final isTablet = screen.isTablet;

    final legacyConfig = (spacing != null ||
            mainAxisAlignment != null ||
            mainAxisSize != null ||
            crossAxisAlignment != null ||
            textDirection != null ||
            verticalDirection != null ||
            textBaseline != null)
        ? NanoResponsiveFlexConfig(
            spacing: spacing,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
          )
        : null;

    final legacyMobileConfig = reverseOnMobile != null
        ? NanoResponsiveFlexConfig(reverse: reverseOnMobile)
        : null;

    final baseConfig = NanoResponsiveFlexConfig.fallback
        .merge(legacyConfig)
        .merge(config);

    final effectiveConfig = isMobile
        ? baseConfig.merge(legacyMobileConfig).merge(mobileConfig)
        : isTablet
            ? baseConfig.merge(tabletConfig)
            : baseConfig.merge(desktopConfig);

    final shouldReverse = effectiveConfig.reverse ?? false;
    final effectiveChildren = shouldReverse
        ? children.reversed.toList(growable: false)
        : children;

    final effectiveSpacing = effectiveConfig.spacing ?? 0.0;
    final spacedChildren = <Widget>[];
    if (effectiveSpacing <= 0 || effectiveChildren.isEmpty) {
      spacedChildren.addAll(effectiveChildren);
    } else {
      for (var i = 0; i < effectiveChildren.length; i++) {
        spacedChildren.add(effectiveChildren[i]);
        if (i < effectiveChildren.length - 1) {
          spacedChildren.add(
            isMobile
                ? SizedBox(height: effectiveSpacing)
                : SizedBox(width: effectiveSpacing),
          );
        }
      }
    }

    if (isMobile) {
      return Column(
        mainAxisAlignment: effectiveConfig.mainAxisAlignment ??
            MainAxisAlignment.start,
        mainAxisSize: effectiveConfig.mainAxisSize ?? MainAxisSize.max,
        crossAxisAlignment: effectiveConfig.crossAxisAlignment ??
            CrossAxisAlignment.center,
        textDirection: effectiveConfig.textDirection,
        verticalDirection: effectiveConfig.verticalDirection ??
            VerticalDirection.down,
        textBaseline: effectiveConfig.textBaseline,
        children: spacedChildren,
      );
    }

    return Row(
      mainAxisAlignment: effectiveConfig.mainAxisAlignment ??
          MainAxisAlignment.start,
      mainAxisSize: effectiveConfig.mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: effectiveConfig.crossAxisAlignment ??
          CrossAxisAlignment.center,
      textDirection: effectiveConfig.textDirection,
      verticalDirection: effectiveConfig.verticalDirection ??
          VerticalDirection.down,
      textBaseline: effectiveConfig.textBaseline,
      children: spacedChildren,
    );
  }
}
