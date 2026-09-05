import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoResult', () {
    test('NanoSuccess properties, fold and map', () {
      const result = NanoResult<int, String>.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals(42));
      expect(result.errorOrNull, isNull);

      final folded = result.fold(
        onSuccess: (data) => 'Value: $data',
        onFailure: (err) => 'Error: $err',
      );
      expect(folded, equals('Value: 42'));

      final mapped = result.map((data) => data * 2);
      expect(mapped.dataOrNull, equals(84));

      final mappedError = result.mapError((err) => 'Prefix: $err');
      expect(mappedError.dataOrNull, equals(42));
      expect(result.toString(), equals('NanoSuccess(42)'));
    });

    test('NanoFailure properties, fold and mapError', () {
      const result = NanoResult<int, String>.failure('Not Found');

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, equals('Not Found'));

      final folded = result.fold(
        onSuccess: (data) => 'Value: $data',
        onFailure: (err) => 'Error: $err',
      );
      expect(folded, equals('Error: Not Found'));

      final mapped = result.map((data) => data * 2);
      expect(mapped.isFailure, isTrue);
      expect(mapped.errorOrNull, equals('Not Found'));

      final mappedError = result.mapError((err) => 'Prefix: $err');
      expect(mappedError.errorOrNull, equals('Prefix: Not Found'));
      expect(result.toString(), equals('NanoFailure(Not Found)'));
    });

    test('run catches exceptions and returns NanoFailure', () {
      final successResult = NanoResult.run(() => 10 + 5);
      expect(successResult.isSuccess, isTrue);
      expect(successResult.dataOrNull, equals(15));

      final failureResult = NanoResult.run<int>(
        () => throw Exception('Sync fail'),
      );
      expect(failureResult.isFailure, isTrue);
      expect(failureResult.errorOrNull, isA<Exception>());
    });

    test('runAsync catches async exceptions and returns NanoFailure', () async {
      final successResult = await NanoResult.runAsync(
        () async => 'async result',
      );
      expect(successResult.isSuccess, isTrue);
      expect(successResult.dataOrNull, equals('async result'));

      final failureResult = await NanoResult.runAsync<String>(
        () async => throw StateError('Async fail'),
      );
      expect(failureResult.isFailure, isTrue);
      expect(failureResult.errorOrNull, isA<StateError>());
    });

    test('equality comparisons', () {
      const success1 = NanoSuccess<int, String>(10);
      const success2 = NanoSuccess<int, String>(10);
      const success3 = NanoSuccess<int, String>(20);

      expect(success1 == success2, isTrue);
      expect(success1 == success3, isFalse);
      expect(success1.hashCode, equals(success2.hashCode));

      const failure1 = NanoFailure<int, String>('err');
      const failure2 = NanoFailure<int, String>('err');
      const failure3 = NanoFailure<int, String>('other');

      expect(failure1 == failure2, isTrue);
      expect(failure1 == failure3, isFalse);
      expect(failure1.hashCode, equals(failure2.hashCode));
    });
  });
}
