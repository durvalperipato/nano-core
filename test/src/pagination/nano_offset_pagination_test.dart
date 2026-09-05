import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoOffsetPagination and NanoCursorPagination', () {
    test('NanoOffsetPagination toQueryParams and copyWith', () {
      const offset = NanoOffsetPagination(page: 2, pageSize: 15);
      expect(offset.toQueryParams(), {'page': 2, 'pageSize': 15});

      final modified = offset.copyWith(
        page: 3,
        pageKey: '_page',
        sizeKey: '_limit',
      );
      expect(modified.toQueryParams(), {'_page': 3, '_limit': 15});
    });

    test('NanoCursorPagination toQueryParams and copyWith', () {
      const cursor = NanoCursorPagination(cursor: 'cursor_xyz', limit: 25);
      expect(cursor.toQueryParams(), {'cursor': 'cursor_xyz', 'limit': 25});

      const noCursor = NanoCursorPagination(limit: 10);
      expect(noCursor.toQueryParams(), {'limit': 10});

      final modified = cursor.copyWith(
        cursor: 'cursor_next',
        cursorKey: 'after',
        limitKey: 'first',
      );
      expect(modified.toQueryParams(), {'after': 'cursor_next', 'first': 25});
    });

    test('NanoPaginatedResult helper getters and props equality', () {
      const result = NanoPaginatedResult<String>(
        items: ['item1', 'item2'],
        totalCount: 100,
        currentPage: 1,
        totalPages: 50,
        hasNext: true,
        nextCursor: 'c_next',
      );

      expect(result.isNotEmpty, isTrue);
      expect(result.isEmpty, isFalse);
      expect(result.length, 2);
      expect(result[0], 'item1');
      expect(result[1], 'item2');

      const resultIdentical = NanoPaginatedResult<String>(
        items: ['item1', 'item2'],
        totalCount: 100,
        currentPage: 1,
        totalPages: 50,
        hasNext: true,
        nextCursor: 'c_next',
      );
      expect(result, equals(resultIdentical));
    });
  });
}
