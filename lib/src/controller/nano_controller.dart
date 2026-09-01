import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';
import '../state/nano_state_observable.dart';
import '../state/nano_view_state.dart';

/// An abstract controller managing state [NanoState] for Flutter UI components.
///
/// Extends [ChangeNotifier] and implements [NanoStateObservable] to notify
/// listeners when state changes.
/// Requires [ViewState] to extend [NanoViewState] for structured, immutable
/// state models.
abstract class NanoController<ViewState extends NanoViewState>
    extends ChangeNotifier
    implements NanoStateObservable<ViewState> {
  /// Creates a new [NanoController] instance.
  NanoController();

  /// The current state of the controller.
  @override
  NanoState<ViewState> state = InitialState<ViewState>();

  /// Emits a new state and notifies all registered listeners.
  void emit(NanoState<ViewState> newState) {
    state = newState;
    notifyListeners();
  }

  /// Initializer method called when controller is instantiated or
  /// bound to a view.
  ///
  /// [id]: Optional identifier passed to initialize specific resource states.
  Future<void> init(String? id) async {}

  /// Executes an asynchronous [action], automatically updating state to:
  /// - `loading` when starting.
  /// - `success` with result when completed.
  /// - `error` with error message if an exception is thrown.
  Future<void> execute(Future<ViewState> Function() action) async {
    emit(state.toLoading());
    try {
      final result = await action();
      emit(state.toSuccess(result));
    } catch (e) {
      emit(state.toError());
    }
  }
}
