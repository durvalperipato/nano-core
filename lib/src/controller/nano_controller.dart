import 'package:flutter/foundation.dart';
import '../command/nano_command.dart';
import '../state/nano_message_key.dart';
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
  /// Creates a new [NanoController] instance with a required [initialState].
  NanoController({required ViewState initialState})
    : state = InitialState<ViewState>(data: initialState);

  final List<NanoCommand<dynamic>> _commands = [];

  /// The current state of the controller.
  @override
  NanoState<ViewState> state;

  /// Retrieves the current [ViewState] data from [state].
  ViewState get viewState => state.data!;

  /// Creates and registers a parameterless [NanoCommand0] with automatic
  /// disposal.
  NanoCommand0<Output> nanoCommand0<Output>(
    Future<Output> Function() action, {
    void Function(Output result)? onSuccess,
    void Function(Object error)? onError,
    bool emitLoadingOnRequest = true,
  }) {
    final cmd = NanoCommand0<Output>(
      action,
      onSuccess: onSuccess,
      onError: onError,
      emitLoadingOnRequest: emitLoadingOnRequest,
    );
    _commands.add(cmd);
    return cmd;
  }

  /// Creates and registers a single-argument [NanoCommand1] with automatic
  /// disposal.
  NanoCommand1<Argument, Output> nanoCommand1<Argument, Output>(
    Future<Output> Function(Argument arg) action, {
    void Function(Output result)? onSuccess,
    void Function(Object error)? onError,
    bool emitLoadingOnRequest = true,
  }) {
    final cmd = NanoCommand1<Argument, Output>(
      action,
      onSuccess: onSuccess,
      onError: onError,
      emitLoadingOnRequest: emitLoadingOnRequest,
    );
    _commands.add(cmd);
    return cmd;
  }

  /// Emits a new state and notifies all registered listeners.
  void emit(NanoState<ViewState> newState) {
    state = newState;
    notifyListeners();
  }

  /// Emits an [InitialState] with optional [data].
  void emitInitial({ViewState? data}) => emit(state.toInitial(data: data));

  /// Emits a [LoadingState] with optional [data].
  void emitLoading({ViewState? data}) => emit(state.toLoading(data: data));

  /// Emits a [LoadedState] with the provided [data].
  void emitLoaded(ViewState data) => emit(state.toLoaded(data));

  /// Emits a [SuccessState] with optional [key] and [data].
  void emitSuccess({NanoMessageKey? key, ViewState? data}) =>
      emit(state.toSuccess(key: key, data: data));

  /// Emits an [ErrorState] with optional [key] and [data].
  void emitError({NanoMessageKey? key, ViewState? data}) =>
      emit(state.toError(key: key, data: data));

  /// Emits a [WarningState] with optional [key] and [data].
  void emitWarning({NanoMessageKey? key, ViewState? data}) =>
      emit(state.toWarning(key: key, data: data));

  /// Emits a [CustomState] with the provided [payload] and optional [data].
  void emitCustom<Payload>(Payload payload, {ViewState? data}) =>
      emit(state.toCustom<Payload>(payload, data: data));

  /// Initializer method called when controller is instantiated or
  /// bound to a view.
  ///
  /// [id]: Optional identifier passed to initialize specific resource states.
  Future<void> init(String? id);

  /// Executes an asynchronous [action].
  ///
  /// Optionally toggles [emitLoadingOnRequest] (defaults to `true`),
  /// and invokes [onSuccess] with the action result.
  /// If an exception occurs, invokes [onError] or updates state to `error`.
  Future<void> execute<T>(
    Future<T> Function() action, {
    bool emitLoadingOnRequest = true,
    void Function(T result)? onSuccess,
    void Function(Object error)? onError,
  }) async {
    if (emitLoadingOnRequest) emitLoading();
    try {
      final result = await action();
      emitLoaded(viewState);
      onSuccess?.call(result);
    } catch (e) {
      if (onError != null) {
        onError(e);
      } else {
        emitError();
      }
    }
  }

  @override
  void dispose() {
    for (final command in _commands) {
      command.dispose();
    }
    _commands.clear();
    super.dispose();
  }
}
