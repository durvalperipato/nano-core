import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class MockViewState extends NanoViewState {
  const MockViewState(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

void main() {
  group('NanoListenableAdapter', () {
    test('notifies listeners when wrapped listenable updates', () {
      final notifier = ValueNotifier<int>(0);
      final adapter = NanoListenableAdapter<MockViewState>(
        listenable: notifier,
        stateGetter: () =>
            SuccessState(data: MockViewState('val-${notifier.value}')),
      );

      var notificationCount = 0;
      adapter.addListener(() => notificationCount++);

      expect(adapter.state, isA<SuccessState<MockViewState>>());
      expect(
        (adapter.state as SuccessState<MockViewState>).data?.value,
        'val-0',
      );

      notifier.value = 1;
      expect(notificationCount, 1);
      expect(
        (adapter.state as SuccessState<MockViewState>).data?.value,
        'val-1',
      );

      adapter.dispose();
      notifier.dispose();
    });
  });

  group('NanoStreamAdapter', () {
    test('updates state from stream events with mapper', () async {
      final controller = StreamController<int>();
      final adapter = NanoStreamAdapter<MockViewState, int>(
        stream: controller.stream,
        initialState: const InitialState(),
        mapper: (val) => SuccessState(data: MockViewState('num-$val')),
      );

      expect(adapter.state, isA<InitialState<MockViewState>>());

      var notified = false;
      adapter.addListener(() => notified = true);

      controller.add(42);
      await Future<void>.delayed(Duration.zero);

      expect(notified, isTrue);
      expect(adapter.state, isA<SuccessState<MockViewState>>());
      expect(
        (adapter.state as SuccessState<MockViewState>).data?.value,
        'num-42',
      );

      controller.addError(Exception('stream failure'));
      await Future<void>.delayed(Duration.zero);
      expect(adapter.state, isA<ErrorState<MockViewState>>());

      adapter.dispose();
      await controller.close();
    });

    test('updates state directly when event is NanoState and no mapper',
        () async {
      final controller = StreamController<NanoState<MockViewState>>();
      final adapter =
          NanoStreamAdapter<MockViewState, NanoState<MockViewState>>(
        stream: controller.stream,
        initialState: const InitialState(),
      );

      expect(adapter.state, isA<InitialState<MockViewState>>());

      controller.add(const SuccessState(data: MockViewState('direct')));
      await Future<void>.delayed(Duration.zero);

      expect(adapter.state, isA<SuccessState<MockViewState>>());
      expect(
        (adapter.state as SuccessState<MockViewState>).data?.value,
        'direct',
      );

      adapter.dispose();
      await controller.close();
    });
  });
}
