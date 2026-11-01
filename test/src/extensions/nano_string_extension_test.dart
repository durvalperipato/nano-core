import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoStringExtension', () {
    test('toDateTimeOrNull parses valid ISO-8601 string', () {
      const dateStr = '2026-10-30T10:00:00.000Z';
      final result = dateStr.toDateTimeOrNull();

      expect(result, isNotNull);
      expect(result?.year, equals(2026));
      expect(result?.month, equals(10));
      expect(result?.day, equals(30));
    });

    test('toDateTimeOrNull returns null for null string', () {
      const String? dateStr = null;
      expect(dateStr.toDateTimeOrNull(), isNull);
    });

    test('toDateTimeOrNull returns null for empty or whitespace string', () {
      expect(''.toDateTimeOrNull(), isNull);
      expect('   '.toDateTimeOrNull(), isNull);
    });

    test('toDateTimeOrNull returns null for invalid date string', () {
      expect('invalid-date'.toDateTimeOrNull(), isNull);
    });
  });
}
