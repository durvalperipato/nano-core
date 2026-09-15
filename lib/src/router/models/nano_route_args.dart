/// Holds arguments passed to a route during navigation.
///
/// Supports in-memory [data], dynamic route [pathParameters], and URL
/// [queryParameters].
class NanoRouteArgs {
  /// Creates a new [NanoRouteArgs] instance.
  const NanoRouteArgs({
    this.data,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  /// The raw arguments object provided to the route in memory.
  final Object? data;

  /// Dynamic path parameters extracted from URL patterns (e.g. `{'id': '42'}`).
  final Map<String, String> pathParameters;

  /// Query parameters extracted from the route URL (e.g. `{'tab': 'reviews'}`).
  final Map<String, String> queryParameters;

  /// Retrieves a path parameter by [key].
  String? pathParam(String key) => pathParameters[key];

  /// Retrieves a query parameter by [key].
  String? queryParam(String key) => queryParameters[key];

  /// Retrieves a query parameter as an [int] or returns [defaultValue].
  int? queryParamInt(String key, {int? defaultValue}) {
    final value = queryParameters[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// Retrieves a query parameter as a [bool] or returns [defaultValue].
  ///
  /// Considers `'true'`, `'1'`, `'yes'` (case-insensitive) as `true`.
  bool? queryParamBool(String key, {bool? defaultValue}) {
    final value = queryParameters[key]?.toLowerCase();
    if (value == null) return defaultValue;
    if (value == 'true' || value == '1' || value == 'yes') return true;
    if (value == 'false' || value == '0' || value == 'no') return false;
    return defaultValue;
  }

  /// Retrieves a query parameter as a [double] or returns [defaultValue].
  double? queryParamDouble(String key, {double? defaultValue}) {
    final value = queryParameters[key];
    if (value == null) return defaultValue;
    return double.tryParse(value) ?? defaultValue;
  }

  /// Extracts a strongly typed value by key if [data] is a [Map], falling
  /// back to [pathParameters] or [queryParameters] if present.
  T? get<T>(String key) {
    final raw = data;
    if (raw is Map && raw.containsKey(key)) {
      final value = raw[key];
      if (value is T) return value;
    }
    if (pathParameters.containsKey(key)) {
      final value = pathParameters[key];
      if (value is T) return value as T;
      if (T == int) return int.tryParse(value!) as T?;
      if (T == double) return double.tryParse(value!) as T?;
    }
    if (queryParameters.containsKey(key)) {
      final value = queryParameters[key];
      if (value is T) return value as T;
      if (T == int) return int.tryParse(value!) as T?;
      if (T == double) return double.tryParse(value!) as T?;
      if (T == bool) {
        final lower = value!.toLowerCase();
        if (lower == 'true' || lower == '1' || lower == 'yes') {
          return true as T?;
        }
        if (lower == 'false' || lower == '0' || lower == 'no') {
          return false as T?;
        }
      }
    }
    return null;
  }

  /// Checks if [data] is a [Map] containing the given [key], or if it exists
  /// in [pathParameters] or [queryParameters].
  bool has(String key) {
    final raw = data;
    if (raw is Map && raw.containsKey(key)) {
      return true;
    }
    return pathParameters.containsKey(key) || queryParameters.containsKey(key);
  }

  /// Casts [data] directly to the expected type [T].
  T? as<T>() {
    final raw = data;
    if (raw is T) return raw;
    return null;
  }
}
