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
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      if (!emailRegex.hasMatch(value.trim())) return message;
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
      final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (numbers.length != 11) return message;
      if (RegExp(r'^(\d)\1{10}$').hasMatch(numbers)) return message;

      var sum = 0;
      for (var i = 0; i < 9; i++) {
        sum += int.parse(numbers[i]) * (10 - i);
      }
      final firstDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
      if (firstDigit != int.parse(numbers[9])) return message;

      sum = 0;
      for (var i = 0; i < 10; i++) {
        sum += int.parse(numbers[i]) * (11 - i);
      }
      final secondDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
      if (secondDigit != int.parse(numbers[10])) return message;

      return null;
    };
  }

  /// Validates Brazilian CNPJ format and check digits.
  static NanoValidatorFunction<String> cnpj(dynamic message) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (numbers.length != 14) return message;
      if (RegExp(r'^(\d)\1{13}$').hasMatch(numbers)) return message;

      const weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
      var sum = 0;
      for (var i = 0; i < 12; i++) {
        sum += int.parse(numbers[i]) * weights1[i];
      }
      final firstDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
      if (firstDigit != int.parse(numbers[12])) return message;

      const weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
      sum = 0;
      for (var i = 0; i < 13; i++) {
        sum += int.parse(numbers[i]) * weights2[i];
      }
      final secondDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
      if (secondDigit != int.parse(numbers[13])) return message;

      return null;
    };
  }

  /// Custom inline validator function.
  static NanoValidatorFunction<Value> custom<Value>(
    dynamic Function(Value? value) validatorFn,
  ) => validatorFn;
}
