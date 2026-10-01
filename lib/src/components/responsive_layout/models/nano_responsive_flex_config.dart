import 'package:flutter/widgets.dart';

import '../../../equatable/nano_equatable.dart';

/// Configuration options for responsive flex layout components
/// ([NanoResponsiveLayout.flex]).
class NanoResponsiveFlexConfig extends NanoEquatable {
  /// Creates a [NanoResponsiveFlexConfig] instance.
  const NanoResponsiveFlexConfig({
    this.spacing,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.reverse,
    this.textDirection,
    this.verticalDirection,
    this.textBaseline,
  });

  /// Default fallback configuration used when no properties are specified.
  static const NanoResponsiveFlexConfig fallback = NanoResponsiveFlexConfig(
    spacing: 0.0,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    reverse: false,
    verticalDirection: VerticalDirection.down,
  );

  /// Alias for [fallback].
  static const NanoResponsiveFlexConfig defaultConfig = fallback;

  /// The space between each child widget in logical pixels.
  final double? spacing;

  /// How children should be placed along the main axis.
  final MainAxisAlignment? mainAxisAlignment;

  /// How much space children should occupy in the main axis.
  final MainAxisSize? mainAxisSize;

  /// How children should be placed along the cross axis.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Whether to reverse the order of children widgets.
  final bool? reverse;

  /// Determines the order to lay children out horizontally.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically.
  final VerticalDirection? verticalDirection;

  /// Baseline for aligning text children along the cross axis.
  final TextBaseline? textBaseline;

  /// Creates a copy of this configuration with the given fields replaced.
  NanoResponsiveFlexConfig copyWith({
    double? spacing,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    bool? reverse,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    return NanoResponsiveFlexConfig(
      spacing: spacing ?? this.spacing,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      reverse: reverse ?? this.reverse,
      textDirection: textDirection ?? this.textDirection,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textBaseline: textBaseline ?? this.textBaseline,
    );
  }

  /// Merges this configuration with an optional [override] configuration.
  ///
  /// Any non-null field in [override] takes precedence over this configuration.
  NanoResponsiveFlexConfig merge(NanoResponsiveFlexConfig? override) {
    if (override == null) return this;
    return NanoResponsiveFlexConfig(
      spacing: override.spacing ?? spacing,
      mainAxisAlignment: override.mainAxisAlignment ?? mainAxisAlignment,
      mainAxisSize: override.mainAxisSize ?? mainAxisSize,
      crossAxisAlignment: override.crossAxisAlignment ?? crossAxisAlignment,
      reverse: override.reverse ?? reverse,
      textDirection: override.textDirection ?? textDirection,
      verticalDirection: override.verticalDirection ?? verticalDirection,
      textBaseline: override.textBaseline ?? textBaseline,
    );
  }

  @override
  List<Object?> get props => [
    spacing,
    mainAxisAlignment,
    mainAxisSize,
    crossAxisAlignment,
    reverse,
    textDirection,
    verticalDirection,
    textBaseline,
  ];
}
