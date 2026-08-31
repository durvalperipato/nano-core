import '../adapter/nano_query_adapter.dart';
import '../entity/nano_entity.dart';
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
  });

  /// The dedicated adapter used to serialize the query model [Q] into query
  /// parameters.
  final NanoQueryAdapter<Q> queryAdapter;

  /// Searches and retrieves a list of entities using a strongly-typed query
  /// model [Q].
  Future<List<T>> search(
    Q query, {
    Map<String, String>? headers,
  }) async {
    return getAll(
      queryParameters: queryAdapter.toQueryParams(query),
      headers: headers,
    );
  }
}
