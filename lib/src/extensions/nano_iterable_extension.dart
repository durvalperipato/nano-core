/// Extension on [Iterable] for safe querying without external dependencies.
extension NanoIterableExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies the given predicate [test],
  /// or `null` if no such element was found.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Extension on [Iterable] of [Enum] for safe, nullable lookup by name.
extension NanoEnumIterableExtension<T extends Enum> on Iterable<T> {
  /// Returns the first enum value whose [Enum.name] equals [name],
  /// or `null` if [name] is `null` or no matching element is found.
  ///
  /// When [caseSensitive] is `false`, falls back to a case-insensitive
  /// comparison if an exact match is not found.
  T? byNameOrNull(String? name, {bool caseSensitive = true}) {
    if (name == null) return null;

    for (final element in this) {
      if (element.name == name) return element;
    }

    if (!caseSensitive) {
      final normalized = name.toLowerCase();
      for (final element in this) {
        if (element.name.toLowerCase() == normalized) return element;
      }
    }

    return null;
  }
}
