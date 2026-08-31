/// An internal representation of a cached value and its optional
/// expiration timestamp.
class NanoCacheEntry {
  /// Creates a [NanoCacheEntry] instance.
  const NanoCacheEntry({
    required this.value,
    this.expiresAt,
  });

  /// The cached data payload.
  final dynamic value;

  /// The expiration timestamp for this entry.
  final DateTime? expiresAt;

  /// Whether this cached entry has exceeded its expiration time.
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
