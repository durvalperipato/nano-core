import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoCommand0 and NanoCommand1', () {
    test('NanoCommand0 runs successfully and triggers onSuccess', () async {
      int? successResult;
      final cmd = NanoCommand0<int>(
        () async => 100,
        onSuccess: (val) => successResult = val,
      );

      expect(cmd.value, isA<InitialState<int>>());

      final runFuture = cmd.run();
      expect(cmd.value, isA<LoadingState<int>>());

      await runFuture;
      expect(cmd.value, isA<LoadedState<int>>());
      expect(cmd.value.data, equals(100));
      expect(successResult, equals(100));

      cmd.dispose();
    });

    test('NanoCommand0 catches error and triggers onError', () async {
      Object? capturedError;
      final cmd = NanoCommand0<int>(
        () async => throw StateError('fail'),
        onError: (err) => capturedError = err,
      );

      await cmd.run();
      expect(capturedError, isA<StateError>());

      final cmdWithoutHandler = NanoCommand0<int>(
        () async => throw Exception('err'),
      );
      await cmdWithoutHandler.run();
      expect(cmdWithoutHandler.value, isA<ErrorState<int>>());

      cmd.dispose();
      cmdWithoutHandler.dispose();
    });

    test('NanoCommand1 executes with argument', () async {
      final cmd = NanoCommand1<int, String>(
        (arg) async => 'Calculated: ${arg * 2}',
      );

      await cmd.run(21);
      expect(cmd.value.data, equals('Calculated: 42'));

      cmd.dispose();
    });
  });
}
