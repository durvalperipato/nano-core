import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoCorePlugin', () {
    test('registerWith executes without error', () {
      expect(NanoCorePlugin.registerWith, returnsNormally);
      expect(() => NanoCorePlugin.registerWith(null), returnsNormally);
    });
  });
}
