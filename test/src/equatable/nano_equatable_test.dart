import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class _SampleEquatable extends NanoEquatable {
  const _SampleEquatable(this.id, this.name, [this.tags = const []]);

  final int id;
  final String name;
  final List<String> tags;

  @override
  List<Object?> get props => [id, name, tags];
}

class _AnotherEquatable extends NanoEquatable {
  const _AnotherEquatable(this.id, this.name);

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

void main() {
  group('NanoEquatable', () {
    test('returns true for identical instances', () {
      const item = _SampleEquatable(1, 'Item');
      expect(item == item, isTrue);
    });

    test('returns true for instances with identical props', () {
      const item1 = _SampleEquatable(1, 'Item', ['tag1']);
      const item2 = _SampleEquatable(1, 'Item', ['tag1']);

      expect(item1 == item2, isTrue);
      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('returns false for instances with different props', () {
      const item1 = _SampleEquatable(1, 'Item');
      const item2 = _SampleEquatable(2, 'Item');

      expect(item1 == item2, isFalse);
    });

    test(
      'returns false when compared to non-NanoEquatable or different types',
      () {
        const item = _SampleEquatable(1, 'Item');
        const another = _AnotherEquatable(1, 'Item');

        expect((item as Object) == 'string', isFalse);
        expect(item == another, isFalse);
      },
    );

    test('default props list is empty', () {
      const base = NanoEquatable();
      expect(base.props, isEmpty);
      expect(base.hashCode, equals(Object.hashAll([])));
    });
  });
}
