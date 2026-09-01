/// A functional representation of either a successful outcome with data of
/// type [Success] or a failure with an error of type [Failure].
///
/// Implemented using Dart 3 sealed class hierarchy for compile-time
/// exhaustive pattern matching.
sealed class NanoResult<Success, Failure> {
  const NanoResult();

  /// Creates a successful [NanoResult] containing [data].
  const factory NanoResult.success(Success data) =
      NanoSuccess<Success, Failure>;

  /// Creates a failure [NanoResult] containing [error].
  const factory NanoResult.failure(Failure error) =
      NanoFailure<Success, Failure>;

  /// Returns `true` if this result is a [NanoSuccess].
  bool get isSuccess => this is NanoSuccess<Success, Failure>;

  /// Returns `true` if this result is a [NanoFailure].
  bool get isFailure => this is NanoFailure<Success, Failure>;

  /// Returns the success data if available, or `null` otherwise.
  Success? get dataOrNull => switch (this) {
        NanoSuccess(:final data) => data,
        NanoFailure() => null,
      };

  /// Returns the failure error if available, or `null` otherwise.
  Failure? get errorOrNull => switch (this) {
        NanoSuccess() => null,
        NanoFailure(:final error) => error,
      };

  /// Executes [onSuccess] if this is a success or [onFailure] if this is a
  /// failure, returning the resulting value of type [ResultType].
  ResultType fold<ResultType>({
    required ResultType Function(Success data) onSuccess,
    required ResultType Function(Failure error) onFailure,
  }) =>
      switch (this) {
        NanoSuccess(:final data) => onSuccess(data),
        NanoFailure(:final error) => onFailure(error),
      };

  /// Transforms the success value [data] using [fn], preserving failures.
  NanoResult<NewSuccess, Failure> map<NewSuccess>(
    NewSuccess Function(Success data) fn,
  ) =>
      switch (this) {
        NanoSuccess(:final data) => NanoResult.success(fn(data)),
        NanoFailure(:final error) => NanoResult.failure(error),
      };

  /// Transforms the failure value [error] using [fn], preserving successes.
  NanoResult<Success, NewFailure> mapError<NewFailure>(
    NewFailure Function(Failure error) fn,
  ) =>
      switch (this) {
        NanoSuccess(:final data) => NanoResult.success(data),
        NanoFailure(:final error) => NanoResult.failure(fn(error)),
      };

  /// Safely executes an asynchronous [computation], returning [NanoSuccess]
  /// with the result or [NanoFailure] with the caught [Object] exception.
  static Future<NanoResult<T, Object>> runAsync<T>(
    Future<T> Function() computation,
  ) async {
    try {
      final data = await computation();
      return NanoResult.success(data);
    } catch (e) {
      return NanoResult.failure(e);
    }
  }

  /// Safely executes a synchronous [computation], returning [NanoSuccess]
  /// with the result or [NanoFailure] with the caught [Object] exception.
  static NanoResult<T, Object> run<T>(
    T Function() computation,
  ) {
    try {
      final data = computation();
      return NanoResult.success(data);
    } catch (e) {
      return NanoResult.failure(e);
    }
  }
}

/// Represents a successful computation outcome holding [data] of type
/// [Success].
final class NanoSuccess<Success, Failure> extends NanoResult<Success, Failure> {
  /// Creates a [NanoSuccess] result.
  const NanoSuccess(this.data);

  /// The success payload data.
  final Success data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NanoSuccess<Success, Failure> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'NanoSuccess($data)';
}

/// Represents a failed computation outcome holding [error] of type [Failure].
final class NanoFailure<Success, Failure> extends NanoResult<Success, Failure> {
  /// Creates a [NanoFailure] result.
  const NanoFailure(this.error);

  /// The failure error or exception payload.
  final Failure error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NanoFailure<Success, Failure> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'NanoFailure($error)';
}
