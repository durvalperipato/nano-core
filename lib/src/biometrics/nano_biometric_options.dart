import '../equatable/nano_equatable.dart';

/// Configuration options passed to `NanoBiometrics.authenticate`.
///
/// All properties are optional with no hardcoded fallback strings, ensuring
/// strict compliance with internationalization (i18n / l10n) best practices.
class NanoBiometricOptions extends NanoEquatable {
  /// Creates a [NanoBiometricOptions] configuration.
  const NanoBiometricOptions({
    this.reason,
    this.cancelTitle,
    this.sensitiveData = true,
    this.stickyAuth = false,
    this.biometricOnly = false,
  });

  /// The localized user-facing prompt displayed on the biometric dialog.
  final String? reason;

  /// The localized label for the cancel button on the biometric prompt.
  final String? cancelTitle;

  /// Whether the data protected by this authentication is sensitive.
  final bool sensitiveData;

  /// Whether to automatically retry authentication upon resuming from
  /// background.
  final bool stickyAuth;

  /// Whether to enforce biometric-only authentication without passcode
  /// fallback.
  final bool biometricOnly;

  /// Creates a copy of this options instance with the given fields replaced.
  NanoBiometricOptions copyWith({
    String? reason,
    String? cancelTitle,
    bool? sensitiveData,
    bool? stickyAuth,
    bool? biometricOnly,
  }) {
    return NanoBiometricOptions(
      reason: reason ?? this.reason,
      cancelTitle: cancelTitle ?? this.cancelTitle,
      sensitiveData: sensitiveData ?? this.sensitiveData,
      stickyAuth: stickyAuth ?? this.stickyAuth,
      biometricOnly: biometricOnly ?? this.biometricOnly,
    );
  }

  @override
  List<Object?> get props => [
        reason,
        cancelTitle,
        sensitiveData,
        stickyAuth,
        biometricOnly,
      ];
}
