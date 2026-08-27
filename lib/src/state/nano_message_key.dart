import 'package:flutter/material.dart';

/// Represents a message (error, warning, success) passed in states.
/// Can be implemented by enums for localized keys or classes.
abstract interface class NanoMessageKey {
  /// The human-readable text or key for internationalization.
  String Function(BuildContext) get message;
}
