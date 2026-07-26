import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/nano_device_type.dart';

/// Enum representing the visual type of a [NanoToast].
enum NanoToastType {
  /// Success toast (Green).
  success,

  /// Error toast (Red).
  error,

  /// Warning toast (Amber/Orange).
  warning,
}

/// Smart multiplatform Toast notification component for Web, Desktop, and Mobile.
///
/// On Web and Desktop, renders a floating card at the top-right corner of the window.
/// On Mobile, renders a floating [SnackBar] with rounded corners.
class NanoToast {
  /// Private constructor to prevent direct instantiation of [NanoToast].
  const NanoToast._();

  /// Shows a success toast notification with a green accent.
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: NanoToastType.success,
      duration: duration,
    );
  }

  /// Shows an error toast notification with a red accent.
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: NanoToastType.error,
      duration: duration,
    );
  }

  /// Shows a warning toast notification with an amber accent.
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: NanoToastType.warning,
      duration: duration,
    );
  }

  /// Displays a toast notification appropriate for the current platform and context.
  static void show(
    BuildContext context, {
    required String message,
    required NanoToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (NanoDeviceType.isMobile(context)) {
      _showMobileSnackBar(context, message: message, type: type, duration: duration);
    } else {
      _showWebOverlayToast(context, message: message, type: type, duration: duration);
    }
  }

  static void _showMobileSnackBar(
    BuildContext context, {
    required String message,
    required NanoToastType type,
    required Duration duration,
  }) {
    final colorScheme = _getToastColorScheme(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(colorScheme.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      ),
    );
  }

  static void _showWebOverlayToast(
    BuildContext context, {
    required String message,
    required NanoToastType type,
    required Duration duration,
  }) {
    final overlayState = Overlay.of(context);
    final colorScheme = _getToastColorScheme(type);

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 24,
          right: 24,
          child: _WebToastCard(
            message: message,
            colorScheme: colorScheme,
            onDismiss: () {
              entry.remove();
            },
          ),
        );
      },
    );

    overlayState.insert(entry);

    Timer(duration, () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  static _ToastColorScheme _getToastColorScheme(NanoToastType type) {
    switch (type) {
      case NanoToastType.success:
        return const _ToastColorScheme(
          backgroundColor: Color(0xFF10B981),
          icon: Icons.check_circle_outline,
        );
      case NanoToastType.error:
        return const _ToastColorScheme(
          backgroundColor: Color(0xFFEF4444),
          icon: Icons.error_outline,
        );
      case NanoToastType.warning:
        return const _ToastColorScheme(
          backgroundColor: Color(0xFFF59E0B),
          icon: Icons.warning_amber_rounded,
        );
    }
  }
}

class _ToastColorScheme {
  final Color backgroundColor;
  final IconData icon;

  const _ToastColorScheme({
    required this.backgroundColor,
    required this.icon,
  });
}

class _WebToastCard extends StatelessWidget {
  const _WebToastCard({
    required this.message,
    required this.colorScheme,
    required this.onDismiss,
  });

  final String message;
  final _ToastColorScheme colorScheme;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.backgroundColor.withAlpha(120), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.backgroundColor.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(colorScheme.icon, color: colorScheme.backgroundColor, size: 20),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 18),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
