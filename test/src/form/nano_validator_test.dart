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
  });
}
