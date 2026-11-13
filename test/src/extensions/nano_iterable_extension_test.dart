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

  group('NanoEnumIterableExtension', () {
    test('returns matching enum when found by exact name', () {
      final result = _SampleEnum.values.byNameOrNull('second');
      expect(result, equals(_SampleEnum.second));
    });

    test('returns null when name is not found', () {
      final result = _SampleEnum.values.byNameOrNull('invalid');
      expect(result, isNull);
    });

    test('returns null when name is null', () {
      final result = _SampleEnum.values.byNameOrNull(null);
      expect(result, isNull);
    });

    test('returns null when case does not match and caseSensitive is true', () {
      final result = _SampleEnum.values.byNameOrNull('SECOND');
      expect(result, isNull);
    });

    test(
      'returns matching enum when case does not match and caseSensitive is '
      'false',
      () {
        final result = _SampleEnum.values.byNameOrNull(
          'SECOND',
          caseSensitive: false,
        );
        expect(result, equals(_SampleEnum.second));
      },
    );
  });
}

enum _SampleEnum { first, second, third }
