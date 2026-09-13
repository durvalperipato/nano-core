/// Length and structural boundary constants for standard form validations.
abstract final class NanoValidatorConstants {
  /// Brazilian CPF document length (11 digits).
  static const int cpfLength = 11;

  /// Brazilian CNPJ document length (14 characters).
  static const int cnpjLength = 14;

  /// Weights used to calculate the first check digit of a CNPJ.
  static const List<int> cnpjWeightsFirstDigit = [
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ];

  /// Weights used to calculate the second check digit of a CNPJ.
  static const List<int> cnpjWeightsSecondDigit = [
    6,
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ];

  /// Standard minimum length for credit card numbers (ISO/IEC 7812).
  static const int creditCardMinLength = 13;

  /// Standard maximum length for credit card numbers (ISO/IEC 7812).
  static const int creditCardMaxLength = 19;

  /// Minimum length for a credit card CVV/CVC code (3 digits).
  static const int creditCardCvvMinLength = 3;

  /// Maximum length for a credit card CVV/CVC code (4 digits for Amex).
  static const int creditCardCvvMaxLength = 4;
}

/// Pre-compiled regular expressions for high-performance form field validation.
abstract final class NanoValidatorRegex {
  /// Standard email format validation regex.
  static final email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Matches any character that is not a numeric digit (0-9).
  static final digitsOnly = RegExp(r'[^0-9]');

  /// Matches any character that is not alphanumeric (a-z, A-Z, 0-9).
  static final nonAlphanumeric = RegExp(r'[^a-zA-Z0-9]');

  /// Matches strings containing strictly one or more numeric digits.
  static final digits = RegExp(r'^\d+$');

  /// Detects 11 repeated identical digits in a CPF string.
  static final repeatedCpf = RegExp(r'^(\d)\1{10}$');

  /// Detects 14 repeated identical characters in a CNPJ string.
  static final repeatedCnpj = RegExp(r'^([A-Z0-9])\1{13}$');

  /// Matches a legacy numeric CNPJ containing exactly 14 digits.
  static final numericCnpj = RegExp(r'^\d{14}$');

  /// Matches an alphanumeric CNPJ (IN RFB nº 2.229/2024): 12 alphanumeric
  /// characters followed by 2 strictly numeric check digits.
  static final alphanumericCnpj = RegExp(r'^[A-Z0-9]{12}\d{2}$');

  /// Matches characters allowed in formatted credit card numbers (digits,
  /// spaces, and hyphens).
  static final creditCardAllowedChars = RegExp(r'^[0-9\s-]+$');

  /// Matches credit card expiration dates in `MM/YY`, `MM/YYYY`, `MM-YY`, or
  /// `MM-YYYY` format.
  static final creditCardExpiration = RegExp(
    r'^(\d{1,2})[\/\-](\d{2}|\d{4})$',
  );
}
