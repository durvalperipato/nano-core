import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class _TestMessageKey implements NanoMessageKey {
  const _TestMessageKey(this.id);
  final String id;

  @override
  String Function(BuildContext) get message =>
      (_) => id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestMessageKey &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('NanoState transitions and equality', () {
    test('InitialState transitions properly', () {
      const state = InitialState<String>(data: 'initial');
      expect(state.data, equals('initial'));

      final loading = state.toLoading();
      expect(loading, isA<LoadingState<String>>());
      expect(loading.data, equals('initial'));

      final loaded = state.toLoaded('loaded_val');
      expect(loaded, isA<LoadedState<String>>());
      expect(loaded.data, equals('loaded_val'));

      final success = state.toSuccess(
        key: const _TestMessageKey('success_key'),
      );
      expect(success, isA<SuccessState<String>>());
      expect(success.key, equals(const _TestMessageKey('success_key')));
      expect(success.data, equals('initial'));

      final error = state.toError(key: const _TestMessageKey('error_key'));
      expect(error, isA<ErrorState<String>>());
      expect(error.key, equals(const _TestMessageKey('error_key')));

      final warning = state.toWarning(key: const _TestMessageKey('warn_key'));
      expect(warning, isA<WarningState<String>>());
      expect(warning.key, equals(const _TestMessageKey('warn_key')));

      final custom = state.toCustom<int>(99);
      expect(custom, isA<CustomState<String, int>>());
      expect(custom.payload, equals(99));
    });

    test('State equality and props', () {
      const state1 = LoadedState<int>(100);
      const state2 = LoadedState<int>(100);
      const state3 = LoadedState<int>(200);

      expect(state1 == state2, isTrue);
      expect(state1 == state3, isFalse);
      expect(state1.hashCode, equals(state2.hashCode));

      const err1 = ErrorState<int>(_TestMessageKey('k1'), data: 10);
      const err2 = ErrorState<int>(_TestMessageKey('k1'), data: 10);
      const err3 = ErrorState<int>(_TestMessageKey('k2'), data: 10);

      expect(err1 == err2, isTrue);
      expect(err1 == err3, isFalse);
    });
  });
}
