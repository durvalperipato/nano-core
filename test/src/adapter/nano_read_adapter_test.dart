import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class User {
  const User({required this.id, required this.name});
  final String id;
  final String name;
}

class UserReadAdapter with NanoReadAdapter<User> {
  const UserReadAdapter();

  @override
  User fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as String,
    name: map['name'] as String,
  );
}

void main() {
  group('NanoReadAdapter', () {
    const adapter = UserReadAdapter();

    test('fromMap deserializes map to entity', () {
      final user = adapter.fromMap({'id': 'u1', 'name': 'Alice'});
      expect(user.id, 'u1');
      expect(user.name, 'Alice');
    });

    test('fromMapOrNull returns null when given null', () {
      expect(adapter.fromMapOrNull(null), isNull);
    });

    test('fromMapOrNull converts valid dynamic map', () {
      final dynamic raw = <dynamic, dynamic>{'id': 'u2', 'name': 'Bob'};
      final user = adapter.fromMapOrNull(raw);
      expect(user?.id, 'u2');
      expect(user?.name, 'Bob');
    });

    test('fromMapOrNull throws ArgumentError for non-map input', () {
      expect(() => adapter.fromMapOrNull('not-a-map'), throwsArgumentError);
    });

    test('fromList deserializes list of maps and ignores nulls', () {
      final list = adapter.fromList([
        {'id': 'u1', 'name': 'Alice'},
        null,
        {'id': 'u2', 'name': 'Bob'},
      ]);

      expect(list.length, 2);
      expect(list[0].name, 'Alice');
      expect(list[1].name, 'Bob');
    });

    test('fromList returns empty list for non-list input', () {
      expect(adapter.fromList(null), isEmpty);
      expect(adapter.fromList('string'), isEmpty);
    });

    test('enumList deserializes valid enum strings and filters invalid', () {
      final result = adapter.enumList<Role>(
        ['admin', 'invalid', null, 'editor'],
        Role.values,
      );
      expect(result, equals([Role.admin, Role.editor]));
    });

    test('enumList returns null when raw is null or not a list', () {
      expect(adapter.enumList<Role>(null, Role.values), isNull);
      expect(adapter.enumList<Role>('not-a-list', Role.values), isNull);
    });
  });
}

enum Role { admin, editor, viewer }
