import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoValidator', () {
    test('required validator detects null, empty and whitespace strings', () {
      final val = NanoValidator.required<String>('Field is required');

      expect(val(null), equals('Field is required'));
      expect(val(''), equals('Field is required'));
      expect(val('   '), equals('Field is required'));
      expect(val('valid text'), isNull);
    });

    test('email validator checks standard format', () {
      final val = NanoValidator.email('Invalid email');

      expect(val(null), isNull); // optional if null/empty
      expect(val(''), isNull);
      expect(val('not-an-email'), equals('Invalid email'));
      expect(val('test@example.com'), isNull);
      expect(val('user.name+tag@sub.domain.org'), isNull);
    });

    test('minLength and maxLength validators', () {
      final min = NanoValidator.minLength(5, 'Too short');
      final max = NanoValidator.maxLength(5, 'Too long');

      expect(min('1234'), equals('Too short'));
      expect(min('12345'), isNull);
      expect(min('123456'), isNull);

      expect(max('12345'), isNull);
      expect(max('123456'), equals('Too long'));
    });

    test('min and max numeric validators', () {
      final min = NanoValidator.min(10, 'Must be at least 10');
      final max = NanoValidator.max(10, 'Must be at most 10');

      expect(min(9), equals('Must be at least 10'));
      expect(min(10), isNull);
      expect(min(11), isNull);

      expect(max(10), isNull);
      expect(max(11), equals('Must be at most 10'));
    });

    group('CPF validator', () {
      final cpf = NanoValidator.cpf('Invalid CPF');

      test('validates valid CPF with and without mask', () {
        expect(cpf('529.982.247-25'), isNull);
        expect(cpf('52998224725'), isNull);
      });

      test('rejects invalid CPF and repeated digits', () {
        expect(cpf('111.111.111-11'), equals('Invalid CPF'));
        expect(cpf('00000000000'), equals('Invalid CPF'));
        expect(cpf('529.982.247-26'), equals('Invalid CPF'));
        expect(cpf('123456789'), equals('Invalid CPF'));
      });

      test('handles null and empty as valid (optional)', () {
        expect(cpf(null), isNull);
        expect(cpf(''), isNull);
        expect(cpf('   '), isNull);
      });
    });

    group('CNPJ validator', () {
      final cnpj = NanoValidator.cnpj('Invalid CNPJ');
      final strictCnpj = NanoValidator.cnpj(
        'Invalid CNPJ',
        allowAlphanumeric: false,
      );

      test('validates legacy numeric CNPJ with and without mask', () {
        expect(cnpj('00.000.000/0001-91'), isNull);
        expect(cnpj('00000000000191'), isNull);
        expect(cnpj('11.222.333/0001-81'), isNull);
      });

      test('validates alphanumeric CNPJ according to IN RFB 2.229/2024', () {
        // 12.ABC.345/01DE-35 is mathematically valid under (codeUnit - 48) modulo 11
        expect(cnpj('12.ABC.345/01DE-35'), isNull);
        expect(cnpj('12.abc.345/01de-35'), isNull); // case insensitive
        expect(cnpj('12ABC34501DE35'), isNull);
      });

      test('rejects alphanumeric CNPJ when allowAlphanumeric is false', () {
        expect(strictCnpj('12.ABC.345/01DE-35'), equals('Invalid CNPJ'));
        expect(strictCnpj('00.000.000/0001-91'), isNull); // numeric still works
      });

      test('rejects invalid check digits', () {
        expect(cnpj('00.000.000/0001-92'), equals('Invalid CNPJ'));
        expect(cnpj('12.ABC.345/01DE-36'), equals('Invalid CNPJ'));
      });

      test('rejects repeated character sequences', () {
        expect(cnpj('00000000000000'), equals('Invalid CNPJ'));
        expect(cnpj('11.111.111/1111-11'), equals('Invalid CNPJ'));
        expect(cnpj('AA.AAA.AAA/AAAA-AA'), equals('Invalid CNPJ'));
      });

      test('rejects letters in the check digit positions', () {
        // Positions 13 and 14 must always be digits
        expect(cnpj('12.ABC.345/01DE-AB'), equals('Invalid CNPJ'));
      });

      test('handles null and empty as valid (optional)', () {
        expect(cnpj(null), isNull);
        expect(cnpj(''), isNull);
        expect(cnpj('   '), isNull);
      });
    });

    group('cpfOrCnpj validator', () {
      final validator = NanoValidator.cpfOrCnpj('Invalid Document');

      test('validates valid CPF', () {
        expect(validator('529.982.247-25'), isNull);
        expect(validator('52998224725'), isNull);
      });

      test('validates valid numeric CNPJ', () {
        expect(validator('00.000.000/0001-91'), isNull);
      });

      test('validates valid alphanumeric CNPJ', () {
        expect(validator('12.ABC.345/01DE-35'), isNull);
      });

      test('rejects invalid lengths and invalid checksums', () {
        // 10 digits
        expect(validator('1234567890'), equals('Invalid Document'));
        // 12 chars
        expect(validator('123456789012'), equals('Invalid Document'));
        // bad CPF
        expect(validator('529.982.247-26'), equals('Invalid Document'));
        // bad CNPJ
        expect(validator('00.000.000/0001-92'), equals('Invalid Document'));
      });

      test('handles null and empty as valid (optional)', () {
        expect(validator(null), isNull);
        expect(validator(''), isNull);
      });
    });

    test('custom and pattern validator', () {
      final custom = NanoValidator.custom<int>(
        (val) => (val != null && val % 2 == 0) ? null : 'Must be even',
      );
      expect(custom(3), equals('Must be even'));
      expect(custom(4), isNull);

      final pattern = NanoValidator.pattern(
        r'^[A-Z]{3}$',
        'Must be 3 uppercase',
      );
      expect(pattern('abc'), equals('Must be 3 uppercase'));
      expect(pattern('ABC'), isNull);
    });

    group('creditCard validator', () {
      final validator = NanoValidator.creditCard('Invalid Credit Card');

      test(
        'validates valid credit card numbers with and without formatting',
        () {
          // Standard 16 digits (Visa)
          expect(validator('4532 0151 1283 0366'), isNull);
          expect(validator('4532-0151-1283-0366'), isNull);
          expect(validator('4532015112830366'), isNull);

          // Mastercard
          expect(validator('5454 5454 5454 5454'), isNull);

          // 15 digits (Amex)
          expect(validator('378282246310005'), isNull);
        },
      );

      test('rejects invalid Luhn checksum', () {
        expect(validator('4532 0151 1283 0367'), equals('Invalid Credit Card'));
      });

      test('rejects invalid lengths', () {
        // 12 digits (too short by default)
        expect(validator('453201511283'), equals('Invalid Credit Card'));
        // 20 digits (too long)
        expect(
          validator('45320151128303661234'),
          equals('Invalid Credit Card'),
        );
      });

      test('rejects invalid characters', () {
        expect(validator('4532 0151 1283 036A'), equals('Invalid Credit Card'));
        expect(validator('4532@0151#1283!0366'), equals('Invalid Credit Card'));
      });

      test('handles null and empty as valid (optional)', () {
        expect(validator(null), isNull);
        expect(validator(''), isNull);
        expect(validator('   '), isNull);
      });
    });

    group('creditCardExpiration validator', () {
      final fixedDate = DateTime(2026, 9, 13);
      final validator = NanoValidator.creditCardExpiration(
        'Invalid Expiration',
        now: () => fixedDate,
      );

      test('validates current month and future dates', () {
        // Current month and year is valid until the end of the month
        expect(validator('09/26'), isNull);
        expect(validator('09/2026'), isNull);
        expect(validator('9/26'), isNull);
        expect(validator('09-26'), isNull);

        // Future dates
        expect(validator('10/26'), isNull);
        expect(validator('01/27'), isNull);
        expect(validator('12/2030'), isNull);
      });

      test('rejects past expiration dates', () {
        // Previous month of same year
        expect(validator('08/26'), equals('Invalid Expiration'));
        // Past year
        expect(validator('12/25'), equals('Invalid Expiration'));
        expect(validator('01/2020'), equals('Invalid Expiration'));
      });

      test('rejects invalid month numbers', () {
        expect(validator('00/26'), equals('Invalid Expiration'));
        expect(validator('13/26'), equals('Invalid Expiration'));
      });

      test('rejects malformed date strings', () {
        expect(validator('2026/09'), equals('Invalid Expiration'));
        expect(validator('invalid'), equals('Invalid Expiration'));
        expect(validator('09/2'), equals('Invalid Expiration'));
      });

      test('handles null and empty as valid (optional)', () {
        expect(validator(null), isNull);
        expect(validator(''), isNull);
        expect(validator('   '), isNull);
      });
    });

    group('creditCardCvv validator', () {
      final validator = NanoValidator.creditCardCvv('Invalid CVV');

      test('validates 3 and 4 digit CVVs', () {
        expect(validator('123'), isNull);
        expect(validator('1234'), isNull);
      });

      test('rejects invalid lengths and characters', () {
        expect(validator('12'), equals('Invalid CVV'));
        expect(validator('12345'), equals('Invalid CVV'));
        expect(validator('12a'), equals('Invalid CVV'));
        expect(validator('abc'), equals('Invalid CVV'));
      });

      test('handles custom minLength and maxLength', () {
        final exactThreeCvv = NanoValidator.creditCardCvv(
          'CVV must be exactly 3 digits',
          maxLength: 3,
        );
        expect(exactThreeCvv('123'), isNull);
        expect(exactThreeCvv('1234'), equals('CVV must be exactly 3 digits'));
      });

      test('handles null and empty as valid (optional)', () {
        expect(validator(null), isNull);
        expect(validator(''), isNull);
        expect(validator('   '), isNull);
      });
    });

    group('NanoValidatorPatterns and Constants', () {
      test('constants expose expected values', () {
        expect(NanoValidatorConstants.cpfLength, equals(11));
        expect(NanoValidatorConstants.cnpjLength, equals(14));
        expect(NanoValidatorConstants.creditCardMinLength, equals(13));
        expect(NanoValidatorConstants.creditCardMaxLength, equals(19));
        expect(NanoValidatorConstants.creditCardCvvMinLength, equals(3));
        expect(NanoValidatorConstants.creditCardCvvMaxLength, equals(4));
        expect(
          NanoValidatorConstants.cnpjWeightsFirstDigit.length,
          equals(12),
        );
        expect(
          NanoValidatorConstants.cnpjWeightsSecondDigit.length,
          equals(13),
        );
      });

      test('regexes can be used in custom pattern validators', () {
        final emailValidator = NanoValidator.pattern(
          NanoValidatorRegex.email,
          'Custom invalid email',
        );
        expect(emailValidator('test@example.com'), isNull);
        expect(emailValidator('invalid'), equals('Custom invalid email'));
      });
    });
  });
}
