import 'package:flutter/widgets.dart';

import '../theme/nano_theme_context.dart';
import '../utils/nano_screen_context.dart';

/// Ergonomic contextual extensions on [BuildContext] providing isolated
/// namespaces for screen responsiveness and visual theming.
extension NanoContextExtensions on BuildContext {
  /// Contextual helper for viewport dimensions, device categories, and
  /// responsive values.
  NanoScreenContext get screen => NanoScreenContext(this);

  /// Contextual helper for theme data, color schemes, text themes, and
  /// brightness checks.
  NanoThemeContext get theme => NanoThemeContext(this);
}
