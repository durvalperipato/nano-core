import '../nano_data_strategy.dart';

/// Internal implementation of [NanoDataStrategy] for raw un-enveloped arrays.
class RawDataStrategy extends NanoDataStrategy {
  /// Creates a [RawDataStrategy] instance.
  const RawDataStrategy();

  @override
  dynamic extractList(dynamic rawData) => rawData;

  @override
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  ) {
    if (headers == null) return const NanoPaginationMeta();

    final totalStr = headers['x-total-count'] ?? headers['x-total'];
    final pageStr = headers['x-page'] ?? headers['x-current-page'];
    final pagesStr = headers['x-total-pages'];

    final totalCount = totalStr != null
        ? int.tryParse(totalStr.toString())
        : null;
    final currentPage = pageStr != null
        ? int.tryParse(pageStr.toString())
        : null;
    final totalPages = pagesStr != null
        ? int.tryParse(pagesStr.toString())
        : null;

    final hasNext = (currentPage != null && totalPages != null)
        ? currentPage < totalPages
        : null;

    return NanoPaginationMeta(
      totalCount: totalCount,
      currentPage: currentPage,
      totalPages: totalPages,
      hasNext: hasNext,
    );
  }
}
