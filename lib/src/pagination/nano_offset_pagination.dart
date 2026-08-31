import 'nano_pagination.dart';

/// Page and limit based pagination strategy (Offset-based).
class NanoOffsetPagination implements NanoPagination {
  /// Creates a [NanoOffsetPagination] instance.
  const NanoOffsetPagination({
    this.page = 1,
    this.pageSize = 20,
    this.pageKey = 'page',
    this.sizeKey = 'pageSize',
  });

  /// The current page number (1-based index).
  final int page;

  /// The number of items to return per page.
  final int pageSize;

  /// The query parameter key for the page number (e.g. `page`, `page_number`).
  final String pageKey;

  /// The query parameter key for the page size (e.g. `pageSize`, `limit`).
  final String sizeKey;

  /// Creates a copy of this pagination with modified properties.
  NanoOffsetPagination copyWith({
    int? page,
    int? pageSize,
    String? pageKey,
    String? sizeKey,
  }) {
    return NanoOffsetPagination(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      pageKey: pageKey ?? this.pageKey,
      sizeKey: sizeKey ?? this.sizeKey,
    );
  }

  @override
  Map<String, dynamic> toQueryParams() => {
        pageKey: page,
        sizeKey: pageSize,
      };
}
