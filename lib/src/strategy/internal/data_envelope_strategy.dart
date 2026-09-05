import '../nano_data_strategy.dart';

/// Internal implementation of [NanoDataStrategy] for JSON:API responses with
/// `"data": [...]` envelope.
class DataEnvelopeStrategy extends NanoDataStrategy {
  /// Creates a [DataEnvelopeStrategy] instance.
  const DataEnvelopeStrategy({this.metaKey = 'meta'});

  /// The JSON key containing pagination metadata.
  final String metaKey;

  @override
  dynamic extractList(dynamic rawData) {
    if (rawData is Map) {
      if (!rawData.containsKey('data')) {
        throw ArgumentError(
          'NanoDataStrategy.data(): Key "data" was not found in response.',
        );
      }
      return rawData['data'];
    }
    return rawData;
  }

  @override
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  ) {
    if (rawData is! Map) return const NanoPaginationMeta();

    final meta = rawData[metaKey];
    if (meta is Map) {
      final total = meta['total'] ?? meta['total_count'] ?? meta['count'];
      final page = meta['current_page'] ?? meta['page'];
      final lastPage = meta['last_page'] ?? meta['total_pages'];
      final hasNext =
          meta['has_next'] ??
          (page != null && lastPage != null ? page < lastPage : null);

      return NanoPaginationMeta(
        totalCount: total != null ? int.tryParse(total.toString()) : null,
        currentPage: page != null ? int.tryParse(page.toString()) : null,
        totalPages: lastPage != null ? int.tryParse(lastPage.toString()) : null,
        hasNext: hasNext is bool ? hasNext : null,
        meta: Map<String, dynamic>.from(meta),
      );
    }

    return const NanoPaginationMeta();
  }
}
