import 'nano_environment_type.dart';

/// Utility for querying runtime environment flags, build modes, and
/// compile-time environment variables with automatic production/development
/// detection.
abstract final class NanoEnvironment {
  /// Whether the application is running in production release mode (compiled
  /// with `dart.vm.product`).
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  /// Whether the application is running in profile mode (compiled with
  /// `dart.vm.profile`).
  static const bool isProfile = bool.fromEnvironment('dart.vm.profile');

  /// Whether the application is running in debug/development mode.
  static const bool isDevelopment = !isProduction && !isProfile;

  /// Current [NanoEnvironmentType] based on the Flutter compilation mode.
  static NanoEnvironmentType get currentType {
    if (isProduction) return NanoEnvironmentType.production;
    if (isProfile) return NanoEnvironmentType.profile;
    return NanoEnvironmentType.development;
  }

  /// Custom environment name passed via `--dart-define ENV=<name>`.
  ///
  /// Defaults to `production` when compiled in release mode, and `development`
  /// otherwise.
  static const String currentEnvName = String.fromEnvironment(
    'ENV',
    defaultValue: isProduction ? 'production' : 'development',
  );

  /// Retrieves a compile-time string environment variable.
  static String getString(String key, {String defaultValue = ''}) =>
      String.fromEnvironment(key, defaultValue: defaultValue);

  /// Retrieves a compile-time boolean environment variable.
  static bool getBool(String key, {bool defaultValue = false}) =>
      bool.fromEnvironment(key, defaultValue: defaultValue);

  /// Retrieves a compile-time integer environment variable.
  static int getInt(String key, {int defaultValue = 0}) =>
      int.fromEnvironment(key, defaultValue: defaultValue);
}
