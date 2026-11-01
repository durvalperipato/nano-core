import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoIterableExtension', () {
    test('returns first matching element when found', () {
      final list = ['alpha', 'beta', 'gamma'];
      final result = list.firstWhereOrNull((e) => e.startsWith('b'));
      expect(result, equals('beta'));
    });

    test('returns null when no element matches', () {
      final list = ['alpha', 'beta', 'gamma'];
      final result = list.firstWhereOrNull((e) => e == 'delta');
      expect(result, isNull);
    });

    test('returns null for empty iterable', () {
      final list = <String>[];
      final result = list.firstWhereOrNull((e) => true);
      expect(result, isNull);
    });
  });
}
