import 'package:nano_core/nano_core.dart';

/// Base sealed class representing the state of an operation or UI component.
sealed class NanoState<T> {
  const NanoState();

  /// Retrieves the current data payload if available in the current state.
  T? get data => null;

  /// Transitions to a [LoadingState].
  /// By default, preserves the current [data]. Use [data] to update it.
  LoadingState<T> toLoading({T? data}) =>
      LoadingState<T>(data: data ?? this.data);

  /// Transitions to a [LoadedState] with the new [data].
  LoadedState<T> toLoaded(T data) => LoadedState<T>(data);

  /// Transitions to a [SuccessState] with the new [data].
  SuccessState<T> toSuccess(T data) => SuccessState<T>(data);

  /// Transitions to an [ErrorState] with the provided [key].
  /// By default, preserves the current [data]. Use [data] to update it.
  ErrorState<T> toError({NanoMessageKey? key, T? data}) =>
      ErrorState<T>(key, data: data ?? this.data);

  /// Transitions to a [WarningState] with the provided [key].
  /// By default, preserves the current [data]. Use [data] to update it.
  WarningState<T> toWarning({NanoMessageKey? key, T? data}) =>
      WarningState<T>(key, data: data ?? this.data);
}

/// Initial state before any action is performed.
class InitialState<T> extends NanoState<T> {
  /// Creates an [InitialState] instance.
  const InitialState();
}

/// Loading state while an asynchronous operation is in progress.
class LoadingState<T> extends NanoState<T> {
  /// Creates a [LoadingState] instance, optionally with [data].
  const LoadingState({this.data});

  /// The data payload associated with the state, if any.
  @override
  final T? data;
}

/// Loaded state after an operation finishes and data is ready.
class LoadedState<T> extends NanoState<T> {
  /// Creates a [LoadedState] instance with the given [data].
  const LoadedState(this.data);

  /// The data payload returned by the operation.
  @override
  final T data;
}

/// Success state after an operation completes successfully.
class SuccessState<T> extends NanoState<T> {
  /// Creates a [SuccessState] instance with the given [data].
  const SuccessState(this.data);

  /// The data payload returned by the operation.
  @override
  final T data;
}

/// Error state when an error occurs during execution.
class ErrorState<T> extends NanoState<T> {
  /// Creates an [ErrorState] instance with the given [key].
  const ErrorState(this.key, {this.data});

  /// The error key associated with the failure.
  final NanoMessageKey? key;

  /// The optional data payload associated with the state.
  @override
  final T? data;
}

/// Warning state when an operation completes with non-fatal warnings.
class WarningState<T> extends NanoState<T> {
  /// Creates a [WarningState] instance with the given [key].
  const WarningState(this.key, {this.data});

  /// The warning key.
  final NanoMessageKey? key;

  /// Optional data payload associated with the warning state.
  @override
  final T? data;
}
