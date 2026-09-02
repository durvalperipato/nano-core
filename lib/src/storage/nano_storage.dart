/// An abstract interface defining the standard contract for durable
/// key-value storage persistence without time-to-live expirations.
abstract class NanoStorage {
  /// Creates a [NanoStorage] instance.
  const NanoStorage();

  /// Retrieves a stored value of type [T] associated with [key].
  T? get<T>(String key);

  /// Saves a [value] of type [T] associated with [key].
  void set<T>(String key, T value);

  /// Deletes a stored value associated with [key].
  void delete(String key);

  /// Clears all stored values, optionally filtered by [prefix].
  void clear({String? prefix});

  /// Checks whether [key] exists in storage.
  bool has(String key);
}
