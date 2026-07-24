/// Represents the status of a [NanoState].
enum NanoStateStatus {
  /// Initial state before any action is performed.
  initial,

  /// Loading state while an asynchronous operation is in progress.
  loading,

  /// Success state after an operation completes successfully.
  success,

  /// Failure state when an error occurs during execution.
  failure,
}

/// Immutable state container holding [status], optional [data], and optional [error].
class NanoState<T> {
  /// Current execution status.
  final NanoStateStatus status;

  /// Data payload associated with success or in-progress states.
  final T? data;

  /// Error message string associated with failure state.
  final String? error;

  /// Creates a [NanoState] instance.
  const NanoState({
    this.status = NanoStateStatus.initial,
    this.data,
    this.error,
  });

  /// Returns a copy of [NanoState] in [NanoStateStatus.loading] status.
  NanoState<T> toLoading() => NanoState<T>(
        status: NanoStateStatus.loading,
        data: data,
        error: error,
      );

  /// Returns a copy of [NanoState] in [NanoStateStatus.success] status with [newData].
  NanoState<T> toSuccess(T newData) => NanoState<T>(
        status: NanoStateStatus.success,
        data: newData,
        error: null,
      );

  /// Returns a copy of [NanoState] in [NanoStateStatus.failure] status with [newError].
  NanoState<T> toFailure(String newError) => NanoState<T>(
        status: NanoStateStatus.failure,
        data: data,
        error: newError,
      );

  /// Whether status is [NanoStateStatus.initial].
  bool get isInitial => status == NanoStateStatus.initial;

  /// Whether status is [NanoStateStatus.loading].
  bool get isLoading => status == NanoStateStatus.loading;

  /// Whether status is [NanoStateStatus.success].
  bool get isSuccess => status == NanoStateStatus.success;

  /// Whether status is [NanoStateStatus.failure].
  bool get isFailure => status == NanoStateStatus.failure;
}
