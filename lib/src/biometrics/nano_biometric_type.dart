/// Represents the biometric modality types supported across platforms.
enum NanoBiometricType {
  /// Facial recognition modality (e.g. Face ID on iOS, Face Unlock on Android).
  face,

  /// Fingerprint biometric sensor (e.g. Touch ID on Apple devices, Fingerprint sensor on Android/Windows).
  fingerprint,

  /// Iris biometric scanner modality.
  iris,

  /// Weak or device-credential security modality (e.g. PIN, pattern, passcode).
  weak,

  /// Strong hardware-backed cryptographic biometric modality.
  strong,
}
