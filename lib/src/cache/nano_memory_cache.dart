import 'nano_cache.dart';
import 'internal/nano_cache_entry.dart';

/// An in-memory, thread-safe [NanoCache] implementation with TTL expiration.
class NanoMemoryCache implements NanoCache {
  /// Creates a [NanoMemoryCache] instance.
  NanoMemoryCache({
    this.defaultTtl = const Duration(minutes: 5),
  });

  /// Default Time-To-Live duration for cached entries.
  final Duration? defaultTtl;

  final Map<String, NanoCacheEntry> _storage = {};

  @override
  T? get<T>(String key) {
    final entry = _storage[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _storage.remove(key);
      return null;
    }

    return entry.value as T?;
  }

  @override
  void set<T>(String key, T value, {Duration? ttl}) {
    final effectiveTtl = ttl ?? defaultTtl;
    final expiresAt =
        effectiveTtl != null ? DateTime.now().add(effectiveTtl) : null;

    _storage[key] = NanoCacheEntry(
      value: value,
      expiresAt: expiresAt,
    );
  }

  @override
  void delete(String key) => _storage.remove(key);

  @override
  void clear({String? prefix}) {
    if (prefix == null || prefix.isEmpty) {
      _storage.clear();
      return;
    }

    _storage.removeWhere((key, _) => key.startsWith(prefix));
  }

  @override
  bool has(String key) {
    final entry = _storage[key];
    if (entry == null) return false;

    if (entry.isExpired) {
      _storage.remove(key);
      return false;
    }

    return true;
  }
}
