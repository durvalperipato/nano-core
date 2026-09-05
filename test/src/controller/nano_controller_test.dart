import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class _SampleViewState extends NanoViewState {
  const _SampleViewState({this.count = 0});

  final int count;

  @override
  List<Object?> get props => [count];
}

class _TestMessageKey implements NanoMessageKey {
  const _TestMessageKey(this.text);
  final String text;

  @override
  String Function(BuildContext) get message => (_) => text;
}

class _TestController extends NanoController<_SampleViewState> {
  _TestController() : super(initialState: const _SampleViewState());

  @override
  Future<void> init(String? id) async {}

  void increment() {
    emitLoaded(_SampleViewState(count: viewState.count + 1));
  }
}

void main() {
  group('NanoController', () {
    test('initializes with InitialState holding viewState', () {
      final controller = _TestController();
      expect(controller.state, isA<InitialState<_SampleViewState>>());
      expect(controller.viewState.count, equals(0));
    });

    test('emits state transitions and notifies listeners', () {
      final controller = _TestController();
      var notifications = 0;
      controller
        ..addListener(() => notifications++)
        ..increment();
      expect(controller.viewState.count, equals(1));
      expect(controller.state, isA<LoadedState<_SampleViewState>>());
      expect(notifications, equals(1));

      controller.emitLoading();
      expect(controller.state, isA<LoadingState<_SampleViewState>>());
      expect(notifications, equals(2));

      controller.emitSuccess(key: const _TestMessageKey('saved'));
      expect(controller.state, isA<SuccessState<_SampleViewState>>());
      expect(notifications, equals(3));

      controller.emitError(key: const _TestMessageKey('failed'));
      expect(controller.state, isA<ErrorState<_SampleViewState>>());
      expect(notifications, equals(4));

      controller.emitWarning(key: const _TestMessageKey('alert'));
      expect(controller.state, isA<WarningState<_SampleViewState>>());
      expect(notifications, equals(5));

      controller.emitCustom('payload');
      expect(controller.state, isA<CustomState<_SampleViewState, String>>());
      expect(notifications, equals(6));

      controller.dispose();
    });

    test('execute runs action and handles success/error', () async {
      final controller = _TestController();
      String? successVal;
      Object? errorVal;

      await controller.execute<String>(
        () async => 'data',
        onSuccess: (val) => successVal = val,
      );
      expect(successVal, equals('data'));

      await controller.execute<String>(
        () async => throw Exception('error'),
        onError: (err) => errorVal = err,
      );
      expect(errorVal, isA<Exception>());

      controller.dispose();
    });

    test('nanoCommand0 and nanoCommand1 lifecycle and disposal', () async {
      final controller = _TestController();

      final cmd0 = controller.nanoCommand0<int>(() async => 42);
      await cmd0.run();
      expect(cmd0.value, isA<LoadedState<int>>());
      expect(cmd0.value.data, equals(42));

      final cmd1 = controller.nanoCommand1<String, String>(
        (arg) async => 'Hello $arg',
      );
      await cmd1.run('World');
      expect(cmd1.value, isA<LoadedState<String>>());
      expect(cmd1.value.data, equals('Hello World'));

      controller.dispose();
    });
  });
}
