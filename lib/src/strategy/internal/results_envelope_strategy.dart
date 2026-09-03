import '../nano_data_strategy.dart';

/// Internal implementation of [NanoDataStrategy] for Django REST responses with
/// `"results": [...]` envelope.
class ResultsEnvelopeStrategy extends NanoDataStrategy {
  /// Creates a [ResultsEnvelopeStrategy] instance.
  const ResultsEnvelopeStrategy();

  @override
  dynamic extractList(dynamic rawData) {
    if (rawData is Map) {
      if (!rawData.containsKey('results')) {
        throw ArgumentError(
          'NanoDataStrategy.results(): Key "results" was not found.',
        );
      }
      return rawData['results'];
    }
    return rawData;
  }

  @override
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  ) {
    if (rawData is! Map) return const NanoPaginationMeta();

    final count = rawData['count'];
    final next = rawData['next'];
    final totalCount = count != null ? int.tryParse(count.toString()) : null;
    final hasNext = next != null;

    return NanoPaginationMeta(
      totalCount: totalCount,
      hasNext: hasNext,
      nextCursor: next?.toString(),
    );
  }
}
