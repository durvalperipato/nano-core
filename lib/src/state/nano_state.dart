enum NanoStateStatus { initial, loading, success, failure }

class NanoState<T> {
  final NanoStateStatus status;
  final T? data;
  final String? error;

  const NanoState({
    this.status = NanoStateStatus.initial,
    this.data,
    this.error,
  });

  NanoState<T> toLoading() => NanoState<T>(
        status: NanoStateStatus.loading,
        data: data,
        error: error,
      );

  NanoState<T> toSuccess(T newData) => NanoState<T>(
        status: NanoStateStatus.success,
        data: newData,
        error: null,
      );

  NanoState<T> toFailure(String newError) => NanoState<T>(
        status: NanoStateStatus.failure,
        data: data,
        error: newError,
      );

  bool get isInitial => status == NanoStateStatus.initial;
  bool get isLoading => status == NanoStateStatus.loading;
  bool get isSuccess => status == NanoStateStatus.success;
  bool get isFailure => status == NanoStateStatus.failure;
}
