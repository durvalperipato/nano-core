import 'package:flutter/widgets.dart';

import '../../../extensions/nano_context_extensions.dart';

/// Signature for a responsive widget builder function.
typedef NanoResponsiveWidgetBuilder = Widget Function(BuildContext context);

/// Internal adaptive widget that selects between [mobile], [desktop],
/// and optional [tablet] widget builders based on the active screen viewport.
class NanoResponsiveBuilderLayout extends StatelessWidget {
  /// Creates a [NanoResponsiveBuilderLayout].
  const NanoResponsiveBuilderLayout({
    required this.mobile,
    required this.desktop,
    this.tablet,
    super.key,
  });

  /// Builder for mobile viewports (< 600dp).
  final NanoResponsiveWidgetBuilder mobile;

  /// Builder for desktop viewports (>= 1024dp).
  final NanoResponsiveWidgetBuilder desktop;

  /// Optional builder for tablet viewports (>= 600dp and < 1024dp).
  /// Falls back to [desktop] when omitted.
  final NanoResponsiveWidgetBuilder? tablet;

  @override
  Widget build(BuildContext context) {
    if (context.screen.isMobile) {
      return mobile(context);
    }
    if (context.screen.isTablet) {
      final tabletBuilder = tablet ?? desktop;
      return tabletBuilder(context);
    }
    return desktop(context);
  }
}
