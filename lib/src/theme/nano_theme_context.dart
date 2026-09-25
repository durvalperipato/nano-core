import 'package:flutter/material.dart';

/// Contextual helper that exposes theme data, color scheme, text styles,
/// and theme brightness checks bound to a [BuildContext].
class NanoThemeContext {
  /// Creates a [NanoThemeContext] bound to the provided [_context].
  const NanoThemeContext(this._context);

  final BuildContext _context;

  /// Returns the current [ThemeData] from the widget tree.
  ThemeData get data => Theme.of(_context);

  /// High-frequency shortcut for the active [ColorScheme].
  ColorScheme get colors => Theme.of(_context).colorScheme;

  /// High-frequency shortcut for the active [TextTheme].
  TextTheme get text => Theme.of(_context).textTheme;

  /// Whether the active theme brightness is dark.
  bool get isDark => Theme.of(_context).brightness == Brightness.dark;

  /// Whether the active theme brightness is light.
  bool get isLight => !isDark;
}
