import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class InMemoryStorage extends NanoStorage {
  final Map<String, dynamic> _map = {};

  @override
  T? get<T>(String key) => _map[key] as T?;

  @override
  void set<T>(String key, T value) => _map[key] = value;

  @override
  void delete(String key) => _map.remove(key);

  @override
  void clear({String? prefix}) {
    if (prefix == null || prefix.isEmpty) {
      _map.clear();
    } else {
      _map.removeWhere((k, _) => k.startsWith(prefix));
    }
  }

  @override
  bool has(String key) => _map.containsKey(key);
}

void main() {
  group('NanoStorage Contract', () {
    test('get, set, has, delete and clear behave as expected', () {
      final storage = InMemoryStorage();

      expect(storage.has('token'), isFalse);
      expect(storage.get<String>('token'), isNull);

      storage.set('token', 'abc-123');
      expect(storage.has('token'), isTrue);
      expect(storage.get<String>('token'), 'abc-123');

      storage.delete('token');
      expect(storage.has('token'), isFalse);

      storage
        ..set('auth.token', 't1')
        ..set('auth.refresh', 'r1')
        ..set('user.id', 'u1')
        ..clear(prefix: 'auth.');
      expect(storage.has('auth.token'), isFalse);
      expect(storage.has('auth.refresh'), isFalse);
      expect(storage.has('user.id'), isTrue);

      storage.clear();
      expect(storage.has('user.id'), isFalse);
    });
  });
}
