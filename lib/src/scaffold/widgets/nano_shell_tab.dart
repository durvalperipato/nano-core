import 'package:flutter/material.dart';

/// Represents a primary persistent tab within a [NanoShellScaffold].
class NanoShellTab<TTab extends Enum> {
  /// Creates a [NanoShellTab] instance.
  const NanoShellTab({
    required this.value,
    required this.builder,
    this.maintainState = true,
  });

  /// The unique enum value identifying this tab.
  final TTab value;

  /// The widget builder for this tab's content.
  final WidgetBuilder builder;

  /// Whether to keep this tab alive in memory when inactive.
  final bool maintainState;
}
