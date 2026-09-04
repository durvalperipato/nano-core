import 'package:flutter/material.dart';

/// Represents a secondary contextual sub-view within a [NanoShellScaffold]
/// that shares the same persistent shell (e.g. Notifications, Search overlay).
class NanoShellSubView<TSubView> {
  /// Creates a [NanoShellSubView] instance.
  const NanoShellSubView({
    required this.id,
    required this.builder,
  });

  /// The unique identifier for this sub-view.
  final TSubView id;

  /// The widget builder for this sub-view.
  final WidgetBuilder builder;
}
