import 'nano_pagination.dart';

/// Cursor and token based pagination strategy.
class NanoCursorPagination implements NanoPagination {
  /// Creates a [NanoCursorPagination] instance.
  const NanoCursorPagination({
    this.cursor,
    this.limit = 20,
    this.cursorKey = 'cursor',
    this.limitKey = 'limit',
  });

  /// The cursor or next token string identifying the page.
  final String? cursor;

  /// The number of items to return per page.
  final int limit;

  /// The query parameter key for the cursor (e.g. `cursor`, `after`, `token`).
  final String cursorKey;

  /// The query parameter key for the limit (e.g. `limit`, `size`).
  final String limitKey;

  /// Creates a copy of this pagination with modified properties.
  NanoCursorPagination copyWith({
    String? cursor,
    int? limit,
    String? cursorKey,
    String? limitKey,
  }) {
    return NanoCursorPagination(
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
      cursorKey: cursorKey ?? this.cursorKey,
      limitKey: limitKey ?? this.limitKey,
    );
  }

  @override
  Map<String, dynamic> toQueryParams() => {
        if (cursor != null && cursor!.isNotEmpty) cursorKey: cursor,
        limitKey: limit,
      };
}
