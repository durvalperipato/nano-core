import '../nano_data_strategy.dart';

/// Internal implementation of [NanoDataStrategy] for Google APIs with
/// `"items": [...]` envelope.
class ItemsEnvelopeStrategy extends NanoDataStrategy {
  /// Creates an [ItemsEnvelopeStrategy] instance.
  const ItemsEnvelopeStrategy();

  @override
  dynamic extractList(dynamic rawData) {
    if (rawData is Map) {
      if (!rawData.containsKey('items')) {
        throw ArgumentError(
          'NanoDataStrategy.items(): Key "items" was not found in response.',
        );
      }
      return rawData['items'];
    }
    return rawData;
  }

  @override
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  ) {
    if (rawData is! Map) return const NanoPaginationMeta();

    final totalResults = rawData['totalResults'] ?? rawData['total'];
    final nextToken = rawData['nextPageToken'];
    final totalCount = totalResults != null
        ? int.tryParse(totalResults.toString())
        : null;

    return NanoPaginationMeta(
      totalCount: totalCount,
      nextCursor: nextToken?.toString(),
      hasNext: nextToken != null,
    );
  }
}
