import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoMapExtension', () {
    test('add adds key-value pair and returns map for chaining', () {
      final map = <String, dynamic>{}.add('key1', 'val1').add('key2', 123);
      expect(map, equals({'key1': 'val1', 'key2': 123}));
    });

    test('addIf adds when condition is true and value is non-empty', () {
      final map = <String, dynamic>{}
          .addIf('valid', 'hello', condition: true)
          .addIf('falseCond', 'world', condition: false)
          .addIf('nullVal', null)
          .addIf('emptyString', '   ', skipEmpty: true)
          .addIf('emptyList', [], skipEmpty: true)
          .addIf('emptyMap', {}, skipEmpty: true)
          .addIf('keepEmptyString', '', skipEmpty: false);

      expect(
        map,
        equals({
          'valid': 'hello',
          'keepEmptyString': '',
        }),
      );
    });
  });
}
