import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoDebouncer', () {
    test('executes action after specified duration', () async {
      final debouncer = NanoDebouncer(
        duration: const Duration(milliseconds: 50),
      );
      int counter = 0;

      expect(debouncer.isPending, isFalse);

      debouncer.run(() => counter++);
      expect(debouncer.isPending, isTrue);
      expect(counter, equals(0));

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(counter, equals(1));
      expect(debouncer.isPending, isFalse);
    });

    test('cancels previous action if called repeatedly', () async {
      final debouncer = NanoDebouncer(
        duration: const Duration(milliseconds: 50),
      );
      int counter = 0;

      debouncer
        ..run(() => counter += 1)
        ..run(() => counter += 10)
        ..run(() => counter += 100);

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(counter, equals(100));
    });

    test('cancel and dispose stop execution', () async {
      final debouncer = NanoDebouncer(
        duration: const Duration(milliseconds: 50),
      );
      int counter = 0;

      debouncer
        ..run(() => counter++)
        ..cancel();
      expect(debouncer.isPending, isFalse);

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(counter, equals(0));

      debouncer
        ..run(() => counter++)
        ..dispose();
      expect(debouncer.isPending, isFalse);
    });
  });
}
