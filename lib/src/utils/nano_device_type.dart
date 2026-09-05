import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Enum representing the target platform or device category.
enum NanoDeviceType {
  /// Mobile devices (smartphones, small screens < 600dp width or
  /// native mobile).
  mobile,

  /// Tablet devices (screen width >= 600dp and < 1024dp).
  tablet,

  /// Desktop devices (macOS, Windows, Linux, or large displays
  /// >= 1024dp width).
  desktop,

  /// Web browser environment.
  web;

  /// Whether the app is running on Flutter Web.
  static bool get isWeb => kIsWeb;

  /// Whether the current context represents a mobile layout.
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Whether the current context represents a tablet layout.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  /// Whether the current context represents a desktop layout.
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  /// Evaluates and returns the active [NanoDeviceType] for the given [context].
  static NanoDeviceType fromContext(BuildContext context) {
    if (isDesktop(context)) return NanoDeviceType.desktop;
    if (isTablet(context)) return NanoDeviceType.tablet;
    return NanoDeviceType.mobile;
  }
}
