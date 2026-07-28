import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';

/// Base abstract class for encapsulated commands extending
/// [ValueNotifier] holding [NanoState].
abstract class NanoCommand<T> extends ValueNotifier<NanoState<T>> {
  /// Creates a [NanoCommand] initializing with default [NanoState].
  NanoCommand() : super(NanoState<T>());

  Future<void> _execute(Future<T> Function() action) async {
    value = value.toLoading();
    try {
      final result = await action();
      value = value.toSuccess(result);
    } catch (e) {
      value = value.toError(e.toString());
    }
  }
}

/// Command with no arguments executing a parameterless action.
class NanoCommand0<T> extends NanoCommand<T> {
  /// The asynchronous action function to execute.
  final Future<T> Function() action;

  /// Creates a parameterless command with given [action].
  NanoCommand0(this.action);

  /// Executes the underlying action.
  Future<void> execute() => _execute(action);
}

/// Command accepting a single argument of type [A].
class NanoCommand1<A, T> extends NanoCommand<T> {
  /// The asynchronous action function accepting argument [arg].
  final Future<T> Function(A arg) action;

  /// Creates a single-argument command with given [action].
  NanoCommand1(this.action);

  /// Executes the underlying action passing [arg].
  Future<void> execute(A arg) => _execute(() => action(arg));
}
