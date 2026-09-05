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

    test('cpf and cnpj validators', () {
      final cpf = NanoValidator.cpf('Invalid CPF');
      final cnpj = NanoValidator.cnpj('Invalid CNPJ');

      expect(cpf('111.111.111-11'), equals('Invalid CPF')); // repeated
      expect(cpf('52998224725'), isNull); // valid CPF test vector

      expect(cnpj('00000000000000'), equals('Invalid CNPJ')); // repeated
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
