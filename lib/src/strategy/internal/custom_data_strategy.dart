import '../nano_data_strategy.dart';

/// Internal implementation of [NanoDataStrategy] with custom extractor
/// functions.
class CustomDataStrategy extends NanoDataStrategy {
  /// Creates a [CustomDataStrategy] instance.
  const CustomDataStrategy({required this.listExtractor, this.metaExtractor});

  /// Custom list extractor function.
  final dynamic Function(dynamic rawData) listExtractor;

  /// Custom metadata extractor function.
  final NanoPaginationMeta Function(
    dynamic rawData,
    Map<String, dynamic>? headers,
  )?
  metaExtractor;

  @override
  dynamic extractList(dynamic rawData) => listExtractor(rawData);

  @override
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  ) => metaExtractor != null
      ? metaExtractor!(rawData, headers)
      : const NanoPaginationMeta();
}
