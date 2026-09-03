import '../nano_data_strategy.dart';

/// Internal implementation of [NanoDataStrategy] for custom top-level key
/// envelopes.
class KeyEnvelopeStrategy extends NanoDataStrategy {
  /// Creates a [KeyEnvelopeStrategy] instance.
  const KeyEnvelopeStrategy(this.key, {this.metaKey});

  /// The custom key containing the list.
  final String key;

  /// The optional custom key containing pagination metadata.
  final String? metaKey;

  @override
  dynamic extractList(dynamic rawData) {
    if (rawData is Map) {
      if (!rawData.containsKey(key)) {
        throw ArgumentError(
          'NanoDataStrategy.key("$key"): Key "$key" was not found in response.',
        );
      }
      return rawData[key];
    }
    return rawData;
  }

  @override
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  ) {
    if (rawData is! Map || metaKey == null) return const NanoPaginationMeta();

    final meta = rawData[metaKey];
    if (meta is Map) {
      return NanoPaginationMeta(
        meta: Map<String, dynamic>.from(meta),
      );
    }
    return const NanoPaginationMeta();
  }
}
