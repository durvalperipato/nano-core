/// Extension on [Map] for fluent and conditional entry additions.
extension NanoMapExtension on Map<String, dynamic> {
  /// Unconditionally adds [value] under [key] and returns `this` for
  /// method chaining.
  Map<String, dynamic> add(String key, dynamic value) {
    this[key] = value;
    return this;
  }

  /// Adds [value] under [key] only if [value] is not null, [condition] is
  /// true (defaults to true), and passes the [skipEmpty] check (defaults
  /// to true).
  ///
  /// When [skipEmpty] is true, empty strings `""`, empty iterables `[]`, and
  /// empty maps `{}` are excluded.
  ///
  /// Returns `this` to allow fluent method chaining.
  Map<String, dynamic> addIf(
    String key,
    dynamic value, {
    bool condition = true,
    bool skipEmpty = true,
  }) {
    if (!condition || value == null) return this;

    if (skipEmpty) {
      if (value is String && value.trim().isEmpty) return this;
      if (value is Iterable && value.isEmpty) return this;
      if (value is Map && value.isEmpty) return this;
    }

    this[key] = value;
    return this;
  }
}
