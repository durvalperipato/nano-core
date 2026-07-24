import 'package:flutter/material.dart';
import '../state/nano_state.dart';
import 'nano_command.dart';

class NanoCommandBuilder<T> extends StatelessWidget {
  final NanoCommand<T> command;
  final Widget Function(BuildContext context, NanoState<T> state) builder;

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
