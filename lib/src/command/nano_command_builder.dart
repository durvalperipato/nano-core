import 'package:flutter/material.dart';
import '../state/nano_state.dart';
import 'nano_command.dart';

/// A reactive widget builder responding to [NanoCommand] state changes.
class NanoCommandBuilder<Output> extends StatelessWidget {
  /// Creates a [NanoCommandBuilder] instance.
  const NanoCommandBuilder({
    required this.command,
    required this.builder,
    super.key,
  });

  /// Target command to observe.
  final NanoCommand<Output> command;

  /// Builder callback rendering UI based on current [NanoState].
  final Widget Function(BuildContext context, NanoState<Output> state) builder;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<NanoState<Output>>(
        valueListenable: command,
        builder: (context, state, _) => builder(context, state),
      );
}
