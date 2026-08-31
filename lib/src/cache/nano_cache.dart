/// An abstract contract defining key-value storage and retrieval for
/// cached data.
abstract interface class NanoCache {
  /// Retrieves a cached item by [key], returning `null` if not found or
  /// expired.
  T? get<T>(String key);

  /// Stores a [value] in cache under [key], optionally expiring after [ttl].
  void set<T>(String key, T value, {Duration? ttl});

  /// Deletes a single cached entry by [key].
  void delete(String key);

  /// Clears all entries from this cache or entries matching a given prefix.
  void clear({String? prefix});

  /// Checks whether a valid (non-expired) entry exists for [key].
  bool has(String key);
}
