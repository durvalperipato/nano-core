import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';

/// An abstract controller managing state [NanoState] for Flutter UI components.
///
/// Extends [ChangeNotifier] to notify listeners when state changes.
abstract class NanoController<T> extends ChangeNotifier {
  /// The current state of the controller.
  NanoState<T> state = NanoState<T>();

  /// Emits a new state and notifies all registered listeners.
  void emit(NanoState<T> newState) {
    state = newState;
    notifyListeners();
  }

  /// Initializer method called when controller is instantiated or bound to a view.
  ///
  /// [id]: Optional identifier passed to initialize specific resource states.
  Future<void> init(String? id) async {}

  /// Executes an asynchronous [action], automatically updating state to:
  /// - `loading` when starting.
  /// - `success` with result when completed.
  /// - `failure` with error message if an exception is thrown.
  Future<void> execute(Future<T> Function() action) async {
    emit(state.toLoading());
    try {
      final result = await action();
      emit(state.toSuccess(result));
    } catch (e) {
      emit(state.toFailure(e.toString()));
    }
  }
}
