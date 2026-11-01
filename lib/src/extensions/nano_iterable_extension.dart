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
