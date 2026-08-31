/// Defines how repository requests interact with the caching layer.
enum NanoCachePolicy {
  /// Never reads from cache; always fetches from the network and updates
  /// the cache.
  networkOnly,

  /// Returns cached data if available and not expired; otherwise fetches from
  /// the network and saves the response in cache.
  cacheFirst,

  /// Attempts to fetch from the network first; falls back to cached data if the
  /// network request fails (e.g. offline, timeout, or server error).
  networkFirst,

  /// Only reads from local cache; never triggers a network request.
  cacheOnly,
}
