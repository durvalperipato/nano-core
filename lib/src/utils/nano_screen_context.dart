import 'package:flutter/widgets.dart';

import 'nano_device_type.dart';

/// Contextual helper that exposes viewport dimensions, device categories,
/// and responsive value evaluation methods bound to a [BuildContext].
class NanoScreenContext {
  /// Creates a [NanoScreenContext] bound to the provided [_context].
  const NanoScreenContext(this._context);

  final BuildContext _context;

  /// Whether the current screen width represents a mobile layout (< 600dp).
  bool get isMobile => NanoDeviceType.isMobile(_context);

  /// Whether the current screen width represents a tablet layout
  /// (>= 600dp and < 1024dp).
  bool get isTablet => NanoDeviceType.isTablet(_context);

  /// Whether the current screen width represents a desktop layout (>= 1024dp).
  bool get isDesktop => NanoDeviceType.isDesktop(_context);

  /// Returns the current screen width in logical pixels.
  double get width => MediaQuery.sizeOf(_context).width;

  /// Returns the current screen height in logical pixels.
  double get height => MediaQuery.sizeOf(_context).height;

  /// Returns the current screen [Size].
  Size get size => MediaQuery.sizeOf(_context);

  /// Returns the current evaluated [NanoDeviceType].
  NanoDeviceType get deviceType => NanoDeviceType.fromContext(_context);

  /// Returns a value based on the current screen category.
  ///
  /// * [mobile]: Value used when [isMobile] is true.
  /// * [desktop]: Value used when [isDesktop] is true, or as default fallback.
  /// * [tablet]: Optional value used when [isTablet] is true. If omitted,
  ///   defaults to [desktop].
  T responsive<T>({
    required T mobile,
    required T desktop,
    T? tablet,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? desktop;
    return desktop;
  }
}
