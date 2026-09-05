import '../adapter/nano_write_adapter.dart';
import '../cache/nano_cache_policy.dart';
import '../entity/nano_entity.dart';
import '../pagination/nano_paginated_result.dart';
import '../pagination/nano_pagination.dart';
import '../strategy/nano_data_strategy.dart';
import 'nano_repository.dart';

/// A specialized generic repository supporting strongly-typed query and filter
/// parameters.
///
/// Extends [NanoRepository] by using a dedicated [NanoWriteAdapter] to
/// serialize query/filter objects of type [Query] into URL query parameter
/// maps via [NanoWriteAdapter.toMap].
abstract class NanoSearchRepository<Entity extends NanoEntity<Id>, Id, Query>
    extends NanoRepository<Entity, Id> {
  /// Creates a [NanoSearchRepository] instance.
  const NanoSearchRepository({
    required super.endpoint,
    required super.adapter,
    required this.queryAdapter,
    super.writeAdapter,
    super.dataStrategy,
    super.client,
    super.cache,
    super.cachePolicy,
    super.cacheTtl,
  });

  /// The dedicated adapter used to serialize the query model [Query] into query
  /// parameters.
  final NanoWriteAdapter<Query> queryAdapter;

  /// Searches and retrieves a [NanoPaginatedResult] of entities using a
  /// strongly-typed query model [Query], optionally applying [pagination],
  /// [cachePolicy], and [dataStrategy].
  Future<NanoPaginatedResult<Entity>> searchAll(
    Query query, {
    NanoPagination? pagination,
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, String>? headers,
    NanoDataStrategy? dataStrategy,
  }) {
    return getAll(
      pagination: pagination,
      cachePolicy: cachePolicy,
      cacheTtl: cacheTtl,
      queryParameters: queryAdapter.toMap(query),
      headers: headers,
      dataStrategy: dataStrategy,
    );
  }
}
