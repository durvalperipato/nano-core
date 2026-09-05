import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class SampleViewState extends NanoViewState {
  const SampleViewState({required this.title, required this.count});

  final String title;
  final int count;

  @override
  List<Object?> get props => [title, count];
}

void main() {
  group('NanoViewState', () {
    test('props equality works as expected', () {
      const state1 = SampleViewState(title: 'Home', count: 1);
      const state2 = SampleViewState(title: 'Home', count: 1);
      const state3 = SampleViewState(title: 'Profile', count: 1);

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
      expect(state1, isNot(equals(state3)));
    });

    test('props list contains all declared properties', () {
      const state = SampleViewState(title: 'Dashboard', count: 42);
      expect(state.props, equals(['Dashboard', 42]));
    });
  });
}
