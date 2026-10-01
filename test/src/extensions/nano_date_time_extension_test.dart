import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoDateTimeExtension', () {
    test('timestampSeconds and timestampMillis extract Unix timestamps', () {
      final date = DateTime.fromMillisecondsSinceEpoch(
        1609459200000,
        isUtc: true,
      );
      expect(date.timestampSeconds, 1609459200);
      expect(date.timestampMillis, 1609459200000);
    });

    test('isToday returns true for current date', () {
      final now = DateTime.now();
      expect(now.isToday, isTrue);

      final otherYear = DateTime(now.year - 1, now.month, now.day);
      expect(otherYear.isToday, isFalse);
    });

    test('isYesterday and isTomorrow identify adjacent days', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));

      expect(yesterday.isYesterday, isTrue);
      expect(now.isYesterday, isFalse);

      expect(tomorrow.isTomorrow, isTrue);
      expect(now.isTomorrow, isFalse);
    });

    test('isSameDay compares calendar year, month and day', () {
      final d1 = DateTime(2026, 10, 1, 9, 30);
      final d2 = DateTime(2026, 10, 1, 18, 45);
      final d3 = DateTime(2026, 10, 2, 9, 30);

      expect(d1.isSameDay(d2), isTrue);
      expect(d1.isSameDay(d3), isFalse);
    });

    test('startOfDay and endOfDay clamp boundaries', () {
      final local = DateTime(2026, 10, 1, 14, 25, 30, 500);
      final start = local.startOfDay;
      final end = local.endOfDay;

      expect(start.year, 2026);
      expect(start.month, 10);
      expect(start.day, 1);
      expect(start.hour, 0);
      expect(start.minute, 0);
      expect(start.second, 0);
      expect(start.millisecond, 0);

      expect(end.hour, 23);
      expect(end.minute, 59);
      expect(end.second, 59);
      expect(end.millisecond, 999);
      expect(end.microsecond, 999);

      final utc = DateTime.utc(2026, 10, 1, 14, 25);
      expect(utc.startOfDay.isUtc, isTrue);
      expect(utc.endOfDay.isUtc, isTrue);
    });

    test('isPast and isFuture check chronological position against now', () {
      final past = DateTime.now().subtract(const Duration(hours: 1));
      final future = DateTime.now().add(const Duration(hours: 1));

      expect(past.isPast, isTrue);
      expect(past.isFuture, isFalse);

      expect(future.isPast, isFalse);
      expect(future.isFuture, isTrue);
    });

    test('isBetween verifies inclusive range', () {
      final start = DateTime(2026);
      final end = DateTime(2026, 1, 10);
      final mid = DateTime(2026, 1, 5);
      final before = DateTime(2025, 12, 31);
      final after = DateTime(2026, 1, 11);

      expect(mid.isBetween(start, end), isTrue);
      expect(start.isBetween(start, end), isTrue);
      expect(end.isBetween(start, end), isTrue);
      expect(before.isBetween(start, end), isFalse);
      expect(after.isBetween(start, end), isFalse);
    });
  });
}
