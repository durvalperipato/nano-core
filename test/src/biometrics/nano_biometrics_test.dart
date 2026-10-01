import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'mock_nano_biometrics.dart';

void main() {
  group('NanoBiometricType', () {
    test('contains all expected modalities', () {
      expect(
        NanoBiometricType.values,
        containsAll([
          NanoBiometricType.face,
          NanoBiometricType.fingerprint,
          NanoBiometricType.iris,
          NanoBiometricType.weak,
          NanoBiometricType.strong,
        ]),
      );
    });
  });

  group('NanoBiometricOptions', () {
    test('instantiates with defaults and supports null fields for i18n', () {
      const options = NanoBiometricOptions();
      expect(options.reason, isNull);
      expect(options.cancelTitle, isNull);
      expect(options.sensitiveData, isTrue);
      expect(options.stickyAuth, isFalse);
      expect(options.biometricOnly, isFalse);
    });

    test('copyWith updates fields correctly', () {
      const initial = NanoBiometricOptions(
        reason: 'Initial reason',
        cancelTitle: 'Cancel',
      );

      final updated = initial.copyWith(
        reason: 'Updated reason',
        sensitiveData: false,
        stickyAuth: true,
        biometricOnly: true,
      );

      expect(updated.reason, 'Updated reason');
      expect(updated.cancelTitle, 'Cancel');
      expect(updated.sensitiveData, isFalse);
      expect(updated.stickyAuth, isTrue);
      expect(updated.biometricOnly, isTrue);
    });

    test('equatable value equality works as expected', () {
      const opt1 = NanoBiometricOptions(
        reason: 'Unlock',
        cancelTitle: 'Close',
      );

      const opt2 = NanoBiometricOptions(
        reason: 'Unlock',
        cancelTitle: 'Close',
      );

      const opt3 = NanoBiometricOptions(
        reason: 'Different',
        cancelTitle: 'Close',
      );

      expect(opt1, equals(opt2));
      expect(opt1.hashCode, equals(opt2.hashCode));
      expect(opt1, isNot(equals(opt3)));
    });
  });

  group('MockNanoBiometrics', () {
    late MockNanoBiometrics mock;

    setUp(() {
      mock = MockNanoBiometrics();
    });

    test('default responses and counter tracking', () async {
      expect(await mock.isAvailable(), isTrue);
      expect(mock.isAvailableCallCount, 1);

      final types = await mock.getAvailableTypes();
      expect(mock.getAvailableTypesCallCount, 1);
      expect(
        types,
        containsAll([
          NanoBiometricType.fingerprint,
          NanoBiometricType.face,
        ]),
      );

      const options = NanoBiometricOptions(reason: 'Test Auth');
      expect(await mock.authenticate(options), isTrue);
      expect(mock.authenticateCallCount, 1);
      expect(mock.lastOptionsUsed?.reason, 'Test Auth');
    });

    test('custom mock results and reset() behavior', () async {
      mock
        ..isAvailableResult = false
        ..authenticateResult = false
        ..availableTypesResult = [NanoBiometricType.iris];

      expect(await mock.isAvailable(), isFalse);
      expect(await mock.authenticate(), isFalse);
      expect(await mock.getAvailableTypes(), [NanoBiometricType.iris]);

      mock.reset();

      expect(mock.isAvailableCallCount, 0);
      expect(mock.authenticateCallCount, 0);
      expect(mock.getAvailableTypesCallCount, 0);
      expect(mock.lastOptionsUsed, isNull);
      expect(mock.isAvailableResult, isTrue);
      expect(mock.authenticateResult, isTrue);
    });

    test('simulates artificial delay', () async {
      mock.delay = const Duration(milliseconds: 50);
      final stopwatch = Stopwatch()..start();
      final result = await mock.authenticate();
      stopwatch.stop();

      expect(result, isTrue);
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(40));
    });

    test('throws simulated error when errorToThrow is set', () async {
      mock.errorToThrow = Exception('Hardware failure');

      expect(() => mock.isAvailable(), throwsA(isA<Exception>()));
      expect(() => mock.getAvailableTypes(), throwsA(isA<Exception>()));
      expect(() => mock.authenticate(), throwsA(isA<Exception>()));
    });
  });
}
