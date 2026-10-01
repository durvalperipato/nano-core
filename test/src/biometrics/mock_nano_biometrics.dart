import 'package:nano_core/nano_core.dart';

/// An in-memory mock implementation of [NanoBiometrics] designed for unit,
/// widget, and integration tests in headless CI/CD environments.
class MockNanoBiometrics implements NanoBiometrics {
  /// Creates a [MockNanoBiometrics] test double with customizable defaults.
  MockNanoBiometrics({
    this.isAvailableResult = true,
    this.availableTypesResult = const [
      NanoBiometricType.fingerprint,
      NanoBiometricType.face,
    ],
    this.authenticateResult = true,
    this.delay = Duration.zero,
    this.errorToThrow,
  });

  /// The boolean value returned by [isAvailable].
  bool isAvailableResult;

  /// The list of modalities returned by [getAvailableTypes].
  List<NanoBiometricType> availableTypesResult;

  /// The boolean value returned by [authenticate].
  bool authenticateResult;

  /// Artificial latency added before completing asynchronous methods.
  Duration delay;

  /// If non-null, this exception is thrown when any method is invoked.
  Exception? errorToThrow;

  /// Invocation counter for [isAvailable].
  int isAvailableCallCount = 0;

  /// Invocation counter for [getAvailableTypes].
  int getAvailableTypesCallCount = 0;

  /// Invocation counter for [authenticate].
  int authenticateCallCount = 0;

  /// The options passed into the most recent call to [authenticate].
  NanoBiometricOptions? lastOptionsUsed;

  @override
  Future<bool> isAvailable() async {
    isAvailableCallCount++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (errorToThrow != null) throw errorToThrow!;
    return isAvailableResult;
  }

  @override
  Future<List<NanoBiometricType>> getAvailableTypes() async {
    getAvailableTypesCallCount++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (errorToThrow != null) throw errorToThrow!;
    return availableTypesResult;
  }

  @override
  Future<bool> authenticate([NanoBiometricOptions? options]) async {
    authenticateCallCount++;
    lastOptionsUsed = options;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (errorToThrow != null) throw errorToThrow!;
    return authenticateResult;
  }

  /// Resets all counters, captured arguments, and mock configurations
  /// to default.
  void reset() {
    isAvailableCallCount = 0;
    getAvailableTypesCallCount = 0;
    authenticateCallCount = 0;
    lastOptionsUsed = null;
    errorToThrow = null;
    isAvailableResult = true;
    availableTypesResult = const [
      NanoBiometricType.fingerprint,
      NanoBiometricType.face,
    ];
    authenticateResult = true;
    delay = Duration.zero;
  }
}
