import '../adapter/nano_query_adapter.dart';
import '../cache/nano_cache_policy.dart';
import '../entity/nano_entity.dart';
import '../pagination/nano_pagination.dart';
import 'nano_repository.dart';

/// A specialized generic repository supporting strongly-typed query and filter
/// parameters.
///
/// Extends [NanoRepository] by requiring a dedicated [NanoQueryAdapter] to
/// serialize query/filter objects of type [Query] into URL query parameter
/// maps.
abstract class NanoSearchRepository<
  Entity extends NanoEntity<Id>,
  Id,
  Query
>
    extends NanoRepository<Entity, Id> {
  /// Creates a [NanoSearchRepository] instance.
  const NanoSearchRepository({
    required super.endpoint,
    required super.adapter,
    required this.queryAdapter,
    super.client,
    super.cache,
    super.cachePolicy,
    super.cacheTtl,
  });

  /// The dedicated adapter used to serialize the query model [Query] into query
  /// parameters.
  final NanoQueryAdapter<Query> queryAdapter;

  /// Builds the endpoint URL path used for [search]. Defaults to
  /// [endpointGetAll].
  String endpointSearch(Query query) => endpointGetAll();

  /// Searches and retrieves a list of entities using a strongly-typed query
  /// model [Query], optionally applying [pagination] and [cachePolicy].
  Future<List<Entity>> search(
    Query query, {
    NanoPagination? pagination,
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, String>? headers,
  }) =>
      fetchList(
        path: endpointSearch(query),
        pagination: pagination,
        cachePolicy: cachePolicy,
        cacheTtl: cacheTtl,
        queryParameters: queryAdapter.toQueryParams(query),
        headers: headers,
      );
}
