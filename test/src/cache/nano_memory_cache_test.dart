import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoMemoryCache', () {
    test('get, set, has and delete work as expected', () {
      final cache = NanoMemoryCache();

      expect(cache.has('key1'), isFalse);
      expect(cache.get<String>('key1'), isNull);

      cache.set('key1', 'value1');
      expect(cache.has('key1'), isTrue);
      expect(cache.get<String>('key1'), equals('value1'));

      cache.delete('key1');
      expect(cache.has('key1'), isFalse);
      expect(cache.get<String>('key1'), isNull);
    });

    test('clear without prefix removes all entries', () {
      final cache = NanoMemoryCache()
        ..set('a', 1)
        ..set('b', 2)
        ..clear();
      expect(cache.has('a'), isFalse);
      expect(cache.has('b'), isFalse);
    });

    test('clear with prefix removes only matching entries', () {
      final cache = NanoMemoryCache()
        ..set('user.1', 'Alice')
        ..set('user.2', 'Bob')
        ..set('post.1', 'Hello')
        ..clear(prefix: 'user.');
      expect(cache.has('user.1'), isFalse);
      expect(cache.has('user.2'), isFalse);
      expect(cache.has('post.1'), isTrue);
    });

    test('expired entries return null and are evicted', () async {
      final cache = NanoMemoryCache(
        defaultTtl: const Duration(milliseconds: 10),
      )..set('expiring', 'data');
      expect(cache.get<String>('expiring'), 'data');

      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(cache.get<String>('expiring'), isNull);
      expect(cache.has('expiring'), isFalse);
    });
  });
}
