import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';

/// Base command for all Nano commands.
abstract class NanoCommand<T> extends ValueNotifier<NanoState<T>> {
  NanoCommand() : super(NanoState<T>());

  Future<void> _execute(Future<T> Function() action) async {
    value = value.toLoading();
    try {
      final result = await action();
      value = value.toSuccess(result);
    } catch (e) {
      value = value.toFailure(e.toString());
    }
  }
}

/// Command with no arguments.
class NanoCommand0<T> extends NanoCommand<T> {
  final Future<T> Function() action;

  NanoCommand0(this.action);

  Future<void> execute() => _execute(action);
}

/// Command with one argument.
class NanoCommand1<A, T> extends NanoCommand<T> {
  final Future<T> Function(A arg) action;

  NanoCommand1(this.action);

  Future<void> execute(A arg) => _execute(() => action(arg));
}
