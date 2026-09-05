import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoEnvironment and NanoEnv', () {
    test('getString returns defaultValue when key is absent', () {
      expect(
        NanoEnvironment.getString('NON_EXISTING', defaultValue: 'default_val'),
        equals('default_val'),
      );
      expect(
        NanoEnv.getString('NON_EXISTING', defaultValue: 'env_alias'),
        equals('env_alias'),
      );
    });

    test('getBool returns defaultValue when key is absent', () {
      expect(
        NanoEnvironment.getBool('NON_EXISTING', defaultValue: true),
        isTrue,
      );
      expect(NanoEnv.getBool('NON_EXISTING', defaultValue: false), isFalse);
    });

    test('getInt returns defaultValue when key is absent', () {
      expect(
        NanoEnvironment.getInt('NON_EXISTING', defaultValue: 42),
        equals(42),
      );
      expect(NanoEnv.getInt('NON_EXISTING', defaultValue: 10), equals(10));
    });

    test('getDouble returns parsed value or defaultValue', () {
      expect(
        NanoEnvironment.getDouble('NON_EXISTING', defaultValue: 3.14),
        equals(3.14),
      );
      expect(
        NanoEnv.getDouble('NON_EXISTING', defaultValue: 9.99),
        equals(9.99),
      );
    });
  });
}
