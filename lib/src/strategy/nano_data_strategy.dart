import 'internal/custom_data_strategy.dart';
import 'internal/data_envelope_strategy.dart';
import 'internal/items_envelope_strategy.dart';
import 'internal/key_envelope_strategy.dart';
import 'internal/raw_data_strategy.dart';
import 'internal/results_envelope_strategy.dart';
import 'nano_pagination_meta.dart';

export 'nano_pagination_meta.dart';

/// Strategy for extracting list payloads and pagination metadata from raw HTTP
/// responses.
abstract class NanoDataStrategy {
  /// Const constructor.
  const NanoDataStrategy();

  /// Strategy for un-enveloped raw arrays `[...]` (GitHub API, FastAPI, Go).
  const factory NanoDataStrategy.raw() = RawDataStrategy;

  /// Strategy for JSON:API / Laravel responses with `"data": [...]` envelope.
  const factory NanoDataStrategy.data({String metaKey}) = DataEnvelopeStrategy;

  /// Strategy for Django REST Framework with `"results": [...]`, `"count"`,
  /// etc.
  const factory NanoDataStrategy.results() = ResultsEnvelopeStrategy;

  /// Strategy for Google Cloud APIs with `"items": [...]` and
  /// `"nextPageToken"`.
  const factory NanoDataStrategy.items() = ItemsEnvelopeStrategy;

  /// Strategy for custom top-level key envelopes (e.g. `"events": [...]`).
  const factory NanoDataStrategy.key(String key, {String? metaKey}) =
      KeyEnvelopeStrategy;

  /// Custom strategy delegating to a custom extractor function.
  const factory NanoDataStrategy.custom({
    required dynamic Function(dynamic rawData) listExtractor,
    NanoPaginationMeta Function(dynamic rawData, Map<String, dynamic>? headers)?
    metaExtractor,
  }) = CustomDataStrategy;

  /// Extracts the target list payload from [rawData].
  dynamic extractList(dynamic rawData);

  /// Extracts pagination metadata from [rawData] and optional HTTP [headers].
  NanoPaginationMeta extractMeta(
    dynamic rawData,
    Map<String, dynamic>? headers,
  );
}
