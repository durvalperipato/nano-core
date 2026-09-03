import '../equatable/nano_equatable.dart';

/// Represents a typed list response along with pagination and domain metadata.
class NanoPaginatedResult<Entity> extends NanoEquatable {
  /// Creates a [NanoPaginatedResult] instance.
  const NanoPaginatedResult({
    required this.items,
    this.totalCount,
    this.currentPage,
    this.totalPages,
    this.hasNext,
    this.nextCursor,
    this.meta = const {},
  });

  /// The strongly typed entities in this result page.
  final List<Entity> items;

  /// The total count of entities across all pages if reported by the API.
  final int? totalCount;

  /// The current page number.
  final int? currentPage;

  /// The total number of pages available.
  final int? totalPages;

  /// Whether a next page exists.
  final bool? hasNext;

  /// The next pagination cursor token.
  final String? nextCursor;

  /// Extra metadata dictionary.
  final Map<String, dynamic> meta;

  /// Whether the result contains no items.
  bool get isEmpty => items.isEmpty;

  /// Whether the result contains one or more items.
  bool get isNotEmpty => items.isNotEmpty;

  /// Number of items in this result page.
  int get length => items.length;

  /// Returns the item at [index].
  Entity operator [](int index) => items[index];

  @override
  List<Object?> get props => [
    items,
    totalCount,
    currentPage,
    totalPages,
    hasNext,
    nextCursor,
    meta,
  ];
}
