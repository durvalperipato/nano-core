/// Holds arguments passed to a route during navigation.
class NanoRouteArgs {
  /// Creates a new [NanoRouteArgs] instance.
  const NanoRouteArgs({this.data});

  /// The raw arguments object provided to the route.
  final Object? data;

  /// Extracts a strongly typed value by key if [data] is a [Map].
  T? get<T>(String key) {
    final raw = data;
    if (raw is Map && raw.containsKey(key)) {
      final value = raw[key];
      if (value is T) return value;
    }
    return null;
  }

  /// Checks if [data] is a [Map] containing the given [key].
  bool has(String key) {
    final raw = data;
    if (raw is Map) {
      return raw.containsKey(key);
    }
    return false;
  }

  /// Casts [data] directly to the expected type [T].
  T? as<T>() {
    final raw = data;
    if (raw is T) return raw;
    return null;
  }
}
