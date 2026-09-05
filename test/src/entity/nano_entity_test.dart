import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class _UserEntity extends NanoEntity<String> {
  const _UserEntity({required this.name, super.id});

  final String name;

  @override
  List<Object?> get props => [id, name];
}

void main() {
  group('NanoEntity', () {
    test('supports optional id and props equality', () {
      const user1 = _UserEntity(id: '123', name: 'Alice');
      const user2 = _UserEntity(id: '123', name: 'Alice');
      const user3 = _UserEntity(id: '456', name: 'Alice');

      expect(user1.id, equals('123'));
      expect(user1 == user2, isTrue);
      expect(user1 == user3, isFalse);
    });

    test('handles null id gracefully', () {
      const userWithoutId = _UserEntity(name: 'Bob');
      expect(userWithoutId.id, isNull);
    });
  });
}
