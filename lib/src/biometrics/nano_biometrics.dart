import 'nano_biometric_options.dart';
import 'nano_biometric_type.dart';

/// An abstract contract defining cross-platform biometric authentication
/// operations without direct native plugin dependencies.
///
/// Concrete implementations (such as `AppBiometricsAdapter` using `local_auth`)
/// can be scaffolded directly into client applications via the `nano-init`
/// skill, or mocked via test doubles in unit and widget tests.
abstract class NanoBiometrics {
  /// Creates a [NanoBiometrics] interface instance.
  const NanoBiometrics();

  /// Verifies whether biometric authentication hardware is available,
  /// supported, and has enrolled credentials on the device.
  Future<bool> isAvailable();

  /// Retrieves the list of available biometric modalities supported on
  /// the device.
  Future<List<NanoBiometricType>> getAvailableTypes();

  /// Prompts the user to authenticate using biometric sensors.
  ///
  /// Returns `true` if authentication succeeds, or `false` if authentication
  /// fails, is cancelled by the user, or if biometric hardware is unavailable.
  Future<bool> authenticate([NanoBiometricOptions? options]);
}
