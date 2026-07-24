import 'package:flutter/material.dart';
import '../state/nano_state.dart';
import 'nano_command.dart';

/// A reactive widget builder responding to [NanoCommand] state changes.
class NanoCommandBuilder<T> extends StatelessWidget {
  /// Target command to observe.
  final NanoCommand<T> command;

  /// Builder callback rendering UI based on current [NanoState].
  final Widget Function(BuildContext context, NanoState<T> state) builder;

  /// Creates a [NanoCommandBuilder] instance.
  const NanoCommandBuilder({
    super.key,
    required this.command,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NanoState<T>>(
      valueListenable: command,
      builder: (context, state, _) {
        return builder(context, state);
      },
    );
  }
}
