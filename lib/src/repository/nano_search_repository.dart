import '../adapter/nano_query_adapter.dart';
import '../cache/nano_cache_policy.dart';
import '../entity/nano_entity.dart';
import '../pagination/nano_pagination.dart';
import 'nano_repository.dart';

/// A specialized generic repository supporting strongly-typed query and filter
/// parameters.
///
/// Extends [NanoRepository] by requiring a dedicated [NanoQueryAdapter] to
/// serialize query/filter objects of type [Q] into URL query parameter maps.
abstract class NanoSearchRepository<T extends NanoEntity<ID>, ID, Q>
    extends NanoRepository<T, ID> {
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

  /// The dedicated adapter used to serialize the query model [Q] into query
  /// parameters.
  final NanoQueryAdapter<Q> queryAdapter;

  /// Searches and retrieves a list of entities using a strongly-typed query
  /// model [Q], optionally applying [pagination] and [cachePolicy].
  Future<List<T>> search(
    Q query, {
    NanoPagination? pagination,
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, String>? headers,
  }) async {
    return getAll(
      pagination: pagination,
      cachePolicy: cachePolicy,
      cacheTtl: cacheTtl,
      queryParameters: queryAdapter.toQueryParams(query),
      headers: headers,
    );
  }
}
