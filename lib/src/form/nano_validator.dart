import 'package:flutter/material.dart';

/// Signature for validator functions returning an error message if invalid,
/// or `null` if valid.
///
/// Can return a static [String], an internationalized
/// `String Function(BuildContext)` callback, or `null`.
typedef NanoValidatorFunction<Value> = dynamic Function(Value? value);

/// Collection of standard, chainable form field validators with full
/// internationalization ([BuildContext]) support.
abstract final class NanoValidator {
  // Document length constants
  static const int _cpfLength = 11;
  static const int _cnpjLength = 14;

  // Pre-compiled regular expressions for performance and readability
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _digitsOnlyRegex = RegExp(r'[^0-9]');
  static final _nonAlphanumericRegex = RegExp(r'[^a-zA-Z0-9]');
  static final _repeatedCpfRegex = RegExp(r'^(\d)\1{10}$');
  static final _repeatedCnpjRegex = RegExp(r'^([A-Z0-9])\1{13}$');
  static final _numericCnpjRegex = RegExp(r'^\d{14}$');
  static final _alphanumericCnpjRegex = RegExp(r'^[A-Z0-9]{12}\d{2}$');

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
      if (!_emailRegex.hasMatch(value.trim())) return message;
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
      final clean = value.replaceAll(_nonAlphanumericRegex, '');
      final isCpf = clean.length == _cpfLength;
      final isCnpj = clean.length == _cnpjLength;

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

  static bool _isValidCpf(String value) {
    final numbers = value.replaceAll(_digitsOnlyRegex, '');
    if (numbers.length != _cpfLength) return false;
    if (_repeatedCpfRegex.hasMatch(numbers)) return false;

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
    final clean = value.replaceAll(_nonAlphanumericRegex, '').toUpperCase();
    if (clean.length != _cnpjLength) return false;

    if (!allowAlphanumeric) {
      if (!_numericCnpjRegex.hasMatch(clean)) return false;
    } else {
      if (!_alphanumericCnpjRegex.hasMatch(clean)) return false;
    }

    if (_repeatedCnpjRegex.hasMatch(clean)) return false;

    const weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += (clean.codeUnitAt(i) - 48) * weights1[i];
    }
    final rest1 = sum % 11;
    final firstDigit = rest1 < 2 ? 0 : 11 - rest1;
    if (firstDigit != clean.codeUnitAt(12) - 48) return false;

    const weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
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
