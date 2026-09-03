/// Holds extracted pagination metadata from a response payload or headers.
class NanoPaginationMeta {
  /// Creates a [NanoPaginationMeta] instance.
  const NanoPaginationMeta({
    this.totalCount,
    this.currentPage,
    this.totalPages,
    this.hasNext,
    this.nextCursor,
    this.meta = const {},
  });

  /// The total number of items available across all pages.
  final int? totalCount;

  /// The active page number.
  final int? currentPage;

  /// Total number of pages available.
  final int? totalPages;

  /// Whether a subsequent page is available.
  final bool? hasNext;

  /// Next cursor or page token for cursor-based pagination.
  final String? nextCursor;

  /// Custom metadata map.
  final Map<String, dynamic> meta;
}
