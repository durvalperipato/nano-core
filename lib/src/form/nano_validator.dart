import 'package:flutter/material.dart';

import 'nano_validator_patterns.dart';

/// Signature for validator functions returning an error message if invalid,
/// or `null` if valid.
///
/// Can return a static [String], an internationalized
/// `String Function(BuildContext)` callback, or `null`.
typedef NanoValidatorFunction<Value> = dynamic Function(Value? value);

/// Collection of standard, chainable form field validators with full
/// internationalization ([BuildContext]) support.
abstract final class NanoValidator {

  /// Resolves an error message payload (static string or context callback)
  /// into a localized [String].
  static String? resolveMessage(dynamic error, BuildContext? context) {
    if (error == null) return null;
    if (error is String) return error;
    if (error is String Function(BuildContext)) {
      if (context != null) return error(context);
      return error.toString();
    }
    if (error is String Function()) {
      return error();
    }
    return error.toString();
  }

  /// Requires the field to have a non-null, non-empty value.
  static NanoValidatorFunction<Value> required<Value>(dynamic message) {
    return (value) {
      if (value == null) return message;
      if (value is String && value.trim().isEmpty) return message;
      if (value is Iterable && value.isEmpty) return message;
      if (value is Map && value.isEmpty) return message;
      return null;
    };
  }

  /// Validates that a string is a well-formatted email address.
  static NanoValidatorFunction<String> email(dynamic message) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      if (!NanoValidatorRegex.email.hasMatch(value.trim())) return message;
      return null;
    };
  }

  /// Validates that a string has at least [min] characters.
  static NanoValidatorFunction<String> minLength(int min, dynamic message) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min) return message;
      return null;
    };
  }

  /// Validates that a string does not exceed [max] characters.
  static NanoValidatorFunction<String> maxLength(int max, dynamic message) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > max) return message;
      return null;
    };
  }

  /// Validates that a numeric value is at least [min].
  static NanoValidatorFunction<num> min(num min, dynamic message) {
    return (value) {
      if (value == null) return null;
      if (value < min) return message;
      return null;
    };
  }

  /// Validates that a numeric value does not exceed [max].
  static NanoValidatorFunction<num> max(num max, dynamic message) {
    return (value) {
      if (value == null) return null;
      if (value > max) return message;
      return null;
    };
  }

  /// Validates that a string matches a given regular expression [pattern].
  static NanoValidatorFunction<String> pattern(
    Pattern pattern,
    dynamic message,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final regExp = pattern is RegExp ? pattern : RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) return message;
      return null;
    };
  }

  /// Validates that this field value equals another getter / value.
  static NanoValidatorFunction<Value> match<Value>(
    Value Function() otherValueGetter,
    dynamic message,
  ) {
    return (value) {
      if (value != otherValueGetter()) return message;
      return null;
    };
  }

  /// Validates Brazilian CPF format and check digits.
  static NanoValidatorFunction<String> cpf(dynamic message) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      if (!_isValidCpf(value)) return message;
      return null;
    };
  }

  /// Validates Brazilian CNPJ format and check digits.
  ///
  /// Supports both legacy numeric CNPJs and the new alphanumeric CNPJ
  /// specification (Instrução Normativa RFB nº 2.229/2024).
  ///
  /// When [allowAlphanumeric] is `true` (default), the first 12 characters may
  /// contain letters (A-Z) and digits (0-9). The two check digits (positions
  /// 13 and 14) are always strictly numeric.
  static NanoValidatorFunction<String> cnpj(
    dynamic message, {
    bool allowAlphanumeric = true,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      if (!_isValidCnpj(value, allowAlphanumeric: allowAlphanumeric)) {
        return message;
      }
      return null;
    };
  }

  /// Validates a Brazilian document field accepting either a CPF (11 digits)
  /// or a CNPJ (14 characters).
  ///
  /// Automatically determines the document type based on the cleaned character
  /// length. Supports alphanumeric CNPJ when [allowAlphanumeric] is `true`.
  static NanoValidatorFunction<String> cpfOrCnpj(
    dynamic message, {
    bool allowAlphanumeric = true,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final clean = value.replaceAll(NanoValidatorRegex.nonAlphanumeric, '');
      final isCpf = clean.length == NanoValidatorConstants.cpfLength;
      final isCnpj = clean.length == NanoValidatorConstants.cnpjLength;

      if (isCpf) {
        if (!_isValidCpf(clean)) return message;
        return null;
      }
      if (isCnpj) {
        if (!_isValidCnpj(clean, allowAlphanumeric: allowAlphanumeric)) {
          return message;
        }
        return null;
      }
      return message;
    };
  }

  /// Validates a credit card number using the Luhn algorithm (Modulo 10).
  ///
  /// Ignores standard formatting characters (spaces and hyphens). The cleaned
  /// number must contain between [minLength] (default 13) and [maxLength]
  /// (default 19) digits and satisfy the Luhn checksum formula.
  static NanoValidatorFunction<String> creditCard(
    dynamic message, {
    int minLength = NanoValidatorConstants.creditCardMinLength,
    int maxLength = NanoValidatorConstants.creditCardMaxLength,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final trimmed = value.trim();
      if (!NanoValidatorRegex.creditCardAllowedChars.hasMatch(trimmed)) {
        return message;
      }
      final clean = trimmed.replaceAll(NanoValidatorRegex.digitsOnly, '');
      if (clean.length < minLength || clean.length > maxLength) return message;
      if (!_isValidLuhn(clean)) return message;
      return null;
    };
  }

  /// Validates a credit card expiration date in `MM/YY` or `MM/YYYY` format.
  ///
  /// Verifies that the month is between 1 and 12, and that the card has not
  /// expired (a card remains valid until the last day of the expiration month).
  /// An optional [now] provider can be passed for deterministic testing.
  static NanoValidatorFunction<String> creditCardExpiration(
    dynamic message, {
    DateTime Function()? now,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final clean = value.trim();
      final match = NanoValidatorRegex.creditCardExpiration.firstMatch(clean);
      if (match == null) return message;

      final month = int.tryParse(match.group(1)!);
      var year = int.tryParse(match.group(2)!);
      if (month == null || year == null) return message;
      if (month < 1 || month > 12) return message;

      if (year < 100) {
        year += 2000;
      }

      final currentDate = now != null ? now() : DateTime.now();
      final currentYear = currentDate.year;
      final currentMonth = currentDate.month;

      if (year < currentYear) return message;
      if (year == currentYear && month < currentMonth) return message;
      return null;
    };
  }

  /// Validates a credit card CVV/CVC security code.
  ///
  /// Ensures the input contains strictly numeric digits with a length between
  /// [minLength] (default 3) and [maxLength] (default 4).
  static NanoValidatorFunction<String> creditCardCvv(
    dynamic message, {
    int minLength = NanoValidatorConstants.creditCardCvvMinLength,
    int maxLength = NanoValidatorConstants.creditCardCvvMaxLength,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final clean = value.trim();
      if (clean.length < minLength || clean.length > maxLength) return message;
      if (!NanoValidatorRegex.digits.hasMatch(clean)) return message;
      return null;
    };
  }

  static bool _isValidLuhn(String number) {
    var sum = 0;
    var alternate = false;
    for (var i = number.length - 1; i >= 0; i--) {
      var n = number.codeUnitAt(i) - 48;
      if (n < 0 || n > 9) return false;
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  static bool _isValidCpf(String value) {
    final numbers = value.replaceAll(NanoValidatorRegex.digitsOnly, '');
    if (numbers.length != NanoValidatorConstants.cpfLength) return false;
    if (NanoValidatorRegex.repeatedCpf.hasMatch(numbers)) return false;

    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += (numbers.codeUnitAt(i) - 48) * (10 - i);
    }
    final firstDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (firstDigit != numbers.codeUnitAt(9) - 48) return false;

    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += (numbers.codeUnitAt(i) - 48) * (11 - i);
    }
    final secondDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (secondDigit != numbers.codeUnitAt(10) - 48) return false;

    return true;
  }

  static bool _isValidCnpj(String value, {required bool allowAlphanumeric}) {
    final clean = value
        .replaceAll(NanoValidatorRegex.nonAlphanumeric, '')
        .toUpperCase();
    if (clean.length != NanoValidatorConstants.cnpjLength) return false;

    if (!allowAlphanumeric) {
      if (!NanoValidatorRegex.numericCnpj.hasMatch(clean)) return false;
    } else {
      if (!NanoValidatorRegex.alphanumericCnpj.hasMatch(clean)) return false;
    }

    if (NanoValidatorRegex.repeatedCnpj.hasMatch(clean)) return false;

    final weights1 = NanoValidatorConstants.cnpjWeightsFirstDigit;
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += (clean.codeUnitAt(i) - 48) * weights1[i];
    }
    final rest1 = sum % 11;
    final firstDigit = rest1 < 2 ? 0 : 11 - rest1;
    if (firstDigit != clean.codeUnitAt(12) - 48) return false;

    final weights2 = NanoValidatorConstants.cnpjWeightsSecondDigit;
    sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += (clean.codeUnitAt(i) - 48) * weights2[i];
    }
    sum += firstDigit * weights2[12];
    final rest2 = sum % 11;
    final secondDigit = rest2 < 2 ? 0 : 11 - rest2;
    if (secondDigit != clean.codeUnitAt(13) - 48) return false;

    return true;
  }

  /// Custom inline validator function.
  static NanoValidatorFunction<Value> custom<Value>(
    dynamic Function(Value? value) validatorFn,
  ) => validatorFn;
}
