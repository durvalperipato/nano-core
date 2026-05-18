import 'package:get_it/get_it.dart';

/// An abstract class to manage dependency injection scopes using [GetIt].
abstract class NanoInjections {
  /// Constructor that requires the [scope] name.
  const NanoInjections({required this.scope});

  /// The name of the scope to be managed.
  final String scope;

  /// Method to register dependencies within the specified scope.
  ///
  /// This method should be overridden to provide the bindings.
  void binds(GetIt i);

  /// Initializes the dependency injection scope.
  ///
  /// If the scope does not exist, it creates a new one and calls [binds].
  void initScope() {
    if (!GetIt.I.hasScope(scope)) {
      GetIt.I.pushNewScope(scopeName: scope, init: (i) => binds(i));
    }
  }

  /// Drops the managed dependency injection scope.
  void dropScope() {
    if (GetIt.I.hasScope(scope)) GetIt.I.dropScope(scope);
  }
}
