import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';

/// Base abstract class for encapsulated commands extending
/// [ValueNotifier] holding [NanoState].
abstract class NanoCommand<Output> extends ValueNotifier<NanoState<Output>> {
  /// Creates a [NanoCommand] initializing with default [NanoState].
  NanoCommand() : super(InitialState<Output>());

  Future<void> _execute(Future<Output> Function() action) async {
    value = value.toLoading();
    try {
      final result = await action();
      value = value.toSuccess(result);
    } catch (e) {
      value = value.toError();
    }
  }
}

/// Command with no arguments executing a parameterless action.
class NanoCommand0<Output> extends NanoCommand<Output> {
  /// Creates a parameterless command with given [action].
  NanoCommand0(this.action);

  /// The asynchronous action function to execute.
  final Future<Output> Function() action;

  /// Executes the underlying action.
  Future<void> execute() => _execute(action);
}

/// Command accepting a single argument of type [Argument].
class NanoCommand1<Argument, Output> extends NanoCommand<Output> {
  /// Creates a single-argument command with given [action].
  NanoCommand1(this.action);

  /// The asynchronous action function accepting argument [arg].
  final Future<Output> Function(Argument arg) action;

  /// Executes the underlying action passing [arg].
  Future<void> execute(Argument arg) => _execute(() => action(arg));
}
