import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoDataStrategy', () {
    test('RawDataStrategy extracts raw list directly', () {
      const strategy = NanoDataStrategy.raw();
      final list = [
        {'id': 1},
        {'id': 2},
      ];
      expect(strategy.extractList(list), equals(list));

      final meta = strategy.extractMeta(list, null);
      expect(meta.totalCount, isNull);
    });

    test('DataEnvelopeStrategy extracts data key and meta', () {
      const strategy = NanoDataStrategy.data();
      final raw = {
        'data': [
          {'id': 1},
        ],
        'meta': {'total': 50, 'current_page': 1, 'last_page': 5},
      };

      expect(
        strategy.extractList(raw),
        equals([
          {'id': 1},
        ]),
      );

      final meta = strategy.extractMeta(raw, null);
      expect(meta.totalCount, 50);
      expect(meta.currentPage, 1);
      expect(meta.totalPages, 5);
    });

    test('ResultsEnvelopeStrategy extracts results key for DRF', () {
      const strategy = NanoDataStrategy.results();
      final raw = {
        'count': 100,
        'next': 'https://api.com?page=2',
        'previous': null,
        'results': [
          {'id': 1},
        ],
      };

      expect(
        strategy.extractList(raw),
        equals([
          {'id': 1},
        ]),
      );

      final meta = strategy.extractMeta(raw, null);
      expect(meta.totalCount, 100);
      expect(meta.nextCursor, 'https://api.com?page=2');
    });

    test('ItemsEnvelopeStrategy extracts items and nextPageToken', () {
      const strategy = NanoDataStrategy.items();
      final raw = {
        'items': [
          {'id': 1},
        ],
        'nextPageToken': 'token_xyz',
      };

      expect(
        strategy.extractList(raw),
        equals([
          {'id': 1},
        ]),
      );

      final meta = strategy.extractMeta(raw, null);
      expect(meta.nextCursor, 'token_xyz');
    });

    test('KeyEnvelopeStrategy extracts custom key', () {
      const strategy = NanoDataStrategy.key('custom_events');
      final raw = {
        'custom_events': [
          {'id': 'evt_1'},
        ],
      };

      expect(
        strategy.extractList(raw),
        equals([
          {'id': 'evt_1'},
        ]),
      );
    });

    test('CustomDataStrategy uses custom lambdas', () {
      final strategy = NanoDataStrategy.custom(
        listExtractor: (data) => (data as Map)['my_list'],
        metaExtractor: (data, headers) =>
            const NanoPaginationMeta(totalCount: 99),
      );

      final raw = {
        'my_list': [1, 2, 3],
      };
      expect(strategy.extractList(raw), [1, 2, 3]);
      expect(strategy.extractMeta(raw, null).totalCount, 99);
    });
  });
}
