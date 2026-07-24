/// Represents the status of a [NanoState].
enum NanoStateStatus {
  /// Initial state before any action is performed.
  initial,

  /// Loading state while an asynchronous operation is in progress.
  loading,

  /// Success state after an operation completes successfully.
  success,

  /// Error state when an error occurs during execution.
  error,

  /// Warning state when an operation completes with non-fatal warnings.
  warning,
}

/// Immutable state container holding [status], optional [data], optional [error], and optional [warning].
class NanoState<T> {
  /// Current execution status.
  final NanoStateStatus status;

  /// Data payload associated with success or in-progress states.
  final T? data;

  /// Error message string associated with error state.
  final String? error;

  /// Warning message string associated with warning state.
  final String? warning;

  /// Creates a [NanoState] instance.
  const NanoState({
    this.status = NanoStateStatus.initial,
    this.data,
    this.error,
    this.warning,
  });

  /// Returns a copy of [NanoState] in [NanoStateStatus.loading] status.
  NanoState<T> toLoading() => NanoState<T>(
        status: NanoStateStatus.loading,
        data: data,
        error: error,
        warning: warning,
      );

  /// Returns a copy of [NanoState] in [NanoStateStatus.success] status with [newData].
  NanoState<T> toSuccess(T newData) => NanoState<T>(
        status: NanoStateStatus.success,
        data: newData,
        error: null,
        warning: null,
      );

  /// Returns a copy of [NanoState] in [NanoStateStatus.error] status with [newError].
  NanoState<T> toError(String newError) => NanoState<T>(
        status: NanoStateStatus.error,
        data: data,
        error: newError,
        warning: null,
      );

  /// Returns a copy of [NanoState] in [NanoStateStatus.warning] status with [newWarning].
  NanoState<T> toWarning(String newWarning) => NanoState<T>(
        status: NanoStateStatus.warning,
        data: data,
        error: null,
        warning: newWarning,
      );

  /// Whether status is [NanoStateStatus.initial].
  bool get isInitial => status == NanoStateStatus.initial;

  /// Whether status is [NanoStateStatus.loading].
  bool get isLoading => status == NanoStateStatus.loading;

  /// Whether status is [NanoStateStatus.success].
  bool get isSuccess => status == NanoStateStatus.success;

  /// Whether status is [NanoStateStatus.error].
  bool get isError => status == NanoStateStatus.error;

  /// Whether status is [NanoStateStatus.warning].
  bool get isWarning => status == NanoStateStatus.warning;
}
