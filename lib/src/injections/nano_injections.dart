import 'dart:async';
import 'package:get_it/get_it.dart';

/// An abstract class to manage dependency injection scopes using [GetIt].
abstract class NanoInjections {
  /// Constructor that requires the [scope] name.
  const NanoInjections({required this.scope});

  /// The name of the scope to be managed.
  final String scope;

  /// Method to register dependencies within the specified scope.
  ///
  /// Supports both synchronous and asynchronous registrations.
  FutureOr<void> binds(GetIt i);

  /// Initializes the dependency injection scope and waits for all async
  /// singletons to become ready.
  Future<void> initScope() async {
    if (!GetIt.I.hasScope(scope)) {
      final completer = Completer<void>();
      GetIt.I.pushNewScope(
        scopeName: scope,
        init: (i) {
          final result = binds(i);
          if (result is Future) {
            result.then((_) => completer.complete());
          } else {
            completer.complete();
          }
        },
      );
      await completer.future;
      await GetIt.I.allReady();
    }
  }

  /// Callable invocation allowing `await const AppInjections()()` to
  /// initialize the scope and resolve all async dependencies.
  Future<void> call() => initScope();

  /// Drops the managed dependency injection scope.
  void dropScope() {
    if (GetIt.I.hasScope(scope)) GetIt.I.dropScope(scope);
  }
}
