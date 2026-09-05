import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';

/// Base abstract class for encapsulated commands extending
/// [ValueNotifier] holding [NanoState].
abstract class NanoCommand<Output> extends ValueNotifier<NanoState<Output>> {
  /// Creates a [NanoCommand] initializing with default [NanoState].
  NanoCommand({this.onSuccess, this.onError, this.emitLoadingOnRequest = true})
    : super(InitialState<Output>());

  /// Optional callback invoked when the command action completes successfully.
  final void Function(Output result)? onSuccess;

  /// Optional callback invoked when the command action throws an error.
  final void Function(Object error)? onError;

  /// Whether to emit a [LoadingState] when the action starts.
  final bool emitLoadingOnRequest;

  Future<void> _run(Future<Output> Function() action) async {
    if (emitLoadingOnRequest) value = value.toLoading();
    try {
      final result = await action();
      value = value.toLoaded(result);
      onSuccess?.call(result);
    } catch (e) {
      if (onError != null) {
        onError!(e);
      } else {
        value = value.toError();
      }
    }
  }
}

/// Command with no arguments executing a parameterless action.
class NanoCommand0<Output> extends NanoCommand<Output> {
  /// Creates a parameterless command with given [action].
  NanoCommand0(
    this.action, {
    super.onSuccess,
    super.onError,
    super.emitLoadingOnRequest,
  });

  /// The asynchronous action function to execute.
  final Future<Output> Function() action;

  /// Runs the underlying action without arguments.
  Future<void> run() => _run(action);
}

/// Command accepting a single argument of type [Argument].
class NanoCommand1<Argument, Output> extends NanoCommand<Output> {
  /// Creates a single-argument command with given [action].
  NanoCommand1(
    this.action, {
    super.onSuccess,
    super.onError,
    super.emitLoadingOnRequest,
  });

  /// The asynchronous action function accepting argument [arg].
  final Future<Output> Function(Argument arg) action;

  /// Runs the underlying action passing [arg].
  Future<void> run(Argument arg) => _run(() => action(arg));
}
